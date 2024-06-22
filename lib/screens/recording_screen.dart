// ignore_for_file: must_be_immutable, library_private_types_in_public_api

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:voice_recorder/widgets/buttom_nv_bar.dart';
import 'dart:async';
import 'dart:io';

import 'package:voice_recorder/widgets/my_scaffold_msg.dart';

class VoiceRecorderApp extends StatefulWidget {
  const VoiceRecorderApp({super.key});

  @override
  _VoiceRecorderAppState createState() => _VoiceRecorderAppState();
}

enum Menu { preview, share, getLink, remove, download }

class _VoiceRecorderAppState extends State<VoiceRecorderApp> {
  late RecorderController recorderController;
  List<String> recordings = [];
  bool isRecording = false;
  String directoryPath = '';
  Timer? _timer;
  String? currentFilePath;
  AnimationStyle? _animationStyle;

  @override
  void initState() {
    super.initState();
    recorderController = RecorderController();
    requestPermissions();
    getDirectoryPath();
    _animationStyle = AnimationStyle(
      curve: Easing.emphasizedDecelerate,
      duration: const Duration(seconds: 3),
    );
  }

  Future<void> requestPermissions() async {
    await Permission.microphone.request();
    await Permission.storage.request();
  }

  Future<void> getDirectoryPath() async {
    Directory directory = await getApplicationDocumentsDirectory();
    setState(() {
      directoryPath = directory.path;
    });
    loadRecordings();
  }

  Future<void> loadRecordings() async {
    Directory directory = Directory(directoryPath);
    List<String> files = directory
        .listSync()
        .map((item) => item.path)
        .where((item) => item.endsWith(".aac"))
        .toList();
    setState(() {
      recordings = files;
    });
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {});
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> startRecording() async {
    if (!isRecording) {
      currentFilePath =
          '$directoryPath/Recording_${DateTime.now().millisecondsSinceEpoch}.aac';
      await recorderController.record(
          path: currentFilePath!, sampleRate: 16000);
      setState(() {
        isRecording = true;
      });
      startTimer();
    }
  }

  Future<void> stopRecording() async {
    if (isRecording) {
      await recorderController.stop();
      setState(() {
        isRecording = false;
      });
      stopTimer();
    }
  }

  Future<void> saveRecording() async {
    if (currentFilePath != null) {
      TextEditingController textController = TextEditingController();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Save Recording'),
          content: TextField(
            controller: textController,
            decoration: const InputDecoration(hintText: 'Enter recording name'),
          ),
          actions: [
            TextButton(
              onPressed: () async {
                String newName = textController.text;
                if (newName.isNotEmpty) {
                  String newFilePath = '$directoryPath/$newName.aac';
                  File file = File(currentFilePath!);
                  await file.rename(newFilePath);
                  setState(() {
                    currentFilePath = null;
                  });
                  loadRecordings();
                }
                Navigator.of(context).pop();
              },
              child: const Text('Save'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> discardRecording() async {
    if (currentFilePath != null) {
      File file = File(currentFilePath!);
      if (await file.exists()) {
        await file.delete();
      }
      setState(() {
        currentFilePath = null;
      });
    }
  }

  String formatDuration(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  Future<void> deleteRecordings(String filePath) async {
    debugPrint('Deleting file from path: $filePath');
    try {
      File file = File(filePath);
      if (await file.exists()) {
        await file.delete();
        await loadRecordings();
      }
    } on Exception catch (error) {
      debugPrint('Exception found: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Voice Recorder')),
      bottomNavigationBar: const MyBottomNavBar(),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Column(
                  children: [
                    isRecording
                        ? AudioWaveforms(
                            enableGesture: true,
                            size: const Size(double.infinity, 100.0),
                            recorderController: recorderController,
                            waveStyle: const WaveStyle(
                              waveColor: Colors.blue,
                              showDurationLabel: true,
                              spacing: 8.0,
                              extendWaveform: true,
                              showMiddleLine: true,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              color: const Color(0xFF1E1B26),
                            ),
                            padding: const EdgeInsets.only(left: 10),
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                          )
                        : const Text(
                            '',
                            style: TextStyle(fontSize: 24),
                          ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: isRecording ? stopRecording : startRecording,
              style: ElevatedButton.styleFrom(
                elevation: 10,
                overlayColor: Colors.pink,
                shadowColor: Colors.red[100],
                shape: const CircleBorder(),
                minimumSize: const Size(70, 70),
                backgroundColor: Colors.red,
                iconColor: Colors.white,
                tapTargetSize: MaterialTapTargetSize.padded,
              ),
              child: isRecording
                  ? const Icon(
                      Icons.stop,
                      size: 50,
                    )
                  : const Icon(
                      Icons.play_arrow,
                      size: 50,
                    ),
            ),
            const SizedBox(height: 30),
            if (currentFilePath != null && !isRecording) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  IconButton(
                    onPressed: discardRecording,
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.red[900],
                      size: 50,
                    ),
                  ),
                  IconButton(
                    onPressed: saveRecording,
                    icon: Icon(
                      Icons.check,
                      color: Colors.green[800],
                      size: 50,
                    ),
                  ),
                ],
              ),
            ],
            Expanded(
              flex: 1,
              child: ListView.builder(
                itemCount: recordings.length,
                itemBuilder: (context, index) {
                  String filePath = recordings[index];
                  GlobalKey iconKey = GlobalKey(); // Add this line

                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: ListTile(
                      title: Text(filePath.split('/').last.split('.').first),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                PlayScreen(filePath: filePath),
                          ),
                        );
                      },
                      tileColor: Colors.white54,
                      textColor: const Color.fromARGB(255, 1, 41, 74),
                      leading: const Icon(Icons.music_note),
                      trailing: IconButton(
                        key: iconKey, // Add this line
                        icon: const Icon(Icons.more_vert_outlined),
                        onPressed: () async {
                          final RenderBox button = iconKey.currentContext!
                              .findRenderObject() as RenderBox;
                          final RenderBox overlay = Overlay.of(context)
                              .context
                              .findRenderObject() as RenderBox;
                          final RelativeRect position = RelativeRect.fromRect(
                            Rect.fromPoints(
                              button.localToGlobal(Offset.zero,
                                  ancestor: overlay),
                              button.localToGlobal(
                                  button.size.bottomRight(Offset.zero),
                                  ancestor: overlay),
                            ),
                            Offset.zero & overlay.size,
                          );

                          await showMenu(
                            context: context,
                            position: position,
                            popUpAnimationStyle: _animationStyle,
                            items: [
                              const PopupMenuItem<String>(
                                value: 'share',
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(
                                      Icons.share,
                                      color: Color.fromARGB(255, 1, 59, 106),
                                    ),
                                    Text(
                                      'Share',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 1, 59, 106)),
                                    ),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'download',
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.download,
                                        color: Color.fromARGB(255, 1, 59, 106)),
                                    Text(
                                      'Download',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 1, 59, 106)),
                                    ),
                                  ],
                                ),
                              ),
                              const PopupMenuItem<String>(
                                value: 'delete',
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Icon(Icons.delete,
                                        color: Color.fromARGB(255, 1, 59, 106)),
                                    Text(
                                      'Delete',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 1, 59, 106)),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ).then((value) {
                            if (value != null) {
                              switch (value) {
                                case 'share':
                                  showSuccessMessage(
                                      context, 'Pressed on Share');
                                  break;
                                case 'download':
                                  showSuccessMessage(
                                      context, 'Pressed on Donwload');
                                  break;
                                case 'delete':
                                  deleteRecordings(filePath);
                                  showUnSuccessMessage(context,
                                      'Recording deleted Successfully!');
                                  break;
                              }
                            }
                          });
                        },
                      ),
                      shape: RoundedRectangleBorder(
                        side: const BorderSide(color: Colors.black, width: 1),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PlayScreen extends StatefulWidget {
  String filePath;
  PlayScreen({super.key, required this.filePath});

  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late PlayerController playController;
  bool _isPlaying = true;
  late AudioPlayer player;

  @override
  void initState() {
    playController = PlayerController();
    player = AudioPlayer();
    playRecording(widget.filePath);
    super.initState();
  }

  @override
  void dispose() {
    playController.dispose();
    player.dispose();
    super.dispose();
  }

  void playRecording(String path) {
    player.play(DeviceFileSource(path));
  }

  void pauseRecording() {
    player.pause();
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  void resumeRecording() {
    player.resume();
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.filePath.split('/').last),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.filePath.split('/').last),
              const SizedBox(height: 100),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _isPlaying ? pauseRecording() : resumeRecording();
                    },
                    style: ElevatedButton.styleFrom(
                      shape: const CircleBorder(),
                      minimumSize: const Size(70, 70),
                      backgroundColor: Colors.red,
                    ),
                    child: _isPlaying
                        ? const Icon(
                            Icons.pause,
                            size: 50,
                            color: Colors.white,
                          )
                        : const Icon(
                            Icons.play_arrow,
                            size: 50,
                            color: Colors.white,
                          ),
                  ),
                  const SizedBox(height: 10),
                  _isPlaying
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _isPlaying = !_isPlaying;
                              Navigator.pop(context);
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            shape: const CircleBorder(),
                            minimumSize: const Size(70, 70),
                            backgroundColor: Colors.red,
                          ),
                          child: const Icon(
                            Icons.stop,
                            size: 50,
                            color: Colors.white,
                          ),
                        )
                      : const Text(''),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
