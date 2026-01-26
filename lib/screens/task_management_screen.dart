import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';
import '../widgets/add_task_dialog.dart';
import '../models/task.dart';

class TaskManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Tasks'),
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          // Lists for managing tasks would be implemented here
          return ListView.builder(
            itemCount: provider.entries.length,
            itemBuilder: (context, index) {
              final entry = provider.entries[index];
              return ListTile(
                title: Text(entry.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    // Delete the entry
                    provider.deleteEntry(entry.id);
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Add new task
          Center(child: Text('No data yet'));
        },
        child: Icon(Icons.add),
        tooltip: 'Add Task',
      ),
    );
  }
}