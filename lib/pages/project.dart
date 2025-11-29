import 'package:class_routine_handler/widgets/calendar.dart';
import 'package:class_routine_handler/widgets/contentadder.dart';
import 'package:class_routine_handler/widgets/contentloader.dart';

import 'package:flutter/material.dart';

class ProjectPage extends StatefulWidget {
  const ProjectPage({super.key});

  @override
  State<ProjectPage> createState() => _ProjectPageState();
}

class _ProjectPageState extends State<ProjectPage> {
  int selectedIndex = 0;
  dynamic contents;
  final String subject = "project";

  @override
  Widget build(BuildContext context) {
    Widget currentWidget = CalendarPage();
    switch (selectedIndex) {
      case 1:
        currentWidget = ContentLoader(subject: subject);
        break;
      case 2:
        currentWidget = ContentAdder(subjectName: subject);
        break;
      case 0:
        currentWidget = CalendarPage();
      default:
        currentWidget = ContentLoader(subject: subject);
    }
    return Scaffold(
      body: currentWidget,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) => setState(() {
          selectedIndex = value;
        }),
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Contents'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Content'),
        ],
        currentIndex: selectedIndex,
      ),
    );
  }
}
