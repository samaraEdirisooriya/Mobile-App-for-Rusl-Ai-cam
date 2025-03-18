import 'package:aicam/singup.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'get_started_screen.dart';

class OnboardingScreens extends StatefulWidget {
  const OnboardingScreens({super.key});

  @override
  _OnboardingScreensState createState() => _OnboardingScreensState();
}

class _OnboardingScreensState extends State<OnboardingScreens> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            children: [
              buildPage(
                context,
                'assets/image02.png',
                'Rusl vision',
                'RUSL AI Camera'
              ),
              buildPage(
                context,
                'assets/image01.png',
                'Welcome Experience',
                "Advanced security and monitoring with our state-of-the-art camera system.",
              ),
              buildPage(
                context,
                'assets/image03.png',
                'Live Streaming Enjoy seamless',
                'Live streaming of your monitored areas, both locally and globally. Stay connected and watch over your property from anywhere.',
              ),
              buildPage(
                context,
                'assets/image03.png',
                'Physical Relay Control',
                'Automate responses with our physical relay controller. Trigger actions such as alarms or lights when alerts are detected for enhanced security.',
              ),
              buildPage(
                context,
                'assets/image03.png',
                'Al Security Alerts',
                'Our intelligent camera uses Al to detect unusual activities and send you instant security alerts, keeping you informed and safe.',
              ),
              buildPage(
                context,
                'assets/image03.png',
                'Ready to Start Your camera',
                'System is ready to protect your home with Al alerts, live streaming, and automated relay controls.Lets secure your world!',
              ),
            ],
          ),
          Positioned(
            bottom: 5,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    6,
                    (index) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4.0),
                      height: 8.0,
                      width: _currentPage == index ? 16.0 : 8.0,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? Colors.white : Colors.grey,
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: _currentPage == 5
                      ? () async {
                         
                    
  
                          Navigator.push(
                           context,
                            MaterialPageRoute(
                              builder: (context) =>  SignUpPage(),
                            ),
                          );
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    padding:
                        const EdgeInsets.symmetric(horizontal: 32.0, vertical: 12.0),
                  ),
                  child: const Text('Get Started'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPage(BuildContext context, String imagePath, String title,String dis) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(imagePath),
              fit: BoxFit.cover,
            ),
          ),
        ),
        Positioned(
          bottom: 150,
          left: 50,
          child: Center(
            child: Container(
              alignment: Alignment.center,
              width: MediaQuery.of(context).size.width-100,
              height: 230,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    title,
                    style: const TextStyle(
                      
                      color: Colors.white,
                      fontSize: 35,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      textAlign: TextAlign.center,
                      dis,
                      style: const TextStyle(
                        
                        color: Color.fromARGB(255, 192, 192, 192),
                        fontSize: 18,
                        
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
