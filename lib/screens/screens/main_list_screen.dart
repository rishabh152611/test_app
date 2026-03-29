import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/providers/task_provider.dart';
import '../../providers/providers/theme_provider.dart';

import 'task_form_screen.dart';
import 'leaderboard_screen.dart';
import 'completed_tasks_screen.dart';

class MainListScreen extends StatelessWidget {
  const MainListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[50],
      appBar: _buildAppBar(themeProvider, context, taskProvider),
      body: Column(
        children: [
          _buildModernSearchBar(context, taskProvider, isDark),
          Expanded(
            child: taskProvider.tasks.isEmpty
                ? _buildEmptyState(isDark)
                : _buildTaskList(taskProvider, isDark),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.green[700],
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const TaskFormScreen()),
        ),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          "New Task",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(
      ThemeProvider themeProvider, BuildContext context, TaskProvider taskProvider) {
    return AppBar(
      elevation: 0,
      backgroundColor: themeProvider.isDarkMode ? Colors.black : Colors.green[800],
      title: const Text(
        'FLODO AI',
        style: TextStyle(fontWeight: FontWeight.w900, letterSpacing: 1.2),
      ),
      actions: [
        // Point Counter & Leaderboard Button
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => LeaderboardScreen()),
          ),
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.greenAccent.withOpacity(0.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.stars, color: Colors.greenAccent, size: 18),
                const SizedBox(width: 4),
                Text(
                  "${taskProvider.totalPoints}",
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.history_rounded, color: Colors.greenAccent),
          tooltip: "Completed Tasks",
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => CompletedTasksScreen()),
          ),
        ),
        IconButton(
          icon: Icon(
            themeProvider.isDarkMode ? Icons.wb_sunny_rounded : Icons.nightlight_round,
            color: Colors.greenAccent,
          ),
          onPressed: () => themeProvider.toggleTheme(),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildModernSearchBar(BuildContext context, TaskProvider provider, bool isDark) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? Colors.grey[900] : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? Colors.green.withOpacity(0.3) : Colors.grey[300]!,
                ),
                boxShadow: [
                  if (!isDark)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                ],
              ),
              child: TextField(
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                onChanged: (val) => provider.setSearchQuery(val),
                decoration: InputDecoration(
                  hintText: 'Search active tasks...',
                  hintStyle: TextStyle(color: isDark ? Colors.grey[500] : Colors.grey[400]),
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.green[600]),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(TaskProvider provider, bool isDark) {
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: provider.tasks.length,
      itemBuilder: (context, index) {
        final task = provider.tasks[index];

        // LOGIC: Check if this task is blocked by another task that isn't "Done"
        bool isBlocked = false;
        if (task.blockedById != null && task.blockedById!.isNotEmpty) {
          try {
            // Check if the blocking task exists and is not completed
            final blockingTask = provider.completedTasks.any((t) => t.id == task.blockedById);
            if (!blockingTask) {
              isBlocked = true;
            }
          } catch (e) {
            isBlocked = false;
          }
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: isDark ? Colors.grey[900] : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isBlocked
                  ? Colors.red.withOpacity(0.2)
                  : Colors.green.withOpacity(0.1),
            ),
          ),
          child: Opacity(
            opacity: isBlocked ? 0.5 : 1.0,
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Row(
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    ),
                  ),
                  if (isBlocked)
                    const Icon(Icons.lock_outline, color: Colors.redAccent, size: 20),
                ],
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  Text(
                    task.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: isDark ? Colors.grey[400] : Colors.grey[600]),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildStatusBadge(task.status),
                      const Spacer(),
                      if (task.isRecurring)
                        const Padding(
                          padding: EdgeInsets.only(right: 8.0),
                          child: Icon(Icons.autorenew_rounded, size: 18, color: Colors.greenAccent),
                        ),
                      Icon(Icons.calendar_month_outlined,
                          size: 14, color: isDark ? Colors.grey : Colors.grey[600]),
                      const SizedBox(width: 4),
                      Text(
                        "${task.dueDate.day}/${task.dueDate.month}",
                        style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? Colors.grey : Colors.grey[700]
                        ),
                      ),
                    ],
                  )
                ],
              ),
              onTap: isBlocked
                  ? () => ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("This task is blocked by another task!")))
                  : () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => TaskFormScreen(task: task)),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color = Colors.orange;
    if (status == "In Progress") color = Colors.blue;
    if (status == "Done") color = Colors.green;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Text(
        status,
        style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildEmptyState(bool isDark) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.assignment_turned_in_outlined,
              size: 80, color: Colors.green.withOpacity(0.2)),
          const SizedBox(height: 16),
          Text(
            "No active tasks",
            style: TextStyle(
              color: isDark ? Colors.grey : Colors.black54,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}