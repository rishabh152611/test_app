import 'package:hive/hive.dart';

part 'task_model.g.dart'; // Run: flutter packages pub run build_runner build

@HiveType(typeId: 0)
class TaskModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String title; // [cite: 10]

  @HiveField(2)
  String description; // [cite: 11]

  @HiveField(3)
  DateTime dueDate; // [cite: 12]

  @HiveField(4)
  String status; // "To-Do", "In Progress", "Done" [cite: 13]

  @HiveField(5)
  String? blockedById; // [cite: 14]

  @HiveField(6)
  bool isRecurring; //

  TaskModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    this.status = "To-Do",
    this.blockedById,
    this.isRecurring = false,
  });
}