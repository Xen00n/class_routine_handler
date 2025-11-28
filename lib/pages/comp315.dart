import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Comp315Page extends StatefulWidget {
  const Comp315Page({super.key});

  @override
  State<Comp315Page> createState() => _Comp315PageState();
}

class _Comp315PageState extends State<Comp315Page> {
  @override
  Widget build(BuildContext context) {
    return ImageLoader();
  }
}

class ImageLoader extends StatefulWidget {
  const ImageLoader({super.key});

  @override
  State<ImageLoader> createState() => _ImageLoaderState();
}

class _ImageLoaderState extends State<ImageLoader> {
  bool fileFound = false;
  String? imagePath = "";
  @override
  Widget build(BuildContext context) {
    switch (fileFound) {
      case true:
        return Image.file(File(imagePath!));
      default:
        return TextButton(
          onPressed: () async {
            final prefs = await SharedPreferences.getInstance();
            imagePath = prefs.getString('saved_image');
            //print("path: $imagePath");
            setState(() {
              fileFound = true;
            });
          },
          child: Text("Load Image"),
        );
    }
  }
}
