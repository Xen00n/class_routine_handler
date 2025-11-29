import 'dart:io';

import 'package:class_routine_handler/datamodel.dart';
import 'package:class_routine_handler/dataservice.dart';
import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path/path.dart' as p;

class ContentLoader extends StatefulWidget {
  final String subject;
  final DataService dataService = DataService();

  ContentLoader({super.key, required this.subject});

  @override
  State<ContentLoader> createState() => _ContentLoaderState();
}

class _ContentLoaderState extends State<ContentLoader> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.subject)),

      body: FutureBuilder(
        future: widget.dataService.loadAllContents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final contents = snapshot.data![widget.subject]!;
            if (contents.isEmpty) {
              return Center(
                child: Text(
                  "No content available",
                  style: TextStyle(fontSize: 20),
                ),
              );
            }

            return ListView.builder(
              itemBuilder: (context, index) {
                return ContentCard(contents: contents[index]);
              },
              itemCount: contents.length,
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class ContentCard extends StatefulWidget {
  final Content contents;
  const ContentCard({super.key, required this.contents});

  @override
  State<ContentCard> createState() => _ContentCardState();
}

class _ContentCardState extends State<ContentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Title: ", style: TextStyle(fontSize: 20)),
                Text(widget.contents.title, style: TextStyle(fontSize: 20)),
              ],
            ),

            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Description: ", style: TextStyle(fontSize: 20)),
                Text(
                  widget.contents.description,
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ],
            ),

            const SizedBox(height: 20),

            FileShower(filePath: widget.contents.filepath),
          ],
        ),
      ),
    );
  }
}

class FileShower extends StatefulWidget {
  final String filePath;
  const FileShower({super.key, required this.filePath});

  @override
  State<FileShower> createState() => _FileShowerState();
}

class _FileShowerState extends State<FileShower> {
  @override
  Widget build(BuildContext context) {
    if (widget.filePath == "_nofile_") {
      return Text("No File Attached", style: TextStyle(fontSize: 20));
    }

    String ext = p.extension(widget.filePath).toLowerCase();
    final file = File(widget.filePath);

    // Image preview
    if ([".jpg", ".jpeg", ".png", ".gif", ".bmp"].contains(ext)) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => FullScreenImage(imagePath: file.path),
              ),
            );
          },
          child: Image.file(file, height: 120, width: 120, fit: BoxFit.cover),
        ),
      );
    }

    // Video
    if ([".mp4", ".mov", ".avi"].contains(ext)) {
      return Text(
        "Video File: ${widget.filePath}",
        style: TextStyle(fontSize: 20),
      );
    }

    // PDF
    if (ext == ".pdf") {
      String fileName = p.basename(widget.filePath);
      return Padding(
        padding: const EdgeInsets.only(bottom: 15.0),
        child: ElevatedButton(
          onPressed: () async {
            await OpenFilex.open(file.path);
          },
          child: Text("Open $fileName", style: TextStyle(fontSize: 20)),
        ),
      );
    }

    return Text(
      "Invalid or Unsupported File Type",
      style: TextStyle(fontSize: 20),
    );
  }
}

class FullScreenImage extends StatelessWidget {
  final String imagePath;
  const FullScreenImage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: InteractiveViewer(child: Image.file(File(imagePath))),
      ),
    );
  }
}
