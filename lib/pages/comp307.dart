import 'package:flutter/material.dart';

class Comp307Page extends StatefulWidget {
  const Comp307Page({super.key});

  @override
  State<Comp307Page> createState() => _Comp307PageState();
}

class _Comp307PageState extends State<Comp307Page> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Text("COMP307 Page"),
    );
  }
}
