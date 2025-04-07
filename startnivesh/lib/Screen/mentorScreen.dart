import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MentorScreen extends StatelessWidget {
  const MentorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Mentorship",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Connect with experienced mentors to guide your startup",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),

          // Mentor categories
          _buildMentorCard(
            name: "Alex Johnson",
            expertise: "Business Strategy",
            image: "assets/images/appLogo.png",
            rating: 4.9,
          ),
          _buildMentorCard(
            name: "Sarah Williams",
            expertise: "Marketing & Growth",
            image: "assets/images/appLogo.png",
            rating: 4.8,
          ),
          _buildMentorCard(
            name: "Raj Patel",
            expertise: "Technology & Engineering",
            image: "assets/images/appLogo.png",
            rating: 5.0,
          ),
          _buildMentorCard(
            name: "Lisa Chen",
            expertise: "Finance & Fundraising",
            image: "assets/images/appLogo.png",
            rating: 4.7,
          ),
        ],
      ),
    );
  }
  Widget _buildMentorCard({
    required String name,
    required String expertise,
    required String image,
    required double rating,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Mentor image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: image.startsWith("assets/")
                  ? Image.asset(
                image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              )
                  : CachedNetworkImage(
                imageUrl: image,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[800],
                ),
                errorWidget: (context, url, error) => Container(
                  width: 80,
                  height: 80,
                  color: Colors.grey[800],
                  child: const Icon(
                    Icons.person,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
              ),
            ),

            const SizedBox(width: 16),

            // Mentor details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    expertise,
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                        size: 18,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        rating.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Action button
            Container(
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
              ),
              child: IconButton(
                icon: const Icon(
                  Icons.message_outlined,
                  color: Colors.blue,
                ),
                onPressed: () {
                  // Action to message mentor
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}