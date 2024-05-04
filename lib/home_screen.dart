import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:file/local.dart';
import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:intl/intl.dart';

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
  final LocalFileSystem localFileSystem;

  const RecorderExample({super.key, localFileSystem})
      : localFileSystem = localFileSystem ?? const LocalFileSystem();

  @override
  State<StatefulWidget> createState() => RecorderExampleState();
}

class RecorderExampleState extends State<RecorderExample> {
  AnotherAudioRecorder? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  AudioPlayer naatPlayer = AudioPlayer();
  bool buttonPressed = false;
  bool _isRecording = false;

  @override
  void initState() {
    super.initState();
    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    onPressed: () {
                      switch (_currentStatus) {
                        case RecordingStatus.Initialized:
                          {
                            _start();
                            break;
                          }
                        case RecordingStatus.Recording:
                          {
                            _pause();
                            break;
                          }
                        case RecordingStatus.Paused:
                          {
                            _resume();
                            break;
                          }
                        case RecordingStatus.Stopped:
                          {
                            _init();
                            break;
                          }
                        default:
                          break;
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: _buildText(
                      _currentStatus,
                    ),
                  ),
                ),
                Visibility(
                  visible: _isRecording,
                  child: ElevatedButton(
                    onPressed:
                        _currentStatus != RecordingStatus.Unset ? _stop : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: const Text(
                      "Stop",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        letterSpacing: 1.3,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onPlayAudio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                  child: const Text(
                    "Play",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      letterSpacing: 1.3,
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

  _init() async {
    String formattedDateTime =
        DateFormat('dd-MM-yyyyTHH:mm:ss').format(DateTime.now());
    try {
      if (await AnotherAudioRecorder.hasPermissions) {
        String customPath = '/MyRecording_$formattedDateTime';
        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();

        customPath = appDocDirectory.path + customPath;
        _recorder =
            AnotherAudioRecorder(customPath, audioFormat: AudioFormat.WAV);

        await _recorder?.initialized;
        var current = await _recorder?.current(channel: 0);
        debugPrint('$current');
        setState(() {
          _current = current;
          _currentStatus = current!.status!;
          debugPrint('$_currentStatus');
        });
      } else {
        return const SnackBar(content: Text("You must accept permissions"));
      }
    } catch (e) {
      debugPrint('$e');
    }
  }

  _start() async {
    try {
      await _recorder?.start();
      var recording = await _recorder?.current(channel: 0);
      setState(() {
        _current = recording;
        _isRecording = true;
      });

      const tick = Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }
        var current = await _recorder?.current(channel: 0);
        setState(() {
          _current = current;
          _currentStatus = _current!.status!;
        });
      });
    } catch (e) {
      debugPrint('$e');
    }
  }

  _resume() async {
    await _recorder?.resume();
    setState(() {});
  }

  _pause() async {
    await _recorder?.pause();
    setState(() {});
  }

  _stop() async {
    var result = await _recorder?.stop();
    setState(
      () {
        _current = result;
        _currentStatus = _current!.status!;
        _isRecording = false;
      },
    );
  }

  Widget _buildText(RecordingStatus status) {
    var text = "";
    switch (_currentStatus) {
      case RecordingStatus.Initialized:
        {
          text = 'Start';
          break;
        }
      case RecordingStatus.Recording:
        {
          text = 'Pause';
          break;
        }
      case RecordingStatus.Paused:
        {
          text = 'Resume';
          break;
        }
      case RecordingStatus.Stopped:
        {
          text = 'Initialize';
          break;
        }
      default:
        break;
    }
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        letterSpacing: 1.3,
      ),
    );
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    Source source = DeviceFileSource(_current!.path!);
    await audioPlayer.play(source);
  }
}
