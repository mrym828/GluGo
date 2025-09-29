import 'package:flutter/material.dart';
import '../widgets/shared_components.dart';
import '../utils/theme.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),  
      
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User Profile Card
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const CircleAvatar(
                      radius: 32,
                      backgroundImage: NetworkImage(
                          "https://i.pravatar.cc/150?img=47"), // placeholder
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text("Malak Nasr",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          SizedBox(height: 4),
                          Text("aisha@example.com",
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 4),
                          Text("Type 2 Diabetes • UAE Region",
                              style: TextStyle(color: Colors.grey)),
                        ],
                      ),
                    ),
                    IconButton(
                        onPressed: () {}, icon: const Icon(Icons.edit, color: Colors.teal))
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Account Section
            _buildSection("Account", [
              _ProfileTile(
                  icon: Icons.lock,
                  title: "Privacy & Security",
                  subtitle: "Manage password, 2FA and sessions",
                  trailing: "2FA On"),
              _ProfileTile(
                  icon: Icons.notifications,
                  title: "Notifications",
                  subtitle: "Push, email, glucose alerts",
                  trailing: "Enabled"),
              _ProfileTile(
                  icon: Icons.language,
                  title: "Language",
                  subtitle: "English / العربية",
                  trailing: ""),
            ]),

            const SizedBox(height: 16),

            // Health Settings Section
            _buildSection("Health Settings", [
              _ProfileTile(
                  icon: Icons.show_chart,
                  title: "Glucose Range",
                  subtitle: "Target and alerts",
                  trailing: "70–180 mg/dL"),
              _ProfileTile(
                  icon: Icons.devices,
                  title: "Connected Devices",
                  subtitle: "Sensors and apps",
                  trailing: "CGM Linked"),
              _ProfileTile(
                  icon: Icons.restaurant,
                  title: "Meal Preferences",
                  subtitle: "Dietary filters and cuisines",
                  trailing: ""),
            ]),

            const SizedBox(height: 16),

            // Logout + Delete Account
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.teal),
                    title: const Text("Log Out",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                    onTap: () {},
                  ),
                  Container(
                    margin: const EdgeInsets.all(12),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12))),
                      child: const Text("Delete Account"),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

PreferredSizeWidget _buildAppBar() {
    return const SharedAppBar(
      title: 'GluGo',
      showBackButton: false,
      showConnection: true,
    );
  }
  // Section builder
  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Text(title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14)),
            ),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ProfileTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String trailing;

  const _ProfileTile(
      {required this.icon,
      required this.title,
      required this.subtitle,
      required this.trailing});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.teal),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: trailing.isNotEmpty
          ? Text(trailing, style: const TextStyle(color: Colors.grey))
          : const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: () {},
    );
  }
}
