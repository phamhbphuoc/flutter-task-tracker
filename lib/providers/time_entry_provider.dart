import 'package:flutter/foundation.dart';
import 'package:localstorage/localstorage.dart';
import 'dart:convert';
import '../models/time_entry.dart';

class TimeEntryProvider with ChangeNotifier {
  final LocalStorage storage;
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

  List<TimeEntry> _entries = [];

  List<TimeEntry> get entries => _entries;

  void addTimeEntry(TimeEntry entry) {
    _entries.add(entry);
    notifyListeners();
  }

  void deleteTimeEntry(String id) {
    _entries.removeWhere((entry) => entry.id == id);
    notifyListeners();
  }
}