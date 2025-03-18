import 'package:flutter/material.dart';

class RelayControlScreen extends StatefulWidget {
  @override
  _RelayControlScreenState createState() => _RelayControlScreenState();
}

class _RelayControlScreenState extends State<RelayControlScreen> {
  bool isAlertControlEnabled = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Relay Control ⚡'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.pink[100],
                borderRadius: BorderRadius.circular(12.0),
              ),
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Alert-Activated Relay Control',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          'This feature activates the physical relay controller '
                          'when an alert is triggered, ensuring an automated response to the detected event.',
                          style: TextStyle(
                            fontSize: 14.0,
                            color: Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: isAlertControlEnabled,
                    onChanged: (value) {
                      setState(() {
                        isAlertControlEnabled = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.0),
            Text(
              'Select the alerts that will activate the relay controller. '
              'Enable the checkbox next to each alert to include it in the automated response system.',
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.black87,
              ),
            ),
            SizedBox(height: 16.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 16.0),
                buildAlertButton('Restricted Area Alert'),
                SizedBox(height: 12.0),
                buildAlertButton('Baby Presence Alert'),
                SizedBox(height: 12.0),
                buildAlertButton('Wild Animal Detection'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildAlertButton(String text) {
    return ElevatedButton(
      onPressed: () {
        // Handle button tap
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        padding: EdgeInsets.only(top: 10,bottom: 10,left: 15, right:15 ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.0),
        ),
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16.0),
      ),
    );
  }
}
