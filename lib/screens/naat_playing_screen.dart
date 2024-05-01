import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PLayNaatScreen extends StatefulWidget {
  const PLayNaatScreen({super.key, required this.filePath});
  final String filePath;
  @override
  State<PLayNaatScreen> createState() => _PLayNaatScreenState();
}

class _PLayNaatScreenState extends State<PLayNaatScreen> {
  @override
  void initState() {
    super.initState();
    _checkPermissions();
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
    return const Scaffold();
  }
}
