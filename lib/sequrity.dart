import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TogglePage extends StatefulWidget {
  const TogglePage({super.key});

  @override
  _TogglePageState createState() => _TogglePageState();
}

class _TogglePageState extends State<TogglePage> {
  bool _isToggled1 = false;
  bool _isToggled2 = false;
  bool _isToggled3 = false;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Update Firestore based on which toggle is active
  Future<void> _updateFirestore() async {
    String optionText = '';

    if (_isToggled1) {
      optionText = 'con1';
    } else if (_isToggled2) {
      optionText = 'con2';
    } else if (_isToggled3) {
      optionText = 'con3';
    } else {
      optionText = 'con4';
    }

    await _firestore.collection('cam').doc('optionsdata').set({
      'option': optionText,
    }, SetOptions(merge: true)); // Merge to update specific fields without overwriting others
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Al Security Alerts'),
        backgroundColor: const Color.fromARGB(221, 255, 255, 255),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              _buildToggleCard(
                'Restricted Area Alert',
                'This service monitors the restricted area to ensure that no one is present. If someone enters the area,an alert willl be triggered to notity you.',
                Colors.blue[100]!,
                _isToggled1,
                1,
                'assets/1s.png'
              ),
              const SizedBox(height: 20),
              _buildToggleCard(
                'Baby Presence Alert',
                "This feature monitors the baby's presence in the frame. If the baby is no longer detected, an alert will be triggered to notify you. ",
                Colors.green[100]!,
                _isToggled2,
                2,
                'assets/2s.png'
              ),
              const SizedBox(height: 20),
              _buildToggleCard(
                'Wild Animal Detection',
                'This feature detects the presence of wild animals within the monitored area. An alert will be sent if any wild animal is detected.',
                Colors.orange[100]!,
                _isToggled3,
                3,
                'assets/3f.jpg'
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the toggle card with title, description, and toggle button
  Widget _buildToggleCard(String title, String description, Color backgroundColor, bool isToggled, int toggleIndex, String img) {
    return Card(
      color: backgroundColor,
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: MediaQuery.of(context).size.width-150,
                  child: Text(
                    description,
                    style: const TextStyle(fontSize: 12, color: Colors.black),
                  ),
                ),
                const SizedBox(height: 10,),
                Container(
                    width: MediaQuery.of(context).size.width-150,
                    height: 250,
                   decoration: BoxDecoration(
                      image: DecorationImage(
      image:AssetImage(img), // Replace with your image path
      fit: BoxFit.cover, // Adjusts how the image fits the container
    ),
                    ),),
              ],
            ),
            const Spacer(),
            Switch(
              value: isToggled,
              onChanged: (bool value) {
                setState(() {
                  // Ensure only one toggle is active at a time
                  if (toggleIndex == 1) {
                    _isToggled1 = value;
                    _isToggled2 = false;
                    _isToggled3 = false;
                  } else if (toggleIndex == 2) {
                    _isToggled2 = value;
                    _isToggled1 = false;
                    _isToggled3 = false;
                  } else if (toggleIndex == 3) {
                    _isToggled3 = value;
                    _isToggled1 = false;
                    _isToggled2 = false;
                  }
                });

                // Update Firestore based on the toggle state
                _updateFirestore();
              },
            ),
          ],
        ),
      ),
    );
  }
}
