import 'package:flutter/material.dart';
import '../utils/theme.dart';
import '../widgets/shared_components.dart';

class InsightsScreen extends StatelessWidget {
  const InsightsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // 14-Day Summary
            _buildCard(
              "14-Day Summary",
              subtitle: "Updated today",
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _SummaryItem(label: "Average Glucose", value: "118 mg/dL"),
                      _SummaryItem(label: "Time in Range", value: "74%"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: const [
                      _SummaryItem(label: "High / Low Events", value: "3 / 1"),
                      _SummaryItem(label: "GMI", value: "6.1%"),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Container(
                    height: 120,
                    color: Colors.grey.shade200,
                    alignment: Alignment.center,
                    child: const Text("Interactive line/area chart"),
                  )
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Meal Impact
            _buildCard(
              "Meal Impact (Predicted)",
              subtitle: "Top 3",
              child: Column(
                children: const [
                  _MealTile(
                      meal: "Chicken Shawarma",
                      impact: "+24 mg/dL • 60–90m",
                      color: Colors.orange),
                  _MealTile(
                      meal: "Sweet Karak Tea",
                      impact: "+32 mg/dL • 30–45m",
                      color: Colors.red),
                  _MealTile(
                      meal: "Fattoush",
                      impact: "+10 mg/dL • 45–60m",
                      color: Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Patterns & Alerts
            _buildCard(
              "Patterns & Alerts",
              subtitle: "Last 14 days",
              child: Column(
                children: const [
                  _PatternTile(
                      title: "Morning highs",
                      subtitle: "3 days between 7–9am above range",
                      status: "Review",
                      statusColor: Colors.orange),
                  _PatternTile(
                      title: "Stable nights",
                      subtitle: "87% time in range 12–6am",
                      status: "Good",
                      statusColor: Colors.green),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Recommendations
            _buildCard(
              "Recommendations",
              subtitle: "Personalized",
              child: Column(
                children: const [
                  _RecommendationTile(
                      title: "Prebreakfast check",
                      subtitle: "Add a quick 10g protein snack if fasting >12h",
                      action: "Action"),
                  _RecommendationTile(
                      title: "Post-meal walk",
                      subtitle: "10–15 min after higher-carb meals",
                      action: "Try it"),
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
  Widget _buildCard(String title, {String? subtitle, required Widget child}) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (subtitle != null)
                  Text(subtitle, style: const TextStyle(color: Colors.grey)),
              ],
            ),
            const SizedBox(height: 12),
            child,
          ],
        ),
      ),
    );
  }
}

// Summary Item
class _SummaryItem extends StatelessWidget {
  final String label;
  final String value;
  const _SummaryItem({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.grey)),
      ],
    );
  }
}

// Meal Tile
class _MealTile extends StatelessWidget {
  final String meal;
  final String impact;
  final Color color;

  const _MealTile(
      {required this.meal, required this.impact, required this.color});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.fastfood, color: Colors.grey),
      title: Text(meal, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(impact),
      trailing: Container(
        width: 20,
        height: 20,
        decoration:
            BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
      ),
    );
  }
}

// Pattern Tile
class _PatternTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String status;
  final Color statusColor;

  const _PatternTile(
      {required this.title,
      required this.subtitle,
      required this.status,
      required this.statusColor});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.warning_amber, color: Colors.orange),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: statusColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(status, style: TextStyle(color: statusColor)),
      ),
    );
  }
}

class _RecommendationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String action;

  const _RecommendationTile(
      {required this.title, required this.subtitle, required this.action});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.lightbulb, color: Colors.blue),
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle),
      trailing: Text(action,
          style: const TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
    );
  }
}
