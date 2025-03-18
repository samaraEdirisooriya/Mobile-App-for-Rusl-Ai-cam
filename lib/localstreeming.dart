import 'package:flutter/material.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';

class LocalLiveStreamPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Mjpeg(
          stream: 'http://192.168.190.147/mjpeg/1',
          isLive: true,
          error: (context, error, stack) {
            return Text('Error loading stream: $error');
          },
        ),
      ),
    );
  }
}
