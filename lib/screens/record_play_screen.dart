// ignore_for_file: must_be_immutable

import 'package:animated_text_kit/animated_text_kit.dart';
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
  Duration currentPosition = Duration.zero;
  Duration totalDuration = Duration.zero;

  @override
  void initState() {
    playController = PlayerController();
    player = AudioPlayer();
    playRecording(widget.filePath);

    // Add listener for when the audio completes
    player.onPlayerComplete.listen((_) {
      resetController();
    });

    // Add listener for position updates
    player.onPositionChanged.listen((position) {
      setState(() {
        currentPosition = position;
      });
    });

    // Add listener for duration updates
    player.onDurationChanged.listen((duration) {
      setState(() {
        totalDuration = duration;
      });
    });

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

  void resetController() {
    setState(() {
      _isPlaying = false;
      currentPosition = Duration.zero;
    });
    playController.release();
    Navigator.pop(context);
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
              const SizedBox(height: 30),
              SizedBox(
                // width: 250.0,
                child: DefaultTextStyle(
                  style: const TextStyle(
                    fontSize: 50.0,
                    fontFamily: 'Canterbury',
                    color: Colors.red,
                  ),
                  child: AnimatedTextKit(
                    animatedTexts: [
                      ScaleAnimatedText(
                        widget.filePath
                            .split('/')
                            .last
                            .split('.')
                            .first
                            .toUpperCase(),
                      ),
                    ],
                    repeatForever: true,
                    stopPauseOnTap: false,
                    onTap: () {},
                  ),
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  children: [
                    StreamBuilder<Duration>(
                      stream: player.onPositionChanged,
                      builder: (context, snapshot) {
                        return Slider(
                          min: 0.0,
                          max: totalDuration.inMilliseconds.toDouble(),
                          value: currentPosition.inMilliseconds.toDouble(),
                          onChanged: (value) {
                            player.seek(Duration(milliseconds: value.toInt()));
                          },
                        );
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          formatDuration(currentPosition),
                          style: const TextStyle(fontSize: 16),
                        ),
                        Text(
                          formatDuration(totalDuration),
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
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
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
