import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp1 extends StatefulWidget {
  const MyApp1({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp1> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  List<Map<String, String>> notifications = []; // List to store notifications

  @override
  void initState() {
    super.initState();
    onboardingComplete() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('onboardingComplete', true);
    }

    _initializeFirebaseMessaging();
    _setupLocalNotifications();
  }

  void _initializeFirebaseMessaging() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (message.notification != null) {
        _showNotification(
            message.notification!.title, message.notification!.body);
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (message.data.isNotEmpty) {
        Navigator.pushNamed(context, '/message');
      }
    });
  }

  void _setupLocalNotifications() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> _showNotification(String? title, String? body) async {
    setState(() {
      notifications.insert(0, {
        'title': title ?? 'New Message',
        'body': body ?? 'You have received a new message.',
      });
    });

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.max,
      priority: Priority.high,
      color: Colors.blueAccent, // Customize the notification color
    );

    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      title ?? 'New Message',
      body ?? 'You have received a new message.',
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
        dialogBackgroundColor:
            Colors.lightBlue.shade50, // Light background color
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              const Text(
                'AI Alerts',
                style: TextStyle(color: Colors.red),
              ),
             
            ],
          ),
          backgroundColor:
              const Color.fromARGB(255, 51, 51, 51), // Fancy header color
        ),
        body: notifications.isEmpty
            ? const Center(
                child: Text('No notifications yet...',
                    style: TextStyle(fontSize: 18, color: Colors.black54)))
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    return Card(
                      elevation: 5,
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Colors.white,
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(16),
                        title: Text(
                          notifications[index]['title']!,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        subtitle: Text(
                          notifications[index]['body']!,
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.black54,
                          ),
                        ),
                        leading: const Icon(
                          Icons.notifications,
                          color: Colors.blueAccent,
                          size: 30,
                        ),
                        trailing: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.blueAccent,
                        ),
                        onTap: () {
                          // Add action for notification tap if needed
                        },
                      ),
                    );
                  },
                ),
              ),
      ),
    );
  }
}
 
