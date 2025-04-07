import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'homeInvestor.dart';
import 'mentorScreen.dart';
import 'startupScreanpro.dart';

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
  int _currentCarouselIndex = 0;

  // List of screens to navigate to
  final List<Widget> _screens = [
    const HomeContent(),
    const InvestorsScreen(),
    const MentorScreen(),
    const ProfileScreen(),
  ];

  final List<Map<String, dynamic>> _featuredStartups = [
    {
      "name": "NeoVenture AI",
      "image": "assets/images/appLogo.png",
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
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {},
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

// Home Content Screen - Contains the original home screen content
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
      "image": "assets/images/appLogo.png",
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


//invexitr
// Investors Screen

// class InvestorsScreen extends StatelessWidget {
//   const InvestorsScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Investors",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "Find and connect with investors for your startup",
//             style: TextStyle(
//               color: Colors.grey[400],
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(height: 24),
//
//           // Investor Categories
//           _buildCategoryCard(
//             icon: Icons.account_balance,
//             title: "Angel Investors",
//             description: "Early stage funding for startups",
//             color: Colors.blue,
//           ),
//           _buildCategoryCard(
//             icon: Icons.business_center,
//             title: "Venture Capital Firms",
//             description: "Series funding for growing startups",
//             color: Colors.purple,
//           ),
//           _buildCategoryCard(
//             icon: Icons.people,
//             title: "Corporate Investors",
//             description: "Strategic partnerships and investments",
//             color: Colors.orange,
//           ),
//           _buildCategoryCard(
//             icon: Icons.public,
//             title: "International Investors",
//             description: "Global funding opportunities",
//             color: Colors.green,
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildCategoryCard({
//     required IconData icon,
//     required String title,
//     required String description,
//     required Color color,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: color.withOpacity(0.3),
//           width: 1,
//         ),
//       ),
//       child: ListTile(
//         contentPadding: const EdgeInsets.all(16),
//         leading: Container(
//           padding: const EdgeInsets.all(12),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Icon(
//             icon,
//             color: color,
//             size: 28,
//           ),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 8),
//           child: Text(
//             description,
//             style: TextStyle(
//               color: Colors.grey[400],
//               fontSize: 14,
//             ),
//           ),
//         ),
//         trailing: const Icon(
//           Icons.arrow_forward_ios,
//           color: Colors.white,
//           size: 16,
//         ),
//         onTap: () {
//           // Navigate to specific investor category
//         },
//       ),
//     );
//   }
// }

// Mentor Screen
// class MentorScreen extends StatelessWidget {
//   const MentorScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           const Text(
//             "Mentorship",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 28,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           Text(
//             "Connect with experienced mentors to guide your startup",
//             style: TextStyle(
//               color: Colors.grey[400],
//               fontSize: 16,
//             ),
//           ),
//           const SizedBox(height: 24),
//
//           // Mentor categories
//           _buildMentorCard(
//             name: "Alex Johnson",
//             expertise: "Business Strategy",
//             image: "assets/images/appLogo.png",
//             rating: 4.9,
//           ),
//           _buildMentorCard(
//             name: "Sarah Williams",
//             expertise: "Marketing & Growth",
//             image: "assets/images/appLogo.png",
//             rating: 4.8,
//           ),
//           _buildMentorCard(
//             name: "Raj Patel",
//             expertise: "Technology & Engineering",
//             image: "assets/images/appLogo.png",
//             rating: 5.0,
//           ),
//           _buildMentorCard(
//             name: "Lisa Chen",
//             expertise: "Finance & Fundraising",
//             image: "assets/images/appLogo.png",
//             rating: 4.7,
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _buildMentorCard({
//     required String name,
//     required String expertise,
//     required String image,
//     required double rating,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 16),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//         border: Border.all(
//           color: Colors.white.withOpacity(0.1),
//           width: 1,
//         ),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             // Mentor image
//             ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: image.startsWith("assets/")
//                   ? Image.asset(
//                 image,
//                 width: 80,
//                 height: 80,
//                 fit: BoxFit.cover,
//                 errorBuilder: (context, error, stackTrace) => Container(
//                   width: 80,
//                   height: 80,
//                   color: Colors.grey[800],
//                   child: const Icon(
//                     Icons.person,
//                     color: Colors.white,
//                     size: 40,
//                   ),
//                 ),
//               )
//                   : CachedNetworkImage(
//                 imageUrl: image,
//                 width: 80,
//                 height: 80,
//                 fit: BoxFit.cover,
//                 placeholder: (context, url) => Container(
//                   width: 80,
//                   height: 80,
//                   color: Colors.grey[800],
//                 ),
//                 errorWidget: (context, url, error) => Container(
//                   width: 80,
//                   height: 80,
//                   color: Colors.grey[800],
//                   child: const Icon(
//                     Icons.person,
//                     color: Colors.white,
//                     size: 40,
//                   ),
//                 ),
//               ),
//             ),
//
//             const SizedBox(width: 16),
//
//             // Mentor details
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     name,
//                     style: const TextStyle(
//                       color: Colors.white,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     expertise,
//                     style: TextStyle(
//                       color: Colors.grey[400],
//                       fontSize: 14,
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       const Icon(
//                         Icons.star,
//                         color: Colors.amber,
//                         size: 18,
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         rating.toString(),
//                         style: const TextStyle(
//                           color: Colors.white,
//                           fontSize: 14,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//
//             // Action button
//             Container(
//               decoration: BoxDecoration(
//                 color: Colors.blue.withOpacity(0.2),
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: IconButton(
//                 icon: const Icon(
//                   Icons.message_outlined,
//                   color: Colors.blue,
//                 ),
//                 onPressed: () {
//                   // Action to message mentor
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// Profile Screen
// class ProfileScreen extends StatelessWidget {
//   const ProfileScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return SingleChildScrollView(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // Profile header
//           Center(
//             child: Column(
//               children: [
//                 const SizedBox(height: 20),
//                 Container(
//                   width: 100,
//                   height: 100,
//                   decoration: BoxDecoration(
//                     shape: BoxShape.circle,
//                     border: Border.all(
//                       color: Colors.blue,
//                       width: 3,
//                     ),
//                   ),
//                   child: ClipRRect(
//                     borderRadius: BorderRadius.circular(50),
//                     child: Image.asset(
//                       'assets/images/appLogo.png',
//                       fit: BoxFit.cover,
//                       errorBuilder: (context, error, stackTrace) => Container(
//                         color: Colors.grey[800],
//                         child: const Icon(
//                           Icons.person,
//                           color: Colors.white,
//                           size: 60,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 const Text(
//                   "John Entrepreneur",
//                   style: TextStyle(
//                     color: Colors.white,
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   "Founder & CEO at TechStartup",
//                   style: TextStyle(
//                     color: Colors.grey[400],
//                     fontSize: 16,
//                   ),
//                 ),
//                 const SizedBox(height: 16),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     _buildStatItem("Connections", "142"),
//                     Container(
//                       height: 30,
//                       width: 1,
//                       color: Colors.grey[700],
//                       margin: const EdgeInsets.symmetric(horizontal: 20),
//                     ),
//                     _buildStatItem("Meetings", "38"),
//                     Container(
//                       height: 30,
//                       width: 1,
//                       color: Colors.grey[700],
//                       margin: const EdgeInsets.symmetric(horizontal: 20),
//                     ),
//                     _buildStatItem("Pitches", "12"),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//
//           const SizedBox(height: 32),
//
//           // Account settings
//           const Text(
//             "Account",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildSettingsItem(
//             icon: Icons.person_outline,
//             title: "Personal Information",
//             color: Colors.blue,
//           ),
//           _buildSettingsItem(
//             icon: Icons.business_outlined,
//             title: "Startup Profile",
//             color: Colors.green,
//           ),
//           _buildSettingsItem(
//             icon: Icons.document_scanner_outlined,
//             title: "Pitch Deck",
//             color: Colors.orange,
//           ),
//           _buildSettingsItem(
//             icon: Icons.credit_card_outlined,
//             title: "Payment Methods",
//             color: Colors.purple,
//           ),
//
//           const SizedBox(height: 24),
//
//           // App settings
//           const Text(
//             "App Settings",
//             style: TextStyle(
//               color: Colors.white,
//               fontSize: 18,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           const SizedBox(height: 16),
//           _buildSettingsItem(
//             icon: Icons.notifications_outlined,
//             title: "Notifications",
//             color: Colors.red,
//           ),
//           _buildSettingsItem(
//             icon: Icons.security_outlined,
//             title: "Privacy & Security",
//             color: Colors.amber,
//           ),
//           _buildSettingsItem(
//             icon: Icons.help_outline,
//             title: "Help & Support",
//             color: Colors.teal,
//           ),
//           _buildSettingsItem(
//             icon: Icons.info_outline,
//             title: "About",
//             color: Colors.blue,
//           ),
//
//           const SizedBox(height: 24),
//
//           // Sign out button
//           Center(
//             child: ElevatedButton.icon(
//               onPressed: () {
//                 // Sign out functionality
//               },
//               icon: const Icon(Icons.logout, color: Colors.white),
//               label: const Text(
//                 "Sign Out",
//                 style: TextStyle(color: Colors.white),
//               ),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: Colors.red.withOpacity(0.7),
//                 padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//               ),
//             ),
//           ),
//
//           const SizedBox(height: 40),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildStatItem(String label, String value) {
//     return Column(
//       children: [
//         Text(
//           value,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 4),
//         Text(
//           label,
//           style: TextStyle(
//             color: Colors.grey[400],
//             fontSize: 14,
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSettingsItem({
//     required IconData icon,
//     required String title,
//     required Color color,
//   }) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(0.05),
//         borderRadius: BorderRadius.circular(12),
//       ),
//       child: ListTile(
//         leading: Container(
//           padding: const EdgeInsets.all(8),
//           decoration: BoxDecoration(
//             color: color.withOpacity(0.2),
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: Icon(
//             icon,
//             color: color,
//           ),
//         ),
//         title: Text(
//           title,
//           style: const TextStyle(
//             color: Colors.white,
//             fontSize: 16,
//           ),
//         ),
//         trailing: const Icon(
//           Icons.arrow_forward_ios,
//           color: Colors.white,
//           size: 16,
//         ),
//         onTap: () {
//           // Navigate to specific settings page
//         },
//       ),
//     );
//   }
// }

