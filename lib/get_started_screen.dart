// get_started_screen.dart

import 'package:flutter/material.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
      ),
      body: const Center(
        child: Text(
          'You are ready to explore!',
          style: TextStyle(fontSize: 24.0),
        ),
      ),
    );
  }
}
