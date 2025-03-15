import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentNavIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Row(
          children: [
            const SizedBox(width: 10),
            const Text('StartNivesh',
              style: TextStyle(
                color: Colors.white,
                fontSize: 25,
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
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              radius: 16,
              backgroundColor: Colors.grey[800],
              child: const Icon(Icons.person, color: Colors.white, size: 18),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🔥 Featured Startups
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
                viewportFraction: 0.8,
                autoPlayInterval: const Duration(seconds: 5),
              ),
            ),

            const SizedBox(height: 20),

            // 🌎 Trending Now
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

            // 🌎 Explore Categories
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Explore Categories",
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
            const SizedBox(height: 12),
            _buildCategoryGrid(),

            const SizedBox(height: 24),

            // 🚀 Call-to-Action Buttons
            _buildActionButtons(),

            const SizedBox(height: 24),

            // 📢 Recent Updates
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

      // 🏠 Bottom Navigation Bar
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
        child: BottomNavigationBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: Colors.blue,
          unselectedItemColor: Colors.grey,
          currentIndex: _currentNavIndex,
          onTap: (index) {
            setState(() {
              _currentNavIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
            BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline), label: 'Post'),
            BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }

  // 🔥 Featured Startups - Carousel Items
  List<Widget> _buildFeaturedStartupCards() {
    List<Map<String, dynamic>> startups = [
      {
        "name": "NeoVenture AI",
        "image": "https://via.placeholder.com/400x200",
        "category": "Artificial Intelligence",
        "funding": "\$4.2M",
        "description": "Revolutionizing business intelligence with AI"
      },
      {
        "name": "GreenTech Solutions",
        "image": "https://via.placeholder.com/400x200",
        "category": "CleanTech",
        "funding": "\$3.8M",
        "description": "Sustainable energy solutions for tomorrow"
      },
      {
        "name": "HealthPlus",
        "image": "https://via.placeholder.com/400x200",
        "category": "HealthTech",
        "funding": "\$5.5M",
        "description": "AI-powered preventive healthcare platform"
      },
    ];

    return startups.map((startup) {
      return Container(
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
              child: CachedNetworkImage(
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
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.monetization_on, color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "Raised: ${startup["funding"]}",
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        ],
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                          minimumSize: const Size(0, 30),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text("View Profile", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  // 📈 Trending Startups - Horizontal Scrollable List
  Widget _buildTrendingStartups() {
    List<Map<String, dynamic>> trendingStartups = [
      {
        "name": "CyberShield",
        "image": "https://via.placeholder.com/100",
        "category": "Cybersecurity",
      },
      {
        "name": "FinFlow",
        "image": "https://via.placeholder.com/100",
        "category": "FinTech",
      },
      {
        "name": "EduSpark",
        "image": "https://via.placeholder.com/100",
        "category": "EdTech",
      },
      {
        "name": "MetaWorld",
        "image": "https://via.placeholder.com/100",
        "category": "Metaverse",
      },
    ];

    return SizedBox(
      height: 140,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: trendingStartups.length,
        itemBuilder: (context, index) {
          final startup = trendingStartups[index];
          return Container(
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
                  child: CachedNetworkImage(
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
          );
        },
      ),
    );
  }

  // 🌎 Explore Categories - Grid Layout
  Widget _buildCategoryGrid() {
    List<Map<String, dynamic>> categories = [
      {"name": "Tech", "icon": Icons.computer},
      {"name": "Fintech", "icon": Icons.attach_money},
      {"name": "Health", "icon": Icons.health_and_safety},
      {"name": "AI", "icon": Icons.psychology},
      {"name": "E-Commerce", "icon": Icons.shopping_cart},
      {"name": "EdTech", "icon": Icons.school},
    ];

    return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
    itemCount: categories.length,
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    crossAxisSpacing: 12,
    mainAxisSpacing: 12,
    childAspectRatio: 1.2,
    ),
    itemBuilder: (context, index) {
    return Container(
    decoration: BoxDecoration(
    gradient: LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
    Colors.blue.withOpacity(0.2),
    Colors.purple.withOpacity(0.2),
    ],
    ),
    borderRadius: BorderRadius.circular(12),
    border: Border.all(
    color: Colors.white.withOpacity(0.1),
    width: 1,
    ),
    ),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          categories[index]["icon"],
          color: Colors.white,
          size: 28,
        ),
        const SizedBox(height: 8),
        Text(
          categories[index]["name"],
          style: const TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    ),
      );
    },
    );
  }

  // 🚀 Call-to-Action Buttons
  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(right: 8),
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.business, color: Colors.white),
              label: const Text(
                "Join as Startup",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(left: 8),
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              icon: const Icon(Icons.handshake, color: Colors.white),
              label: const Text(
                "Find Investors",
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 📢 Recent Activity Section
  Widget _buildRecentActivity() {
    List<Map<String, dynamic>> activities = [
      {
        "title": "TechLaunch raises \$5M in Series A",
        "time": "2 hours ago",
        "avatar": "https://via.placeholder.com/40",
        "type": "funding",
      },
      {
        "title": "Quantum AI joins the platform",
        "time": "Yesterday",
        "avatar": "https://via.placeholder.com/40",
        "type": "new_startup",
      },
      {
        "title": "Investor John Doe joined as a mentor",
        "time": "2 days ago",
        "avatar": "https://via.placeholder.com/40",
        "type": "mentor",
      },
    ];

    return Column(
      children: activities.map((activity) {
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
          default:
            activityIcon = Icons.notifications;
            activityColor = Colors.grey;
        }

        return Container(
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
        );
      }).toList(),
    );
  }
}