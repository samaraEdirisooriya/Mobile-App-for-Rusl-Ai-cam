import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';




class DeviceTokenScreen extends StatefulWidget {
  const DeviceTokenScreen({super.key});

  @override
  _DeviceTokenScreenState createState() => _DeviceTokenScreenState();
}

class _DeviceTokenScreenState extends State<DeviceTokenScreen> {
  String _deviceToken = 'Fetching device token...';

  @override
  void initState() {
    super.initState();
    _getDeviceToken();
  }

  void _getDeviceToken() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken();
    setState(() {
      _deviceToken = token ?? 'Failed to retrieve token';
    });
    print("Device Token: $_deviceToken"); // Token displayed in console
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Device Token'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SelectableText(
            _deviceToken,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16),
          ),
        ),
      ),
    );
  }
}
