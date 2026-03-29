import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers/task_provider.dart';


class CompletedTasksScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final completedTasks = Provider.of<TaskProvider>(context).completedTasks;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(title: const Text("COMPLETED TASKS")),
      body: completedTasks.isEmpty
          ? const Center(child: Text("No tasks completed yet!"))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: completedTasks.length,
        itemBuilder: (context, index) {
          final task = completedTasks[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.05),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.green.withOpacity(0.2)),
            ),
            child: ListTile(
              title: Text(task.title, style: const TextStyle(decoration: TextDecoration.lineThrough)),
              trailing: const Icon(Icons.check_circle, color: Colors.green),
            ),
          );
        },
      ),
    );
  }
}