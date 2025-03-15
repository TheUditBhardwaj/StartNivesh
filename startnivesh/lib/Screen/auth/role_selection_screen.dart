import 'package:flutter/material.dart';
import 'package:startnivesh/main.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              const Text(
                'Choose Your Role',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Select the role that best describes you',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),
              _buildRoleCard(
                context,
                'Startup',
                'Looking for investment and mentorship',
                Icons.rocket_launch,
                    () =>
                    Navigator.pushNamed(context, '/startup-profile-setup'),
              ),
              const SizedBox(height: 20),
              _buildRoleCard(
                context,
                'Investor',
                'Interested in investing in startups',
                Icons.attach_money,
                    () =>
                    Navigator.pushNamed(context, '/investor-profile-setup'),
              ),
              const SizedBox(height: 20),
              _buildRoleCard(
                context,
                'Mentor',
                'Want to guide and support startups',
                Icons.psychology,
                    () => Navigator.pushNamed(context, '/mentor-profile-setup'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoleCard(BuildContext context, String title, String description,
      IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white24),
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.05)
            ],
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: Colors.white, size: 30),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.7)),
          ],
        ),
      ),
    );
  }
}