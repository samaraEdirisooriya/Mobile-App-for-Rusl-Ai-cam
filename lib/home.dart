import 'package:aicam/livehome.dart';
import 'package:aicam/log.dart';
import 'package:aicam/notification.dart';
import 'package:aicam/relay_control_screen.dart';
import 'package:aicam/sequrity.dart';
import 'package:aicam/test.dart';
import 'package:aicam/wifimanager.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SecurityCameraApp extends StatefulWidget {
  const SecurityCameraApp({super.key});

  @override
  _SecurityCameraAppState createState() => _SecurityCameraAppState();
}

class _SecurityCameraAppState extends State<SecurityCameraApp> {
  double _progress = 0.5; // Initial progress value (180°)
  bool _isAnimating = false;

  void _animateTo(double targetProgress) {
    setState(() {
      _isAnimating = true;
    });

    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        _progress = targetProgress;
        _isAnimating = false;
      });
    });
  }

  void _handleTap() {
    if (_progress < 1.0) {
      _animateTo(1.0); // Move to 360° (100%) for Indoor mode
    } else {
      _animateTo(0.5); // Return to 180° (50%) for Outdoor mode
    }
  }

  void _handleDragEnd() {
    if (_progress >= 0.60) {
      _animateTo(1.0); // Snap to 360° (100%)
    } else {
      _animateTo(0.5); // Snap back to 180° (50%)
    }
  }

  void _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase Auth
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => LoginPage()), // Navigate to login screen
      );
    } catch (e) {
      print("Error logging out: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final isIndoorMode = _progress >= 1.0;
    return Scaffold(
      backgroundColor: isIndoorMode
          ? const Color(0xFF1D2339)
          : const Color(0xFFFFF9E6), // Light beige background
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () async {
                      SharedPreferences prefs =
                          await SharedPreferences.getInstance();
                      await prefs.setBool('isOnboardCompleted', false);
                      print(
                          "Onboarding Completed: ${prefs.getBool('isOnboardCompleted')}");
                    },
                    child: CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(
                          Icons.person,
                          color: Colors.grey,
                        )),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => WiFiRadarPage1()),
          );
                    },
                    child: const Text("Connected",
                        style: TextStyle(color: Colors.green)),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout_rounded),
                    onPressed: () {
                      _logout(context);
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Circular image with overlay
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      color: Colors.black,
                      image: DecorationImage(
                        image: isIndoorMode
                            ? const AssetImage('assets/indor.png')
                            : const AssetImage(
                                'assets/outdoor.png'), // Replace with your image path
                        fit: BoxFit
                            .cover, // Adjusts how the image fits the container
                      ),
                    ),
                  ),
                  Container(
                    width: 250,
                    height: 250,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(200),
                      color: const Color.fromARGB(160, 0, 0, 0),
                    ),
                    child: GestureDetector(
                      onPanUpdate: (details) {
                        if (_isAnimating) return;

                        // Calculate new progress based on drag position
                        RenderBox box = context.findRenderObject() as RenderBox;
                        Offset center = box.size.center(Offset.zero);
                        Offset position = details.localPosition - center;

                        double angle = atan2(position.dy, position.dx);
                        if (angle < 0) angle += 2 * pi;

                        setState(() {
                          _progress = angle / (2 * pi);
                        });
                      },
                      onPanEnd: (_) {
                        _handleDragEnd(); // Handle snapping on drag release
                      },
                      onTap: _handleTap, // Handle tap action
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 100),
                        curve: Curves.easeInOut,
                        width: 185,
                        height: 185,
                        alignment: Alignment.center,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Circular Progress Indicator with Gradient
                            SizedBox(
                              width: 160,
                              height: 160,
                              child: CustomPaint(
                                painter: GradientCircularProgressPainter(
                                  progress: _progress,
                                  gradientColors: isIndoorMode
                                      ? [
                                          Colors.blue.shade300,
                                          Colors.blue.shade600,
                                          Colors.blue.shade900,
                                        ]
                                      : [
                                          Colors.brown.shade100,
                                          Colors.orange.shade200,
                                          Colors.brown.shade400,
                                        ],
                                ),
                              ),
                            ),

                            // Draggable Dot (Inside the Circle)
                            SizedBox(
                              width: 250,
                              height: 250,
                              child: Transform.rotate(
                                angle: 2 * pi * _progress,
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: Container(
                                    margin: const EdgeInsets.only(
                                        top: 24.0), // Bring dot inward
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                ),
                              ),
                            ),

                            // Center Content
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.camera_outdoor,
                                  size: 40,
                                  color: Colors.white,
                                ),
                                Text(
                                  isIndoorMode ? 'Indoor' : 'Outdoor',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(221, 255, 255, 255),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Live",
                      style: TextStyle(
                          color: Colors.red,
                          fontSize: 30,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5.0))),
                    child: const Text("watch now"),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildIconButton(
                    Icons.settings,
                    "Security",
                    () => _navigateToSecurity(context),
                  ),
                  _buildIconButton(
                    Icons.warning,
                    "Alerts",
                    () => _showAlerts(context),
                  ),
                  _buildIconButton(
                    Icons.bolt,
                    "Relay Control",
                    () => _controlRelay(context),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Custom Icon Button
  Widget _buildIconButton(IconData icon, String label, VoidCallback onTap) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.grey, size: 30),
          ),
        ),
        const SizedBox(height: 5),
        Text(label, style: TextStyle(color: Colors.grey[600])),
      ],
    );
  }

  // Callback Functions for Buttons
  void _navigateToSecurity(BuildContext context) {
    // Navigate to a security settings screen
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => TogglePage()),
    );
  }

  void _showAlerts(BuildContext context) {
    // Show alerts screen or dialog
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MyApp1()),
    );
  }

  void _controlRelay(BuildContext context) {
    // Control relay or other actions
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RelayControlScreen()),
    );
  }
}

class GradientCircularProgressPainter extends CustomPainter {
  final double progress;
  final List<Color> gradientColors;

  GradientCircularProgressPainter(
      {required this.progress, required this.gradientColors});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final gradient = SweepGradient(
      colors: gradientColors,
      stops: [0.0, progress, progress],
    );

    final paint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10.0;

    final center = size.center(Offset.zero);
    final radius = size.width / 2;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      2 * pi * progress,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
