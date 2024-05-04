// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';

// class PlayerScreen extends StatelessWidget {
//   final String recordingPath;

//   const PlayerScreen({super.key, required this.recordingPath});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Player'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             // Play the recording
//             AudioPlayer audioPlayer = AudioPlayer();
//             audioPlayer.play(recordingPath as Source);
//           },
//           child: const Text('Play'),
//         ),
//       ),
//     );
//   }
// }
