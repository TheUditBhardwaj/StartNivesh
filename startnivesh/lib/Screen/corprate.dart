import 'startupcall.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';

class CorporateeInvestorsScreen extends StatelessWidget {
  final String userId;

  const CorporateeInvestorsScreen({super.key, required this.userId});


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(" Angel Investor", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.account_circle_outlined),
            color: Colors.grey[900],
            onSelected: (value) {
              if (value == 'change_account') {
                // Add your logout or switch account logic here
                Navigator.pushReplacementNamed(context, '/login');
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'change_account',
                child: Text("Change Account", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Connect with experienced mentors to guide your startup",
              style: TextStyle(color: Colors.grey[400], fontSize: 16),
            ),
            const SizedBox(height: 24),

            _buildMentorCard(
              context: context,
              name: "Alex Johnson",
              uniqueId: "alex-johnson",
              expertise: "Business Strategy",
              image: "assets/images/appLogo.png",
              rating: 4.9,
            ),
            _buildMentorCard(
              context: context,
              name: "Sarah Williams",
              uniqueId: "sarah-williams",
              expertise: "Marketing & Growth",
              image: "assets/images/appLogo.png",
              rating: 4.8,
            ),
            _buildMentorCard(
              context: context,
              name: "Raj Patel",
              uniqueId: "raj-patel",
              expertise: "Technology & Engineering",
              image: "assets/images/appLogo.png",
              rating: 5.0,
            ),
            _buildMentorCard(
              context: context,
              name: "Lisa Chen",
              uniqueId: "lisa-chen",
              expertise: "Finance & Fundraising",
              image: "assets/images/appLogo.png",
              rating: 4.7,
            ),
          ],
        ),
      ),
    );
  }

  String _generateRandomCallId() {
    const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
    final random = Random();
    return String.fromCharCodes(
        Iterable.generate(10, (_) => chars.codeUnitAt(random.nextInt(chars.length)))
    );
  }

  Widget _buildMentorCard({
    required BuildContext context,
    required String name,
    required String uniqueId,
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

            // Action buttons
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Message button
                Container(
                  margin: const EdgeInsets.only(right: 8),
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

                // Video call button
                Container(
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.videocam_outlined,
                      color: Colors.green,
                    ),
                    onPressed: () {
                      _showCallDialog(context, name);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

  }
  void _showCallDialog(BuildContext context, String mentorName) {
    final TextEditingController callIdController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: Text(
            "Video Call with $mentorName",
            style: const TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Enter a call ID or generate a random one:",
                style: TextStyle(color: Colors.grey[300]),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: callIdController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  hintText: "Call ID",
                  hintStyle: TextStyle(color: Colors.grey[500]),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: TextButton.icon(
                  icon: const Icon(Icons.shuffle, color: Colors.amber),
                  label: const Text("Generate Random ID", style: TextStyle(color: Colors.amber)),
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.amber.withOpacity(0.2),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  onPressed: () {
                    callIdController.text = _generateRandomCallId();
                  },
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(color: Colors.grey[400]),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text(
                "Call Now",
                style: TextStyle(color: Colors.green),
              ),
              onPressed: () {
                Navigator.of(context).pop();

                if (callIdController.text.isNotEmpty) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => VideoCallScreen(
                        callId: callIdController.text,
                        peerName: mentorName,
                        userId: userId,
                        serverUrl: "http://localhost:3000", // Replace with your IP!
                      ),
                    ),
                  );
                } else {
                  // Show error or generate default ID
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Please enter a call ID or generate a random one"),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

}