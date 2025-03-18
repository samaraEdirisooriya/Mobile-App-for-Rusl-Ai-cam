import 'package:aicam/globallive.dart';
import 'package:aicam/localstreeming.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Live Video Stream'),
      ),
      body: Container(
        color: Colors.white, // Light background color
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Local Live Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blueAccent, // Correct color property
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  minimumSize: Size(200, 80), // Large button size
                ),
                onPressed: () {
                   Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocalLiveStreamPage()),
    );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.tv, size: 30), // Correct icon
                    SizedBox(width: 10),
                    Text(
                      'Local Live',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            
            // Global Live Button
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.greenAccent, // Correct color property
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  minimumSize: Size(200, 80), // Large button size
                ),
                onPressed: () {
                  Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LiveStreamPlayer()),
          );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.public, size: 30), // Correct icon
                    SizedBox(width: 10),
                    Text(
                      'Global Live',
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
