import 'package:class_routine_handler/widgets/calendar.dart';
import 'package:class_routine_handler/widgets/contentadder.dart';
import 'package:class_routine_handler/widgets/contentloader.dart';

import 'package:flutter/material.dart';

class Comp307Page extends StatefulWidget {
  const Comp307Page({super.key});

  @override
  State<Comp307Page> createState() => _Comp307PageState();
}

class _Comp307PageState extends State<Comp307Page> {
  int selectedIndex = 0;
  dynamic contents;
  final String subject = "comp307";

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
