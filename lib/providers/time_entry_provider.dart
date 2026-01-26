import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import '../models/time_entry.dart';
import '../models/task.dart';
import '../models/project.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;

  List<TimeEntry> _entries = [];

  List<Project> _projects = [];


  List<Task> _tasks = [];

  // Getters
  List<TimeEntry> get entries => _entries;
  List<Project> get projects => _projects;
  List<Task> get tasks => _tasks;
  TimeEntryProvider(this.storage) {
    _loadExpensesFromStorage();
  }
  void _loadExpensesFromStorage() async {
    // await storage.ready;
    var storedEntries = storage.getItem('entries');
    if (storedEntries != null) {
      _entries = List<TimeEntry>.from(
        (storedEntries as List).map((item) => TimeEntry.fromJson(item)),
      );
      notifyListeners();
    }
  }

  

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  // Add a project
  void addProject(Project project) {
    if (!_projects.any((prj) => prj.name == project.name)) {
      _projects.add(project);
      notifyListeners();
    }
  }

  // Delete a project
  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    notifyListeners();
  }

  // Add a task
  void addTask(Task task) {
    if (!_tasks.any((t) => t.name == task.name)) {
      _tasks.add(task);
      notifyListeners();
    }
  }

  // Delete a task
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}