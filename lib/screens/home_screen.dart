import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expense_provider.dart';
import '../screens/add_expense_screen.dart';
import '../screens/category_management_screen.dart';
import '../screens/tag_management_screen.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';
import '../models/expense.dart';
import '../models/expense_category.dart';

import '../screens/add_time_entry_screen.dart';
import '../screens/project_management_screen.dart';
import '../screens/task_management_screen.dart';
import '../models/time_entry.dart';
import '../providers/time_entry_provider.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Time Tracking"),
        backgroundColor: Colors.deepPurple[800],
        foregroundColor: Colors.white,
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white70,
          tabs: [
            Tab(text: "All Entries"),
            Tab(text: "Grouped By Projects"),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.deepPurple),
              child: Center(
                child: Text('Menu',
                    style: TextStyle(color: Colors.white, fontSize: 24)),
              ),
            ),
            ListTile(
              leading: Icon(Icons.folder_rounded, color: Colors.deepPurple),
              title: Text('Projects'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_projects');
              },
            ),
            ListTile(
              leading: Icon(Icons.content_paste, color: Colors.deepPurple),
              title: Text('Tasks'),
              onTap: () {
                Navigator.pop(context); // This closes the drawer
                Navigator.pushNamed(context, '/manage_tasks');
              },
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          buildAllEntries(context),
          buildEntriesByProject(context),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the screen to add a new time entry
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTimeEntryScreen()),
          );
        },
        child: Icon(Icons.add),
        tooltip: 'Add Time Entry',
      ),
    );
  }

  Widget buildAllEntries(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_empty, size: 80, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text("No time entries yet!",
                    style: TextStyle(color: Colors.grey[700], fontSize: 20, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Text("Tap the + button to add your first entry",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              ],
            ),
          );
        }
        return ListView.builder(
          itemCount: provider.entries.length,
          itemBuilder: (context, index) {
            final entry = provider.entries[index];
            String formattedDate =
                DateFormat('MMM dd, yyyy').format(entry.date);
            return Card(
              color: Colors.purple[50],
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: ListTile(
                title: Text(
                    '${getProjectNameById(context, entry.projectId)} - ${getTaskNameById(context, entry.taskId)}',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.deepPurple.shade900,
                    )),
                subtitle: Text(
                    'Total Time: ${entry.totalTime} hours \nDate: ${DateFormat('MMM dd, yyyy').format(entry.date)} \nNote: ${entry.notes}'),
                trailing: IconButton(
                  icon: Icon(Icons.delete, color: Colors.red[700]),
                  onPressed: () {
                    provider.deleteTimeEntry(entry.id);
                  },
                  tooltip: 'Delete entry',
                ),
                onTap: () {
                  // This could open a detailed view or edit screen
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget buildEntriesByProject(BuildContext context) {
    return Consumer<TimeEntryProvider>(
      builder: (context, provider, child) {
        if (provider.entries.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.hourglass_empty, size: 80, color: Colors.grey[400]),
                SizedBox(height: 16),
                Text("No time entries yet!",
                    style: TextStyle(color: Colors.grey[700], fontSize: 20, fontWeight: FontWeight.w600)),
                SizedBox(height: 8),
                Text("Tap the + button to add your first entry",
                    style: TextStyle(color: Colors.grey[600], fontSize: 16)),
              ],
            ),
          );
        }

        // Grouping entries by project
        var grouped = groupBy(provider.entries, (TimeEntry e) => e.projectId);
        return ListView(
          children: grouped.entries.map((entry) {
            String projectName = getProjectNameById(context, entry.key);
            double total = entry.value.fold(0.0,
                (double prev, TimeEntry element) => prev + element.totalTime);
            return Card(
              color: Colors.purple[50],
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      "$projectName",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple,
                      ),
                    ),
                  ),
                  ListView.builder(
                    physics:
                        NeverScrollableScrollPhysics(), // to disable scrolling within the inner list view
                    shrinkWrap:
                        true, // necessary to integrate a ListView within another ListView
                    itemCount: entry.value.length,
                    itemBuilder: (context, index) {
                      TimeEntry timeEntry = entry.value[index];
                      return ListTile(
                        //   leading:
                        //       Icon(Icons.monetization_on, color: Colors.deepPurple),
                        title: Text(
                          "- ${getTaskNameById(context, timeEntry.taskId)} - ${timeEntry.totalTime.toStringAsFixed(2)} hours (${DateFormat('MMM dd, yyyy').format(timeEntry.date)})",
                          style: TextStyle(
                            // fontSize: 16,
                            // fontWeight: FontWeight.w600,
                            // color: Colors.deepPurple.shade800,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }).toList(),
        );
      },
    );
  }

  String getProjectNameById(BuildContext context, String projectId) {
    var project = Provider.of<TimeEntryProvider>(context, listen: false)
        .projects
        .firstWhere((prj) => prj.id == projectId);
    return project.name;
  }

  String getTaskNameById(BuildContext context, String taskId) {
    var task = Provider.of<TimeEntryProvider>(context, listen: false)
        .tasks
        .firstWhere((task) => task.id == taskId);
    return task.name;
  }
}
