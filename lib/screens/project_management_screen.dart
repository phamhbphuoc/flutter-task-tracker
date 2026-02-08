import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/time_entry_provider.dart';
import '../widgets/add_project_dialog.dart';
import '../models/project.dart';

class ProjectManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Projects'),
      ),
      body: Consumer<TimeEntryProvider>(
        builder: (context, provider, child) {
          // Lists for managing projects would be implemented here
          return ListView.builder(
            itemCount: provider.projects.length,
            itemBuilder: (context, index) {
              final project = provider.projects[index];
              return ListTile(
                title: Text(project.name),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () {
                    provider.deleteProject(project.id);
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
          showDialog(
            context: context,
            builder: (context) => AddProjectDialog(
              onAdd: (newProject) {
                Provider.of<TimeEntryProvider>(context, listen: false).addProject(newProject);
                Navigator.pop(context); // Close the dialog after adding the new project
              },
            ),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Project',
      ),
    );
  }
}