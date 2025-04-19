import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'Investor_bar.dart';
import 'mentorScreen_bar.dart';
import 'startupScreanpro.dart';
import 'startupcall.dart'; // Import the call screen
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
      home: const MHomeScreen(),
    );
  }
}

// Home Screen
class MHomeScreen extends StatefulWidget {
  const MHomeScreen({super.key});

  @override
  State<MHomeScreen> createState() => _MHomeScreenState();
}

class _MHomeScreenState extends State<MHomeScreen> {
  int _currentNavIndex = 0;

  // List of screens to navigate to - Added MentorScreen
  final List<Widget> _screens = [
    const HomeContentt(),
    const InvestorsScreen(),
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

  // Method to handle video call initiation
  void initiateVideoCall({required String callId, required String peerName, required String userId}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => VideoCallScreen(
          callId: callId,
          peerName: peerName,
          userId: userId,
          serverUrl: "http://localhost:3000",
        ),
      ),
    );
  }

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
                    child: Icon(Icons.handshake_outlined),
                  ),
                  activeIcon: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.handshake),
                  ),
                  label: 'Investors',
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


class HomeContent extends StatefulWidget {
  const HomeContent({super.key});

  @override
  State<HomeContent> createState() => _HomeContentState();
}

class _HomeContentState extends State<HomeContent> {
  int _currentCarouselIndex = 0;

  final List<Map<String, dynamic>> _featuredStartups = [
    {
      "name": "NeoVenture AI",
      "image": "assets/images/socialish.png",
      "category": "Artificial Intelligence",
      "description": "Revolutionizing business intelligence with AI"
    },
    {
      "name": "GreenTech Solutions",
      "image": "assets/images/appLogo.png",
      "category": "CleanTech",
      "description": "Sustainable energy solutions for tomorrow"
    },
    {
      "name": "HealthPlus",
      "image": "assets/images/appLogo.png",
      "category": "HealthTech",
      "description": "AI-powered preventive healthcare platform"
    },
    {
      "name": "FinEdge",
      "image": "assets/images/appLogo.png",
      "category": "FinTech",
      "description": "Blockchain-based decentralized finance solutions"
    },
    {
      "name": "EduSmart",
      "image": "assets/images/appLogo.png",
      "category": "EdTech",
      "description": "Next-generation personalized learning platform"
    },
  ];

  final List<Map<String, dynamic>> _trendingStartups = [
    {
      "name": "CyberShield",
      "image": "assets/images/appLogo.png",
      "category": "Cybersecurity",
    },
    {
      "name": "FinFlow",
      "image": "assets/images/appLogo.png",
      "category": "FinTech",
    },
    {
      "name": "EduSpark",
      "image": "assets/images/appLogo.png",
      "category": "EdTech",
    },
    {
      "name": "MetaWorld",
      "image": "assets/images/appLogo.png",
      "category": "Metaverse",
    },
    {
      "name": "FoodDelivr",
      "image": "assets/images/appLogo.png",
      "category": "FoodTech",
    },
    {
      "name": "TravelBuddy",
      "image": "assets/images/appLogo.png",
      "category": "Travel",
    },
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
    return RefreshIndicator(
      onRefresh: () async {
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          setState(() {
            // Refresh data if needed
          });
        }
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Featured Startups
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Featured Startups",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "See All",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CarouselSlider(
              items: _buildFeaturedStartupCards(),
              options: CarouselOptions(
                height: 220,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 0.85,
                autoPlayInterval: const Duration(seconds: 5),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                pauseAutoPlayOnTouch: true,
                enlargeFactor: 0.2,
                enableInfiniteScroll: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    _currentCarouselIndex = index;
                  });
                },
              ),
            ),
            const SizedBox(height: 8),
            // Carousel indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _featuredStartups.asMap().entries.map((entry) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _currentCarouselIndex == entry.key
                        ? Colors.blue
                        : Colors.grey.withOpacity(0.5),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 20),

            // Trending Now
            const Text(
              "Trending Now",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 12),
            _buildTrendingStartups(),

            const SizedBox(height: 24),

            // Recent Updates
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Recent Activity",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "View All",
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildRecentActivity(),
          ],
        ),
      ),
    );
  }

  // Featured Startups - Carousel Items
  List<Widget> _buildFeaturedStartupCards() {
    return _featuredStartups.map((startup) {
      return GestureDetector(
        onTap: () {},
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 5),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.blue.withOpacity(0.7),
                Colors.purple.withOpacity(0.7),
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Stack(
            children: [
              // Background image with gradient overlay
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: startup["image"].toString().startsWith("assets/")
                    ? Image.asset(
                  startup["image"],
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  errorBuilder: (context, error, stackTrace) =>
                      Container(
                        color: Colors.grey[900],
                        child: Icon(
                          Icons.image_not_supported,
                          color: Colors.grey[600],
                          size: 50,
                        ),
                      ),
                )
                    : CachedNetworkImage(
                  imageUrl: startup["image"],
                  fit: BoxFit.cover,
                  height: double.infinity,
                  width: double.infinity,
                  placeholder: (context, url) => Container(color: Colors.grey[900]),
                  errorWidget: (context, url, error) => Container(color: Colors.grey[900]),
                ),
              ),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8),
                    ],
                  ),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        startup["category"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      startup["name"],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      startup["description"],
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  // Trending Startups - Horizontal Scrollable List
  Widget _buildTrendingStartups() {
    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _trendingStartups.length,
        itemBuilder: (context, index) {
          final startup = _trendingStartups[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 120,
              margin: const EdgeInsets.only(right: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: startup["image"].toString().startsWith("assets/")
                        ? Image.asset(
                      startup["image"],
                      height: 80,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            height: 80,
                            color: Colors.grey[800],
                            child: Icon(
                              Icons.business,
                              color: Colors.grey[600],
                              size: 30,
                            ),
                          ),
                    )
                        : CachedNetworkImage(
                      imageUrl: startup["image"],
                      height: 80,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(color: Colors.grey[800]),
                      errorWidget: (context, url, error) => Container(color: Colors.grey[800]),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          startup["name"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          startup["category"],
                          style: TextStyle(
                            color: Colors.grey[400],
                            fontSize: 12,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // Recent Activity Section
  Widget _buildRecentActivity() {
    return Column(
      children: _activities.map((activity) {
        IconData activityIcon;
        Color activityColor;

        switch (activity["type"]) {
          case "funding":
            activityIcon = Icons.attach_money;
            activityColor = Colors.green;
            break;
          case "new_startup":
            activityIcon = Icons.rocket_launch;
            activityColor = Colors.blue;
            break;
          case "mentor":
            activityIcon = Icons.person;
            activityColor = Colors.purple;
            break;
          case "expansion":
            activityIcon = Icons.public;
            activityColor = Colors.amber;
            break;
          case "seeking_funding":
            activityIcon = Icons.card_giftcard;
            activityColor = Colors.red;
            break;
          default:
            activityIcon = Icons.notifications;
            activityColor = Colors.grey;
        }

        return GestureDetector(
          onTap: () {},
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.05),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.white.withOpacity(0.1),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Avatar/Icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: activityColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    activityIcon,
                    color: activityColor,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        activity["title"],
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        activity["time"],
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),

                // Action
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.arrow_forward, size: 16),
                    color: Colors.white,
                    onPressed: () {},
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}