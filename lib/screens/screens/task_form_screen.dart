import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import '../../models/models/task_model.dart';
import '../../providers/providers/task_provider.dart';
import '../../services/services/draft_service.dart';


class TaskFormScreen extends StatefulWidget {
  final TaskModel? task;
  const TaskFormScreen({Key? key, this.task}) : super(key: key);

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  String _status = "To-Do";
  bool _isRecurring = false;
  DateTime _selectedDate = DateTime.now();
  String? _blockedById;

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      _status = widget.task!.status;
      _isRecurring = widget.task!.isRecurring;
      _selectedDate = widget.task!.dueDate;
      _blockedById = widget.task!.blockedById;
    } else {
      _loadDraft(); // Drafts: Requirement
    }
  }

  Future<void> _loadDraft() async {
    final title = await DraftService.getDraft('title');
    final desc = await DraftService.getDraft('desc');
    if (title != null) _titleController.text = title;
    if (desc != null) _descController.text = desc;
  }

  void _saveDraft() {
    if (widget.task == null) {
      DraftService.saveDraft('title', _titleController.text);
      DraftService.saveDraft('desc', _descController.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TaskProvider>(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        title: Text(widget.task == null ? 'Create Task' : 'Edit Task',
            style: const TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionLabel("Basic Information", isDark),
                const SizedBox(height: 12),
                _buildCustomTextField(_titleController, "Task Title", Icons.title, isDark),
                const SizedBox(height: 16),
                _buildCustomTextField(_descController, "Description", Icons.description_outlined, isDark, maxLines: 3),

                const SizedBox(height: 24),
                _buildSectionLabel("Details & Logic", isDark),
                const SizedBox(height: 12),
                _buildDatePicker(context, isDark),
                const SizedBox(height: 16),
                _buildDropdownRow(isDark),

                const SizedBox(height: 16),
                _buildRecurringToggle(isDark),

                const SizedBox(height: 40),
                _buildSaveButton(provider),
              ],
            ),
          ),

          // Technical Requirement: 2-second delay loading state
          if (provider.isLoading)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.greenAccent),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String text, bool isDark) {
    return Text(text.toUpperCase(),
        style: TextStyle(color: Colors.green[700], fontSize: 12, fontWeight: FontWeight.w900, letterSpacing: 1.1));
  }

  Widget _buildCustomTextField(TextEditingController controller, String label, IconData icon, bool isDark, {int maxLines = 1}) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? Colors.green.withOpacity(0.2) : Colors.grey[300]!),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        onChanged: (_) => _saveDraft(),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.green[600]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildDatePicker(BuildContext context, bool isDark) {
    return InkWell(
      onTap: () async {
        final date = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime(2030),
        );
        if (date != null) setState(() => _selectedDate = date);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? Colors.grey[900] : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: isDark ? Colors.green.withOpacity(0.2) : Colors.grey[300]!),
        ),
        child: Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.green[600]),
            const SizedBox(width: 12),
            Text("Due Date: ${DateFormat('MMM dd, yyyy').format(_selectedDate)}"),
          ],
        ),
      ),
    );
  }

  Widget _buildDropdownRow(bool isDark) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: isDark ? Colors.grey[900] : Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? Colors.green.withOpacity(0.2) : Colors.grey[300]!),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _status,
                items: ["To-Do", "In Progress", "Done"].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setState(() => _status = val!),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecurringToggle(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.green.withOpacity(0.05) : Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green.withOpacity(0.3)),
      ),
      child: SwitchListTile(
        title: const Text("Recurring Task", style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: const Text("Auto-generate next task on completion"),
        value: _isRecurring,
        activeColor: Colors.greenAccent,
        onChanged: (val) => setState(() => _isRecurring = val),
      ),
    );
  }

  Widget _buildSaveButton(TaskProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green[700],
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        // Technical Requirement: Prevent double tapping
        onPressed: provider.isLoading ? null : () async {
          final task = TaskModel(
            id: widget.task?.id ?? const Uuid().v4(),
            title: _titleController.text,
            description: _descController.text,
            dueDate: _selectedDate,
            status: _status,
            isRecurring: _isRecurring,
            blockedById: _blockedById,
          );

          if (widget.task == null) {
            await provider.addTask(task);
            await DraftService.clearDrafts(); // Drafts Requirement
          } else {
            await provider.updateTask(task);
          }
          if (mounted) Navigator.pop(context);
        },
        child: const Text("SAVE TASK", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
      ),
    );
  }
}