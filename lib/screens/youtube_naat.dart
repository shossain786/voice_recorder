import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class YouTubeNaat extends StatefulWidget {
  const YouTubeNaat({super.key});

  @override
  State<YouTubeNaat> createState() => _YouTubeNaatState();
}

class _YouTubeNaatState extends State<YouTubeNaat> {
  late AudioPlayer _audioPlayer;
  String audioUrl = 'https://www.youtube.com/watch?v=wwTetayC7Qo';

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _audioPlayer.setSourceUrl(audioUrl);
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Youtube Naats'),
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.play_arrow),
            onPressed: () {
              _audioPlayer.play(UrlSource(audioUrl));
            },
          ),
          IconButton(
            icon: const Icon(Icons.pause),
            onPressed: () {
              _audioPlayer.pause();
            },
          ),
          IconButton(
            icon: const Icon(Icons.stop),
            onPressed: () {
              _audioPlayer.stop();
            },
          ),
        ],
      ),
    );
  }
}
