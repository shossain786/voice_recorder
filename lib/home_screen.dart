import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_sound/flutter_sound.dart';

import 'widgets/buttom_nv_bar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Voice Recorder'),
      ),
      body: const SafeArea(
        child: RecorderExample(),
      ),
      bottomNavigationBar: const MyBottomNavBar(),
    );
  }
}

class RecorderExample extends StatefulWidget {
  const RecorderExample({super.key});

  @override
  State<StatefulWidget> createState() => RecorderExampleState();
}

class RecorderExampleState extends State<RecorderExample> {
  FlutterSoundRecorder? _recorder;
  StreamSubscription? _recorderSubscription;
  bool _isRecording = false;
  final List<double> _audioLevels = [];
  String? _filePath;
  Timer? _timer;
  DateTime? _startTime;
  Duration _duration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  void dispose() {
    _recorderSubscription?.cancel();
    _recorder?.closeRecorder();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              _formatDuration(_duration),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      if (_isRecording) {
                        _pause();
                      } else if (_recorder!.isPaused) {
                        _resume();
                      } else {
                        _start();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: _buildText(),
                  ),
                ),
                Visibility(
                  visible: _isRecording ||
                      (_recorder != null && _recorder!.isPaused),
                  child: ElevatedButton(
                    onPressed: _stop,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text(
                      "Stop",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _init() async {
    try {
      _recorder = FlutterSoundRecorder();
      await _recorder!.openRecorder();
      if (await _recorder!.isEncoderSupported(Codec.pcm16WAV)) {
        _recorderSubscription = _recorder!.onProgress!.listen((event) {
          double normalizedLevel = (event.decibels ?? 0) / 120;
          if (_audioLevels.length >= 100) {
            _audioLevels.removeAt(0);
          }
          _audioLevels.add(normalizedLevel);
          debugPrint('Audio Levels: $_audioLevels'); // Debugging print
          setState(() {});
        });
      } else {
        throw Exception("PCM format is not supported on this device");
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> _start() async {
    try {
      io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
      String currentTime =
          DateFormat('dd_MM_yyyy_HH_mm_ss').format(DateTime.now());
      _filePath = '${appDocDirectory.path}/voice_recording_$currentTime.wav';

      await _recorder!.startRecorder(
        toFile: _filePath,
        codec: Codec.pcm16WAV,
      );

      _startTime = DateTime.now();
      _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
        setState(() {
          _duration = DateTime.now().difference(_startTime!);
          debugPrint('Duration: $_duration'); // Debugging print
        });
      });

      setState(() {
        _isRecording = true;
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  Future<void> _resume() async {
    await _recorder!.resumeRecorder();
    _startTime = DateTime.now().subtract(_duration);
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      setState(() {
        _duration = DateTime.now().difference(_startTime!);
        debugPrint('Duration: $_duration'); // Debugging print
      });
    });
    setState(() {
      _isRecording = true;
    });
  }

  Future<void> _pause() async {
    await _recorder!.pauseRecorder();
    _timer?.cancel();
    setState(() {
      _isRecording = false;
    });
  }

  Future<void> _stop() async {
    await _recorder!.stopRecorder();
    _recorderSubscription?.cancel();
    _timer?.cancel();
    setState(() {
      _isRecording = false;
      _audioLevels.clear();
      _duration = Duration.zero;
    });
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');

    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    final milliseconds =
        threeDigits((duration.inMilliseconds % 1000)); // Corrected calculation
    return '$hours:$minutes:$seconds:$milliseconds';
  }

  Widget _buildText() {
    String text = _isRecording
        ? 'Pause'
        : (_recorder != null && _recorder!.isPaused)
            ? 'Resume'
            : 'Start';
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 18,
        letterSpacing: 1.3,
      ),
    );
  }

  void onPlayAudio() async {
    if (_filePath != null) {
      AudioPlayer audioPlayer = AudioPlayer();
      await audioPlayer.play(DeviceFileSource(_filePath!));
    }
  }
}
