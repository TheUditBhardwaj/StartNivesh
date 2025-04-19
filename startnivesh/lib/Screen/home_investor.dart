import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Investor_bar.dart';
import 'mentorScreen_bar.dart';
import 'startupScreanpro.dart';
import 'homeContent.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'StartNivesh',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: ColorScheme.dark(
          primary: Colors.blue,
          secondary: Colors.purple,
          background: const Color(0xFF121212),
          surface: const Color(0xFF1E1E1E),
        ),
      ),
      home: const IHomeScreen(),
    );
  }
}

// Home Screen
class IHomeScreen extends StatefulWidget {
  const IHomeScreen({super.key});

  @override
  State<IHomeScreen> createState() => _IHomeScreenState();
}

class _IHomeScreenState extends State<IHomeScreen> {
  int _currentNavIndex = 0;

  // List of screens to navigate to
  final List<Widget> _screens = [
    const HomeContentt(),
    const MentorScreen(userId: "founder-uid-123"),
    const ProfileScreen(),
  ];

  final List<Map<String, dynamic>> _activities = [
    {
      "title": "TechLaunch raises \$5M in Series A",
      "time": "2 hours ago",
      "type": "funding",
    },
    {
      "title": "Quantum AI joins the platform",
      "time": "Yesterday",
      "type": "new_startup",
    },
    {
      "title": "Investor John Doe joined as a mentor",
      "time": "2 days ago",
      "type": "mentor",
    },
    {
      "title": "EcoSolutions expands to European markets",
      "time": "3 days ago",
      "type": "expansion",
    },
    {
      "title": "WebDev Pro looking for angel investors",
      "time": "4 days ago",
      "type": "seeking_funding",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'assets/images/appLogo.png',
              width: 32,
              height: 32,
              errorBuilder: (context, error, stackTrace) =>
                  Container(
                    width: 32,
                    height: 32,
                    color: Colors.blue.withOpacity(0.3),
                    child: const Icon(Icons.business, color: Colors.white),
                  ),
            ),
            const SizedBox(width: 10),
            const Text('StartNivesh',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.face, color: Colors.white),
            onPressed: () {
              Navigator.pushNamed(context, '/chatbot');
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications_outlined, color: Colors.white),
            onPressed: () {},
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
              onTap: () {},
              child: const Icon(Icons.messenger, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
      body: _screens[_currentNavIndex], // Display the selected screen

      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              spreadRadius: 0,
            )
          ],
        ),

        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, -2),
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(24),
              topRight: Radius.circular(24),
            ),
            child: BottomNavigationBar(
              backgroundColor: Colors.black,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue[700],
              unselectedItemColor: Colors.grey[400],
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 11,
              ),
              currentIndex: _currentNavIndex,
              onTap: (index) {
                setState(() {
                  _currentNavIndex = index;
                });
              },
              items: [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home_outlined),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.psychology_outlined),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.psychology),
                  ),
                  label: 'Mentor',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person_outline),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
