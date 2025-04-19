
import 'package:flutter/material.dart';
import 'package:startnivesh/main.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';





class HomeContentt extends StatefulWidget {
  const HomeContentt({super.key});

  @override
  State<HomeContentt> createState() => _HomeContenttState();
}
class _HomeContenttState extends State<HomeContentt> {
  int _currentCarouselIndex = 0;

  final List<Map<String, dynamic>> _featuredStartups = [
    {
      "name": "Social-ish",
      "image": "assets/images/socialish.png",
      "category": "Social-mediaApp",
      "description": "Social-ish is a web platform designed to help individuals who find it difficult to initiate or maintain social connections."
    },
    {
      "name": "Nagrik Aur Samvidhan",
      "image": "assets/images/img.png",
      "category": "Law-Tech",
      "description": "An educational app simplifying Indian laws and constitutional rights for citizens."
    },
    {
      "name": "Wheel O Rent",
      "image": "assets/images/img_1.png",
      "category": "Rental",
      "description": "Car Rental Service platform"
    },
    {
      "name": "Bloomify",
      "image": "assets/images/img_2.png",
      "category": "",
      "description": "Blockchain-based decentralized finance solutions"
    },
    {
      "name": "Campus Swap",
      "image": "assets/images/img_3.png",
      "category": "Social",
      "description": "A student marketplace to buy, sell, and exchange items within your campus"
    },
  ];

  final List<Map<String, dynamic>> _trendingStartups = [
    {
      "name": "Social-ish",
      "image": "assets/images/socialish.png",
      "category": "Social-mediaApp",
      // "description": "Social-ish is a web platform designed to help individuals who find it difficult to initiate or maintain social connections."
    },
    {
      "name": "Nagrik Aur Samvidhan",
      "image": "assets/images/img.png",
      "category": "Law-Tech",
      // "description": "An educational app simplifying Indian laws and constitutional rights for citizens."
    },
    {
      "name": "Wheel O Rent",
      "image": "assets/images/img_1.png",
      "category": "Rental",
    },
    {
      "name": "Bloomify",
      "image": "assets/images/img_2.png",
      "category": "",
    },
    {
      "name": "Campus Swap",
      "image": "assets/images/img_3.png",
      "category": "Social",
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
              children: _featuredStartups
                  .asMap()
                  .entries
                  .map((entry) {
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
                  onPressed: () {
                    Navigator.pushNamed(context, '/news');
                  },
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
                  placeholder: (context, url) =>
                      Container(color: Colors.grey[900]),
                  errorWidget: (context, url, error) =>
                      Container(color: Colors.grey[900]),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
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
                    borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12)),
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
                      placeholder: (context, url) =>
                          Container(color: Colors.grey[800]),
                      errorWidget: (context, url, error) =>
                          Container(color: Colors.grey[800]),
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
