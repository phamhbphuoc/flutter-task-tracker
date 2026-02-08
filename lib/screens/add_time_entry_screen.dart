import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';

class AddTimeEntryScreen extends StatefulWidget {
  @override
  _AddTimeEntryScreenState createState() => _AddTimeEntryScreenState();
}

class _AddTimeEntryScreenState extends State<AddTimeEntryScreen> {
  final _formKey = GlobalKey<FormState>();
    String? projectId;
    String? taskId;
  double totalTime = 0.0;
  DateTime date = DateTime.now();
  String notes = '';

  final TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {

    final entryProvider = Provider.of<TimeEntryProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Time Entry'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
            children: <Widget>[
            DropdownButtonFormField<String>(
                value: projectId,
                hint: const Text('Select a project'),
                validator: (value) => value == null ? 'Please select a project' : null,
                onChanged: (String? newValue) {
                    setState(() {
                        projectId = newValue;
                    });
                },
                decoration: InputDecoration(labelText: 'Project'),
                items: entryProvider.projects
                    .map<DropdownMenuItem<String>>((project) {
                        return DropdownMenuItem<String>(
                            value: project.id,
                            child: Text(project.name),
                        );
                    }).toList(),
            ),
            DropdownButtonFormField<String>(
                value: taskId,
                hint: const Text('Select a task'),
                validator: (value) => value == null ? 'Please select a task' : null,
                onChanged: (String? newValue) {
                setState(() {
                    taskId = newValue;
                });
                },
                decoration: InputDecoration(labelText: 'Task'),
                items: entryProvider.tasks
                    .map<DropdownMenuItem<String>>((task) {
                        return DropdownMenuItem<String>(
                            value: task.id,
                            child: Text(task.name),
                        );
                }).toList(),
            ),
            TextFormField(
                controller: _dateController,
                readOnly: true, // Prevents keyboard from appearing
                decoration: InputDecoration(
                    labelText: 'Date',
                    hintText: 'Select a date',
                    prefixIcon: const Icon(Icons.calendar_today),
                    border: const OutlineInputBorder(),
                ),
                onTap: () async {
                    // Trigger the built-in Material Date Picker
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: date,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                    );

                    if (pickedDate != null) {
                    // Update the text field with the selected date
                    // Format: YYYY-MM-DD
                    setState(() {
                        _dateController.text = "${pickedDate.toLocal()}".split(' ')[0];
                        date = pickedDate;
                    });
                    }
                },
            ),
            TextFormField(
                decoration: InputDecoration(labelText: 'Total Time (hours)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                validator: (value) {
                if (value == null || value.isEmpty) {
                    return 'Please enter total time';
                }
                if (double.tryParse(value) == null) {
                    return 'Please enter a valid number';
                }
                return null;
                },
                onSaved: (value) => totalTime = double.parse(value!),
            ),
            TextFormField(
                decoration: InputDecoration(labelText: 'Notes'),
                validator: (value) {
                if (value == null || value.isEmpty) {
                    return 'Please enter some notes';
                }
                return null;
                },
                onSaved: (value) => notes = value!,
            ),
            ElevatedButton(
                onPressed: () {
                if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Provider.of<TimeEntryProvider>(context, listen: false)
                        .addTimeEntry(TimeEntry(
                            id: DateTime.now().toString(), // Simple ID generation
                            projectId: projectId!,
                            taskId: taskId!,
                            totalTime: totalTime,
                            date: date,
                            notes: notes,
                        ));
                    Navigator.pop(context);
                }
                },
                child: Text('Save'),
            )
            ],
        ),
        ),
    );
  }
}