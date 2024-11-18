import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calendar App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  List<Widget> _pages = [
    HomeContent(),
    TasksPage(),
    CalendarPage(),
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Sidebar
          Expanded(
            flex: 1,
            child: Container(
              color: Colors.blue[50],
              child: ListView(
                padding: EdgeInsets.all(20),
                children: [
                  UserHeader(),
                  SidebarItem(
                    icon: Icons.home,
                    title: 'Home',
                    onTap: () => setState(() => _selectedIndex = 0),
                  ),
                  SidebarItem(
                    icon: Icons.list_alt,
                    title: 'Tasks',
                    onTap: () => setState(() => _selectedIndex = 1),
                  ),
                  SidebarItem(
                    icon: Icons.calendar_today,
                    title: 'Calendar',
                    onTap: () => setState(() => _selectedIndex = 2),
                  ),
                  SidebarItem(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () => setState(() => _selectedIndex = 3),
                  ),
                  SidebarItem(
                    icon: Icons.feedback,
                    title: 'Feedback',
                    onTap: () => setState(() => _selectedIndex=3),
                    // Add feedback functionality here
                  ),
                ],
              ),
            ),
          ),

          // Main Content Area
          Expanded(
            flex: 4,
            child: _pages[_selectedIndex], // Display selected page
          ),
        ],
      ),
    );
  }
}

// User profile section in sidebar
class UserHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
         // Add your image path here
        ),
        SizedBox(height: 10),
        Text('Alexa', style: TextStyle(fontSize: 20)),
        Text('alexa.abbott@example.com', style: TextStyle(fontSize: 14)),
      ],
    );
  }
}

// Sidebar item
class SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  SidebarItem({required this.icon, required this.title, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title),
      onTap: onTap,
    );
  }
}

// Home Content
class HomeContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Today\'s Tasks'),
          TaskCard(
            title: 'Make sentences',
            description: 'Find unique layouts nowadays',
            duration: '10 min',
            exercises: '2 exercises',
          ),
          TaskCard(
            title: 'Verification Test',
            description: 'Present Simple test',
            duration: '20 min',
            exercises: '5 exercises',
          ),
          SizedBox(height: 20),
          SectionHeader(title: 'Calendar'),
          CalendarWidget(),
          ProgressSection(),
        ],
      ),
    );
  }
}

// Section header
class SectionHeader extends StatelessWidget {
  final String title;

  SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        title,
        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// Task card
class TaskCard extends StatelessWidget {
  final String title;
  final String description;
  final String duration;
  final String exercises;

  TaskCard({
    required this.title,
    required this.description,
    required this.duration,
    required this.exercises,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(title),
        subtitle: Text('$description \n$duration - $exercises'),
        isThreeLine: true,
      ),
    );
  }
}

// Tasks Page
class TasksPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Tasks'),
          TaskCard(
            title: 'Complete Homework',
            description: 'Math and Science homework.',
            duration: '1 hour',
            exercises: '5 exercises',
          ),
          TaskCard(
            title: 'Grocery Shopping',
            description: 'Buy fruits and vegetables.',
            duration: '30 min',
            exercises: 'N/A',
          ),
          // Add more tasks as needed
        ],
      ),
    );
  }
}

// Calendar Page
class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  Map<DateTime, List<String>> _events = {
    DateTime.utc(2024, 10, 20): ['Event 1', 'Event 2'],
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Calendar'),
          TableCalendar<String>(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _selectedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
              });
            },
            eventLoader: (day) {
              return _events[day] ?? [];
            },
            calendarStyle: CalendarStyle(
              selectedDecoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
              ),
              todayDecoration: BoxDecoration(
                color: Colors.orange,
                shape: BoxShape.circle,
              ),
            ),
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => _showAddEventDialog(),
            child: Text('Add Event'),
          ),
          ...?_events[_selectedDay]?.map((event) => ListTile(title: Text(event))),
        ],
      ),
    );
  }

  void _showAddEventDialog() {
    String eventName = '';
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Event for ${_selectedDay.toLocal()}'.split(' ')[0]),
          content: TextField(
            onChanged: (value) {
              eventName = value;
            },
            decoration: InputDecoration(hintText: 'Enter event name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Add'),
              onPressed: () {
                if (eventName.isNotEmpty) {
                  setState(() {
                    if (_events[_selectedDay] == null) {
                      _events[_selectedDay] = [];
                    }
                    _events[_selectedDay]!.add(eventName);
                  });
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

// Calendar widget placeholder
class CalendarWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      color: Colors.blue[50],
      child: Center(child: Text('Calendar Placeholder')),
    );
  }
}

// Settings Page
class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Settings'),
          SizedBox(height: 20),
          Text('Contact Us'),
          SizedBox(height: 10),
          Text('For any inquiries, please email us at support@example.com'),
          SizedBox(height: 20),
          Text('Version 1.0.0'),

        ],
      ),
    );
  }
}
class FeedbackPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SectionHeader(title: 'Feedback'),
          SizedBox(height: 20),
          Text('Contact Us'),
          SizedBox(height: 10),
          Text('For any inquiries, please email us at support@example.com'),
          SizedBox(height: 20),
          Text('Version 1.0.0'),

        ],
      ),
    );
  }
}

// Progress section
class ProgressSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Progress'),
        Row(
          children: [
            Expanded(child: LinearProgressIndicator(value: 0.5)),
            SizedBox(width: 10),
            Text('50%'),
          ],
        ),
      ],
    );
  }
}
