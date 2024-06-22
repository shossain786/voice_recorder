// ignore_for_file: must_be_immutable

import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

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
        title: Text(widget.filePath.split('/').last.split('.').first),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                widget.filePath.split('/').last.split('.').first,
                style: const TextStyle(
                  fontSize: 30,
                ),
                overflow: TextOverflow.ellipsis,
              ),
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
