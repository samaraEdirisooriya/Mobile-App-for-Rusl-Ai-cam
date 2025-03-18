import 'dart:async';
import 'dart:math';
import 'package:aicam/home.dart';
import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_iot/wifi_iot.dart'; // Added for Wi-Fi connection management
import 'package:url_launcher/url_launcher.dart'; // For launching URLs
import 'package:http/http.dart' as http; // For HTTP requests


class WiFiRadarPage1 extends StatefulWidget {
  const WiFiRadarPage1({super.key});

  @override
  _WiFiRadarPageState createState() => _WiFiRadarPageState();
}

class _WiFiRadarPageState extends State<WiFiRadarPage1> {
  List<WiFiAccessPoint> _accessPoints = [];
  String predefinedPassword = "12345678"; // Replace with your password
  String _currentSSID = ""; // To store the current connected SSID

  @override
  void initState() {
    super.initState();
    _checkCurrentConnection();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _scanWiFi();
    });
  }

  Future<void> _checkCurrentConnection() async {
    String? connectedSSID = await WiFiForIoTPlugin.getSSID();
    setState(() {
      _currentSSID = connectedSSID ?? "";
    });
  }

  Future<void> _scanWiFi() async {
    final canScan = await WiFiScan.instance.canStartScan(askPermissions: true);
    if (canScan == CanStartScan.yes) {
      await WiFiScan.instance.startScan();
    }
    final canGetResults =
        await WiFiScan.instance.canGetScannedResults(askPermissions: true);
    if (canGetResults == CanGetScannedResults.yes) {
      final results = await WiFiScan.instance.getScannedResults();
      setState(() {
        _accessPoints =
            results.where((ap) => ap.ssid.startsWith('RUSL AI Cam')).toList();
        _checkCurrentConnection();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Text('Connect RUSL Ai camera',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
          const Padding(
            padding: EdgeInsets.only(top: 50.0),
            child: Text('SSID : RUSL AI Cam',
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text('Password : 12345678',
                style: TextStyle(
                    color: Color.fromARGB(255, 0, 0, 0),
                    fontSize: 12,
                    fontWeight: FontWeight.bold)),
          ),
          Column(
            children: [
              const SizedBox(height: 100),
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 400,
                    height: 400,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          width: 2,
                          color: const Color.fromARGB(255, 0, 195, 255)),
                    ),
                    child: Image.asset('assets/app.png'),
                  ),
                  ..._accessPoints.map((accessPoint) {
                    final position = _constrainedPositionInsideCircle(150);
                    bool isConnected = accessPoint.ssid == _currentSSID;
                    return Positioned(
                      left: position.dx + 150 - 25,
                      top: position.dy + 150 - 25,
                      child: GestureDetector(
                        onTap: () async {
                          if (!isConnected) {
                            await WiFiForIoTPlugin.connect(accessPoint.ssid,
                                password: predefinedPassword);
                            _checkCurrentConnection();
                          }
                        },
                        child: Column(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isConnected ? Colors.green : Colors.red,
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isConnected ? 'Connected' : accessPoint.ssid,
                              style:
                                  const TextStyle(color: Colors.black, fontSize: 12),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                ],
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: ElevatedButton(
                  
                  onPressed: () {
                    Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SecurityCameraApp()),
          );
                  },
                  child: const Text('Continue',style: TextStyle(
                    color: Colors.blue
                  ),),
                ),
              ),
            ],
          ),
          
        ],
      ),
    );
  }

  Offset _constrainedPositionInsideCircle(double radius) {
    final rand = Random();
    final angle = rand.nextDouble() * 2 * pi;
    final distance = sqrt(rand.nextDouble()) * radius * 0.9;
    return Offset(distance * cos(angle), distance * sin(angle));
  }
}
