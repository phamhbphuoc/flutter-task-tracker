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
    _initStorage();
  }

  void _initStorage() {
    _loadExpensesFromStorage();
    _loadProjectsFromStorage();
    _loadTasksFromStorage();
    
    // Initialize empty lists if they don't exist
    if (storage.getItem('timeEntries') == null) {
      storage.setItem('timeEntries', jsonEncode([]));
    }
    if (storage.getItem('projects') == null) {
      storage.setItem('projects', jsonEncode([]));
    }
    if (storage.getItem('tasks') == null) {
      storage.setItem('tasks', jsonEncode([]));
    }
  }

  void _loadExpensesFromStorage() {
    var storedEntries = storage.getItem('timeEntries');
    if (storedEntries != null) {
      _entries = List<TimeEntry>.from(
        (storedEntries as List).map((item) => TimeEntry.fromJson(item as Map<String, dynamic>)),
      );
      notifyListeners();
    }
  }

  void _loadProjectsFromStorage() {
    var storedProjects = storage.getItem('projects');
    if (storedProjects != null) {
      _projects = List<Project>.from(
        (storedProjects as List).map((item) => Project.fromJson(item as Map<String, dynamic>)),
      );
      notifyListeners();
    }
  }

  void _loadTasksFromStorage() {
    var storedTasks = storage.getItem('tasks');
    if (storedTasks != null) {
      _tasks = List<Task>.from(
        (storedTasks as List).map((item) => Task.fromJson(item as Map<String, dynamic>)),
      );
      notifyListeners();
    }
  }

  

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    _saveEntriesToStorage();
    notifyListeners();
  }

  // Add a project
  void addProject(Project project) {
    if (!_projects.any((prj) => prj.name == project.name)) {
      _projects.add(project);
      _saveProjectsToStorage();
      notifyListeners();
    }
  }

  // Delete a project
  void deleteProject(String id) {
    _projects.removeWhere((project) => project.id == id);
    _saveProjectsToStorage();
    notifyListeners();
  }

  // Add a task
  void addTask(Task task) {
    if (!_tasks.any((t) => t.name == task.name)) {
      _tasks.add(task);
      _saveTasksToStorage();
      notifyListeners();
    }
  }

  // Delete a task
  void deleteTask(String id) {
    _tasks.removeWhere((task) => task.id == id);
    _saveTasksToStorage();
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    _saveEntriesToStorage();
    notifyListeners();
  }

  void _saveEntriesToStorage() {
    storage.setItem('timeEntries', 
      jsonEncode(_entries.map((entry) => entry.toJson()).toList())
    );
  }
  void _saveProjectsToStorage() {
    storage.setItem('projects',
      jsonEncode(_projects.map((project) => project.toJson()).toList())
    );
  }

  void _saveTasksToStorage() {
    storage.setItem('tasks',
      jsonEncode(_tasks.map((task) => task.toJson()).toList())
    );
  }}