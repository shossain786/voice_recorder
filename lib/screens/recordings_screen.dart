import 'dart:io';

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:path_provider/path_provider.dart';
import 'package:voice_recorder/main.dart';

class RecordingsScreen extends StatefulWidget {
  const RecordingsScreen({super.key});

  @override
  State<RecordingsScreen> createState() => _RecordingsScreenState();
}

class _RecordingsScreenState extends State<RecordingsScreen> {
  late List<String> recordings = [];

  @override
  void initState() {
    super.initState();
    _fetchRecordings();
  }

  Future<void> _fetchRecordings() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> files = await documentsDirectory.list().toList();
    files.retainWhere(
      (file) =>
          file.path.endsWith('.wav') ||
          file.path.endsWith('.mp3') ||
          file.path.endsWith('.aac') ||
          file.path.endsWith('.m4a'),
    );
    setState(() {
      recordings = files.map((file) => file.path).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recordings'),
      ),
      body: _buildRecordingsList(),
    );
  }

  Widget _buildRecordingsList() {
    if (recordings.isEmpty) {
      return const Center(child: Text('No recordings found.'));
    } else {
      return ListView.builder(
        itemCount: recordings.length,
        itemBuilder: (context, index) {
          final recording = recordings[index];
          return Dismissible(
            key: Key(recording),
            background: Container(
              color: Colors.red,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.only(left: 20.0),
              child: const Icon(Icons.delete, color: Colors.white),
            ),
            direction: DismissDirection.startToEnd,
            onDismissed: (direction) {
              setState(() {
                recordings.removeAt(index);
                File(recording).deleteSync();
              });
            },
            child: Container(
              margin: const EdgeInsets.all(2),
              padding: const EdgeInsets.symmetric(horizontal: 1, vertical: 2),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.red,
                    Colors.yellow,
                  ],
                ),
              ),
              child: Card(
                margin: const EdgeInsets.fromLTRB(2, 2, 2, 2),
                child: ListTile(
                  title: Text(
                    recording.substring(
                      recording.lastIndexOf('/') + 1,
                      recording.lastIndexOf('.'),
                    ),
                    style: TextStyle(
                      color: kColorScheme.onSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    debugPrint('File playing: $recording');
                    AudioPlayer player = AudioPlayer();
                    player.play(DeviceFileSource(recording));
                  },
                ),
              ),
            ),
          );
        },
      );
    }
  }
}
