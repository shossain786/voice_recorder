// ignore_for_file: unnecessary_null_comparison

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

class PlayNaatScreen extends StatefulWidget {
  const PlayNaatScreen(
      {super.key, required this.name, required this.url, required this.voice});
  final String name;
  final String url;
  final String voice;

  @override
  State<PlayNaatScreen> createState() => _PlayNaatScreenState();
}

class _PlayNaatScreenState extends State<PlayNaatScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;
  late Timer _timer;
  String get _positionText => _position.toString().split('.').first;
  String get _durationText => _duration.toString().split('.').first;

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
    _audioPlayer.onDurationChanged.listen((Duration duration) {
      setState(() {
        _duration = duration;
      });
    });
    _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
      if (_isPlaying) {
        _audioPlayer.getCurrentPosition().then((duration) {
          setState(() {
            _position = duration ?? Duration.zero;
          });
        });
      }
    });
    _playNaat();
  }

  @override
  void dispose() {
    _audioPlayer.release();
    _audioPlayer.dispose();
    _timer.cancel();
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
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
            colors: [Colors.white24, Colors.white54],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Title: ${widget.name}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 32, 15, 81),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                'Voice: ${widget.voice}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 228, 15, 89),
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/play.gif',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
              const SizedBox(height: 20),
              Slider(
                thumbColor: Colors.red,
                inactiveColor: Colors.blue,
                activeColor: Colors.purple,
                onChanged: (value) {
                  final duration = _duration;
                  final position = value * duration.inMilliseconds;
                  _audioPlayer.seek(Duration(milliseconds: position.round()));
                },
                value: (_position.inMilliseconds > 0 &&
                        _position.inMilliseconds < _duration.inMilliseconds)
                    ? _position.inMilliseconds / _duration.inMilliseconds
                    : 0.0,
              ),
              Text(
                _position != null
                    ? '$_positionText / $_durationText'
                    : _duration != null
                        ? _durationText
                        : '',
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.purple,
                ),
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: const LinearGradient(colors: [
                      Colors.purple,
                      Colors.red,
                      Colors.pink,
                      Colors.yellowAccent,
                    ])),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _isPlaying
                        ? IconButton(
                            icon: const Icon(Icons.pause),
                            onPressed: () {
                              _pauseNaat();
                            },
                            color: Colors.white,
                          )
                        : IconButton(
                            icon: const Icon(Icons.play_arrow),
                            onPressed: () {
                              _playNaat();
                            },
                            color: Colors.white,
                          ),
                    IconButton(
                      icon: const Icon(Icons.stop),
                      onPressed: () {
                        _stopNaat();
                      },
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _playNaat() async {
    await _audioPlayer.play(UrlSource(widget.url));
  }

  Future<void> _pauseNaat() async {
    if (_audioPlayer.state == PlayerState.playing) {
      await _audioPlayer.pause();
    }
  }

  Future<void> _stopNaat() async {
    await _audioPlayer.stop();
  }
}
