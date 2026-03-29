import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/models/task_model.dart';
import '../../services/services/hive_service.dart';


class TaskProvider with ChangeNotifier {
  List<TaskModel> _tasks = [];
  bool _isLoading = false;
  String _searchQuery = "";

  // Active tasks (Anything not "Done")
  List<TaskModel> get tasks {
    return _tasks.where((t) {
      final matchesSearch = t.title.toLowerCase().contains(_searchQuery.toLowerCase());
      return t.status != "Done" && matchesSearch;
    }).toList();
  }

  // Completed tasks for the History Screen
  List<TaskModel> get completedTasks => _tasks.where((t) => t.status == "Done").toList();

  // Total Points Calculation (+3 per completed task)
  int get totalPoints => completedTasks.length * 3;

  bool get isLoading => _isLoading;

  Future<void> loadTasks() async {
    _tasks = await HiveService.getTasks();
    notifyListeners();
  }

  void setSearchQuery(String q) {
    _searchQuery = q;
    notifyListeners();
  }

  Future<void> addTask(TaskModel task) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simulated delay
    await HiveService.addTask(task);
    _tasks.add(task);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateTask(TaskModel updatedTask) async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2)); // Simulated delay

    // RECURRING LOGIC: If set to Done and is Recurring, create the next one
    if (updatedTask.status == "Done" && updatedTask.isRecurring) {
      final newTask = TaskModel(
        id: const Uuid().v4(),
        title: updatedTask.title,
        description: updatedTask.description,
        dueDate: updatedTask.dueDate.add(const Duration(days: 1)),
        status: "To-Do",
        isRecurring: true,
      );
      await HiveService.addTask(newTask);
      _tasks.add(newTask);
      updatedTask.isRecurring = false; // The current one stops recurring
    }

    await HiveService.updateTask(updatedTask);

    // Refresh the local list
    int index = _tasks.indexWhere((t) => t.id == updatedTask.id);
    if (index != -1) {
      _tasks[index] = updatedTask;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> deleteTask(String id) async {
    await HiveService.deleteTask(id);
    _tasks.removeWhere((t) => t.id == id);
    notifyListeners();
  }
}