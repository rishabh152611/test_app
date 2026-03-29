import 'package:hive_flutter/hive_flutter.dart';
import '../../models/models/task_model.dart';


class HiveService {
  static const String boxName = 'tasksBox';

  static Future<void> init() async {
    await Hive.initFlutter();
    Hive.registerAdapter(TaskModelAdapter());
    await Hive.openBox<TaskModel>(boxName);
  }

  static Future<List<TaskModel>> getTasks() async {
    final box = Hive.box<TaskModel>(boxName);
    return box.values.toList();
  }

  static Future<void> addTask(TaskModel task) async => await Hive.box<TaskModel>(boxName).put(task.id, task);
  static Future<void> updateTask(TaskModel task) async => await task.save();
  static Future<void> deleteTask(String id) async => await Hive.box<TaskModel>(boxName).delete(id);
}