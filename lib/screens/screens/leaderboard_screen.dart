import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers/task_provider.dart';


class LeaderboardScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final points = Provider.of<TaskProvider>(context).totalPoints;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(title: const Text("LEADERBOARD")),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(30),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.green[900],
              borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
            ),
            child: Column(
              children: [
                const CircleAvatar(radius: 50, backgroundColor: Colors.greenAccent, child: Icon(Icons.person, size: 50, color: Colors.black)),
                const SizedBox(height: 15),
                const Text("You (Current Level)", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                Text("$points Points", style: const TextStyle(color: Colors.greenAccent, fontSize: 32, fontWeight: FontWeight.w900)),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _buildLeaderRow("1", "Task Master", "1250 pts", true),
                _buildLeaderRow("2", "Productivity Ninja", "980 pts", false),
                _buildLeaderRow("3", "You", "$points pts", false, isUser: true),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLeaderRow(String rank, String name, String pts, bool isTop, {bool isUser = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: isUser ? Colors.green.withOpacity(0.2) : Colors.grey.withOpacity(0.05),
        borderRadius: BorderRadius.circular(15),
        border: isUser ? Border.all(color: Colors.greenAccent) : null,
      ),
      child: Row(
        children: [
          Text("#$rank", style: TextStyle(fontWeight: FontWeight.bold, color: isTop ? Colors.amber : Colors.green)),
          const SizedBox(width: 20),
          Text(name, style: const TextStyle(fontWeight: FontWeight.w500)),
          const Spacer(),
          Text(pts, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.greenAccent)),
        ],
      ),
    );
  }
}