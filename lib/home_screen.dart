import 'dart:async';
import 'dart:io' as io;
import 'package:flutter/material.dart';
import 'package:file/local.dart';
import 'package:another_audio_recorder/another_audio_recorder.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:voice_recorder/main.dart';

import 'recordings_screen.dart';
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
                      backgroundColor: Colors.lightBlue,
                    ),
                    child: _buildText(_currentStatus),
                  ),
                ),
                ElevatedButton(
                  onPressed:
                      _currentStatus != RecordingStatus.Unset ? _stop : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.withOpacity(0.5),
                  ),
                  child: const Text(
                    "Stop",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: onPlayAudio,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent.withOpacity(0.5),
                  ),
                  child: const Text(
                    "Play",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecordingsScreen(),
                      )),
                  child: const Text('Recordings'),
                ),
              ],
            ),
            Card(
              color: kColorScheme.onPrimaryContainer.withOpacity(.4),
              margin: const EdgeInsets.fromLTRB(5, 0, 5, 0),
              elevation: 10,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(4, 0, 4, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ya Rasool Allah(ﷺ) Tere',
                      style: TextStyle(
                        color: kColorScheme.onSecondary,
                        fontSize: 20,
                      ),
                    ),
                    buttonPressed
                        ? ElevatedButton(
                            onPressed: () {
                              setState(
                                () {
                                  naatPlayer.stop();
                                  buttonPressed = !buttonPressed;
                                },
                              );
                            },
                            child: const Text('Stop'),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              setState(
                                () {
                                  naatPlayer.play(
                                    UrlSource(
                                        'https://humariweb.com/naats/ARQ/Ya-Rasool-Allah-(S.A.W)-Tere-(Hamariweb.com).mp3'),
                                  );
                                  buttonPressed = !buttonPressed;
                                },
                              );
                            },
                            child: const Text('Play Naat'),
                          ),
                  ],
                ),
              ),
            ),
            Text("File path of the record: ${_current?.path}"),
          ],
        ),
      ),
    );
  }

  _init() async {
    try {
      if (await AnotherAudioRecorder.hasPermissions) {
        String customPath = '/another_audio_recorder_';
        io.Directory appDocDirectory = await getApplicationDocumentsDirectory();

        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();
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
      });

      const tick = Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder?.current(channel: 0);
        // print(current.status);
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
    debugPrint("Stop recording: ${result?.path}");
    debugPrint("Stop recording: ${result?.duration}");
    io.Directory appDocDirectory = await getApplicationDocumentsDirectory();
    String destinationPath =
        '${appDocDirectory.path}/Recording_${DateTime.now().millisecondsSinceEpoch.toString()}.wav';
    await io.File(result!.path!).copy(destinationPath);

    debugPrint("File saved to: $destinationPath");

    setState(() {
      _current = result;
      _currentStatus = _current!.status!;
    });
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
          text = 'Init';
          break;
        }
      default:
        break;
    }
    return Text(text, style: const TextStyle(color: Colors.white));
  }

  void onPlayAudio() async {
    AudioPlayer audioPlayer = AudioPlayer();
    Source source = DeviceFileSource(_current!.path!);
    await audioPlayer.play(source);
  }
}
