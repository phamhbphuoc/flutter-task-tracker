import 'package:provider/provider.dart';

import 'package:flutter/material.dart';
import '../models/project.dart';
import '../providers/time_entry_provider.dart';

class AddProjectDialog extends StatefulWidget {
  final Function(Project) onAdd;

  AddProjectDialog({required this.onAdd});

  @override
  _AddProjectDialogState createState() => _AddProjectDialogState();
}

class _AddProjectDialogState extends State<AddProjectDialog> {
  final TextEditingController _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add New Project'),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(
          labelText: 'Project Name',
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Add'),
          onPressed: () {
            var newProject = Project(id: DateTime.now().toString(), name: _controller.text);
            widget.onAdd(newProject);
            // Update the provider and UI
            Provider.of<TimeEntryProvider>(context, listen: false).addProject(newProject);
            // Clear the input field for next input
            _controller.clear();

            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}