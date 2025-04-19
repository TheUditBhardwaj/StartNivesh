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
      home: const HomeScreen(),
    );
  }
}

// Home Screen
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  // List of screens to navigate to
  final List<Widget> _screens = [
    const HomeContentt(),
    const InvestorsScreen(),
    const MentorScreen(userId: "founder-uid-123"),
    const ProfileScreen(),
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
              elevation: 8, // Added shadow for depth
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.blue[600], // Slightly adjusted blue
              unselectedItemColor: Colors.grey[500], // Slightly brighter inactive color
              showUnselectedLabels: true,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                letterSpacing: 0.3, // Added letter spacing for better readability
              ),
              unselectedLabelStyle: const TextStyle(
                fontSize: 11,
                letterSpacing: 0.2,
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
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Icon(Icons.home_outlined, size: 24),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Icon(Icons.home, size: 26), // Slightly larger active icon
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Icon(Icons.handshake_outlined, size: 24),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Icon(Icons.handshake, size: 26),
                  ),
                  label: 'Investors',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Icon(Icons.psychology_outlined, size: 24),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Icon(Icons.psychology, size: 26),
                  ),
                  label: 'Mentor',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Icon(Icons.person_outline, size: 24),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Icon(Icons.person, size: 26),
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

