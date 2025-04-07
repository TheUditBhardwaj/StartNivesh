// Profile Screen
import 'package:flutter/material.dart';
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile header
          Center(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.blue,
                      width: 3,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image.asset(
                      'assets/images/appLogo.png',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: Colors.grey[800],
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 60,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  "John Entrepreneur",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Founder & CEO at TechStartup",
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildStatItem("Connections", "142"),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey[700],
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    _buildStatItem("Meetings", "38"),
                    Container(
                      height: 30,
                      width: 1,
                      color: Colors.grey[700],
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                    ),
                    _buildStatItem("Pitches", "12"),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // Account settings
          const Text(
            "Account",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            icon: Icons.person_outline,
            title: "Personal Information",
            color: Colors.blue,
          ),
          _buildSettingsItem(
            icon: Icons.business_outlined,
            title: "Startup Profile",
            color: Colors.green,
          ),
          _buildSettingsItem(
            icon: Icons.document_scanner_outlined,
            title: "Pitch Deck",
            color: Colors.orange,
          ),
          _buildSettingsItem(
            icon: Icons.credit_card_outlined,
            title: "Payment Methods",
            color: Colors.purple,
          ),

          const SizedBox(height: 24),

          // App settings
          const Text(
            "App Settings",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildSettingsItem(
            icon: Icons.notifications_outlined,
            title: "Notifications",
            color: Colors.red,
          ),
          _buildSettingsItem(
            icon: Icons.security_outlined,
            title: "Privacy & Security",
            color: Colors.amber,
          ),
          _buildSettingsItem(
            icon: Icons.help_outline,
            title: "Help & Support",
            color: Colors.teal,
          ),
          _buildSettingsItem(
            icon: Icons.info_outline,
            title: "About",
            color: Colors.blue,
          ),

          const SizedBox(height: 24),

          // Sign out button
          Center(
            child: ElevatedButton.icon(
              onPressed: () {
                // Sign out functionality
              },
              icon: const Icon(Icons.logout, color: Colors.white),
              label: const Text(
                "Sign Out",
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.withOpacity(0.7),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.grey[400],
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingsItem({
    required IconData icon,
    required String title,
    required Color color,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: color,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 16,
        ),
        onTap: () {
          // Navigate to specific settings page
        },
      ),
    );
  }
}