import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:wifi_scan/wifi_scan.dart';
import 'package:wifi_iot/wifi_iot.dart'; // For Wi-Fi connection
import 'package:url_launcher/url_launcher.dart'; // To open IP-based site

class WiFiRadarPage extends StatefulWidget {
  const WiFiRadarPage({super.key});

  @override
  _WiFiRadarPageState createState() => _WiFiRadarPageState();
}

class _WiFiRadarPageState extends State<WiFiRadarPage> {
  List<WiFiAccessPoint> _accessPoints = [];
  String predefinedPassword = "12345678"; // Replace with your password
  bool _isConnecting = false;
  String _connectionStatus = "";

  @override
  void initState() {
    super.initState();
    _requestPermissions();
    Timer.periodic(const Duration(seconds: 5), (timer) {
      _scanWiFi();
    });
  }

  Future<void> _requestPermissions() async {
    // Request permissions required for Wi-Fi scan
    await WiFiScan.instance.canStartScan(askPermissions: true);
    await WiFiScan.instance.canGetScannedResults(askPermissions: true);
  }

  Future<void> _scanWiFi() async {
    final canScan = await WiFiScan.instance.canStartScan(askPermissions: false);
    if (canScan == CanStartScan.yes) {
      await WiFiScan.instance.startScan();
    }
    final canGetResults =
        await WiFiScan.instance.canGetScannedResults(askPermissions: false);
    if (canGetResults == CanGetScannedResults.yes) {
      final results = await WiFiScan.instance.getScannedResults();
      setState(() {
        _accessPoints = results;
      });
    }
  }

  Future<void> _connectToWiFi(String ssid) async {
    setState(() {
      _isConnecting = true;
      _connectionStatus = "";
    });

    try {
      bool connected = await WiFiForIoTPlugin.connect(
        ssid,
        password: predefinedPassword,
        security: NetworkSecurity.WPA,
        joinOnce: true,
      );

      setState(() {
        _isConnecting = false;
        _connectionStatus = connected ? "Connected to $ssid" : "Failed to connect to $ssid";
      });

      if (connected) {
        _redirectToIPPage();
      }
    } catch (e) {
      setState(() {
        _isConnecting = false;
        _connectionStatus = "Error: $e";
      });
    }
  }

  void _redirectToIPPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RedirectPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 60),
          const Text('Connect RUSL Ai Camera',
              style: TextStyle(
                  color: Colors.red,
                  fontSize: 20,
                  fontWeight: FontWeight.bold)),
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
                      width: 2, color: const Color.fromARGB(255, 0, 195, 255)),
                ),
                child: Image.asset('assets/app.png'),
              ),
              ..._accessPoints.map((accessPoint) {
                final position = _constrainedPositionInsideCircle(150);
                return Positioned(
                  left: position.dx + 150 - 25,
                  top: position.dy + 150 - 25,
                  child: GestureDetector(
                    onTap: () => _connectToWiFi(accessPoint.ssid),
                    child: Column(
                      children: [
                        Container(
                          width: 50,
                          height: 50,
                          decoration: const BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          accessPoint.ssid,
                          style: const TextStyle(
                              color: Colors.black, fontSize: 12),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }),
              if (_isConnecting)
                const Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ),
              if (_connectionStatus.isNotEmpty)
                Positioned(
                  bottom: 20,
                  child: Text(
                    _connectionStatus,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
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

class RedirectPage extends StatelessWidget {
  final String ipAddress = "http://192.168.8.41";

  const RedirectPage({super.key});

  Future<void> _openIPSite() async {
    if (await canLaunchUrl(Uri.parse(ipAddress))) {
      await launchUrl(Uri.parse(ipAddress), mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $ipAddress';
    }
  }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) => _openIPSite());
    return Scaffold(
      appBar: AppBar(title: const Text('Connecting...')),
      body: Center(child: Text('Opening $ipAddress')),
    );
  }
}
