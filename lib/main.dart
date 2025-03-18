import 'package:aicam/draggable.dart';
import 'package:aicam/home.dart';
import 'package:aicam/livehome.dart';
import 'package:aicam/log.dart';
import 'package:aicam/notification.dart';
import 'package:aicam/onboarding_screens.dart';
import 'package:aicam/sequrity.dart';
import 'package:aicam/singup.dart';
import 'package:aicam/token.dart';
import 'package:aicam/wifimanager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
   await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  print('Handling a background message: ${message.messageId}');
}

Future<void> main() async {
   WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: CheckLoginPage(),
    );
  }
}

class CheckLoginPage extends StatefulWidget {
  const CheckLoginPage({super.key});

  @override
  _CheckLoginPageState createState() => _CheckLoginPageState();
}

class _CheckLoginPageState extends State<CheckLoginPage> {
  @override
  void initState() {
    super.initState();
    checkOnboardAndLogin();
  }

  Future<void> checkOnboardAndLogin() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isOnboardCompleted = prefs.getBool('isOnboardCompleted') ?? false;

    if (!isOnboardCompleted) {
      // Navigate to the onboarding screen if not completed
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OnboardingScreens()),
      );
    } else {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        // User is logged in, navigate to Home
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SecurityCameraApp()),
        );
      } else {
        // User is not logged in, navigate to Login screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Return a loading screen or splash screen until the check is done
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}