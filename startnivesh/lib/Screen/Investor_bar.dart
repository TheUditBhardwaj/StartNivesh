import 'package:flutter/material.dart';

class InvestorsScreen extends StatelessWidget {
  const InvestorsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Investors",
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Find and connect with investors for your startup",
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),

          // Investor Categories
          _buildCategoryCard(
            context: context,
            icon: Icons.account_balance,
            title: "Angel Investors",
            description: "Early stage funding for startups",
            color: Colors.blue,
            route: '/angel-investors',
          ),
          _buildCategoryCard(
            context: context,
            icon: Icons.business_center,
            title: "Venture Capital Firms",
            description: "Series funding for growing startups",
            color: Colors.purple,
            route: '/venture-capital',
          ),
          _buildCategoryCard(
            context: context,
            icon: Icons.people,
            title: "Corporate Investors",
            description: "Strategic partnerships and investments",
            color: Colors.orange,
            route: '/corporate-investors',
          ),
          _buildCategoryCard(
            context: context,
            icon: Icons.public,
            title: "International Investors",
            description: "Global funding opportunities",
            color: Colors.green,
            route: '/international-investors',
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String description,
    required Color color,
    required String route,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: color,
            size: 28,
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Text(
            description,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 14,
            ),
          ),
        ),
        trailing: const Icon(
          Icons.arrow_forward_ios,
          color: Colors.white,
          size: 16,
        ),
        onTap: () {
          // Navigate to specific investor category
          Navigator.pushNamed(context, route);
        },
      ),
    );
  }
}