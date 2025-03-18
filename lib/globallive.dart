import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class LiveStreamPlayer extends StatefulWidget {
  @override
  _LiveStreamPlayerState createState() => _LiveStreamPlayerState();
}

class _LiveStreamPlayerState extends State<LiveStreamPlayer> {
  late VideoPlayerController _controller;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    try {
      _controller = VideoPlayerController.network(
        'https://stream.mux.com/pYfN01YrbML00pAd1VftcHdy53vjTw4OQG6s7oztvfpzQ.m3u8',
      );

      await _controller.initialize();
      setState(() {
        _isInitialized = true;
      });

      _controller.play();
    } catch (e) {
      // Log the error if initialization fails
      print("Video initialization error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Global Live Stream')),
      body: Center(
        child: _isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : CircularProgressIndicator(),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
