// ignore_for_file: unused_field

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayNaatScreen extends StatefulWidget {
  const PlayNaatScreen({super.key, required this.name, required this.url});
  final String name;
  final String url;
  @override
  State<PlayNaatScreen> createState() => _PlayNaatScreenState();
}

class _PlayNaatScreenState extends State<PlayNaatScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _checkPermissions();
    _audioPlayer = AudioPlayer();
    _audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });
    _playNaat();
  }

  @override
  void dispose() {
    _audioPlayer.release();
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _checkPermissions() async {
    var networkPermissionStatus = await Permission.location.status;
    if (!networkPermissionStatus.isGranted) {
      var result = await Permission.location.request();
      if (result.isDenied) {
        debugPrint('Network Permission denied');
      }

      var audioPermissionStatus = await Permission.microphone.status;
      if (!audioPermissionStatus.isGranted) {
        var result = await Permission.microphone.request();
        if (result.isDenied) {
          debugPrint('Audio Permission denied');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Naat Sharif: ${widget.name}',
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isPlaying
                    ? IconButton(
                        icon: const Icon(Icons.pause),
                        onPressed: () {
                          _pauseNaat();
                        },
                      )
                    : IconButton(
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () {
                          _playNaat();
                        },
                      ),
                IconButton(
                  icon: const Icon(Icons.stop),
                  onPressed: () {
                    _stopNaat();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _playNaat() async {
    await _audioPlayer.play(UrlSource(widget.url));
  }

  Future<void> _pauseNaat() async {
    await _audioPlayer.pause();
  }

  Future<void> _stopNaat() async {
    await _audioPlayer.stop();
  }
}
