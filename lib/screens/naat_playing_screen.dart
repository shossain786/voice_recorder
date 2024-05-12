import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
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
  Duration _duration = Duration.zero;
  Duration _position = Duration.zero;

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
    _audioPlayer.onPositionChanged.listen((Duration position) {
      setState(() {
        _position = position;
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
      appBar: AppBar(
        title: Text(widget.name),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/play2.gif'),
            fit: BoxFit.cover,
            opacity: 0.4,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/play.gif',
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.black.withOpacity(0.4),
                ),
                child: Row(
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
              ),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: _duration.inMilliseconds > 0
                    ? (_position.inMilliseconds / _duration.inMilliseconds)
                        .clamp(0.0, 1.0)
                    : 0.0,
                minHeight: 10,
                backgroundColor: Colors.grey,
                valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
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
