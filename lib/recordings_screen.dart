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
          return Card(
            color: kColorScheme.onPrimaryContainer.withOpacity(0.7),
            margin: const EdgeInsets.fromLTRB(4, 2, 4, 2),
            elevation: 10,
            shadowColor: Colors.yellowAccent,
            child: ListTile(
              title: Text(
                recording.substring(
                  recording.lastIndexOf('/') + 1,
                  recording.lastIndexOf('.'),
                ),
                style:
                    TextStyle(color: kColorScheme.onSecondary.withOpacity(0.7)),
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                debugPrint('File playing: $recording');
                AudioPlayer player = AudioPlayer();
                player.play(DeviceFileSource(recording));
              },
            ),
          );
        },
      );
    }
  }
}