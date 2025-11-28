import 'package:class_routine_handler/widgets/contentadder.dart';
import 'package:class_routine_handler/widgets/contentloader.dart';

import 'package:flutter/material.dart';

class Comp315Page extends StatefulWidget {
  const Comp315Page({super.key});

  @override
  State<Comp315Page> createState() => _Comp315PageState();
}

class _Comp315PageState extends State<Comp315Page> {
  int selectedIndex = 0;
  dynamic contents;
  String subject = "comp315";

  final String subjectName = "comp315";
  @override
  Widget build(BuildContext context) {
    Widget currentWidget = ContentLoader(subject: subject);
    switch (selectedIndex) {
      case 0:
        currentWidget = ContentLoader(subject: subject);
        break;
      case 1:
        currentWidget = ContentAdder(subjectName: subjectName);
        break;
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
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Contents'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add Content'),
        ],
        currentIndex: selectedIndex,
      ),
    );
  }
}
