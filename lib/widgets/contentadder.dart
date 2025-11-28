import 'dart:io';

import 'package:class_routine_handler/datamodel.dart';
import 'package:class_routine_handler/dataservice.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class ContentAdder extends StatefulWidget {
  final String subjectName;
  const ContentAdder({super.key, required this.subjectName});

  @override
  State<ContentAdder> createState() => _ContentAdderState();
}

class _ContentAdderState extends State<ContentAdder> {
  String? filepath;
  String? title;
  String? description;
  Widget errorDialoge = ErrorDialoge();
  Widget successDialoge = SuccessDialoge();
  int errorDialogeKey = 0;
  int successDialogeKey = 0;
  @override
  Widget build(BuildContext context) {
    if (errorDialogeKey == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(context: context, builder: (context) => errorDialoge);
      });
      errorDialogeKey = 0;
    } else if (successDialogeKey == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(context: context, builder: (context) => successDialoge);
      });
      successDialogeKey = 0;
    }
    return Column(
      children: [
        Text("Name"),
        TextField(
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: title ?? "",
              selection: TextSelection.collapsed(offset: (title ?? "").length),
            ),
          ),
          onChanged: (value) {
            title = value;
          },
        ),
        Text("Description"),
        TextField(
          controller: TextEditingController.fromValue(
            TextEditingValue(
              text: description ?? "",
              selection: TextSelection.collapsed(
                offset: (description ?? "").length,
              ),
            ),
          ),
          onChanged: (value) {
            description = value;
          },
        ),
        TextButton(
          onPressed: () async {
            final result = await FilePicker.platform.pickFiles();
            if (result != null) {
              File file = File(result.files.single.path!);
              final path = await getApplicationDocumentsDirectory();
              String fileName = file.path.split('/').last;
              final savedFile = await file.copy('${path.path}/$fileName');
              filepath = savedFile.path;
            }
          },
          child: Text("Upload File"),
          // if (result != null) {,
          // } else {
          //   print("File picking cancelled");
          // }
        ),
        ElevatedButton(
          onPressed: () async {
            if (filepath == null ||
                title == null ||
                description == null ||
                filepath == "" ||
                title == "" ||
                description == "") {
              setState(() {
                errorDialogeKey = 1;
              });
            } else {
              await DataService().addContent(
                widget.subjectName,
                Content(
                  title: title!,
                  filepath: filepath!,
                  description: description!,
                ),
              );
              setState(() {
                title = null;
                description = null;
                filepath = null;
                successDialogeKey = 1;
              });
            }
          },
          child: Text("Add"),
        ),
      ],
    );
  }
}

class ErrorDialoge extends StatefulWidget {
  const ErrorDialoge({super.key});

  @override
  State<ErrorDialoge> createState() => _ErrorDialogeState();
}

class _ErrorDialogeState extends State<ErrorDialoge> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Error Occurred"),
            SizedBox(height: 10),
            Text("Please fill all the fields and try again."),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      ),
    );
  }
}

class SuccessDialoge extends StatefulWidget {
  const SuccessDialoge({super.key});

  @override
  State<SuccessDialoge> createState() => _SuccessDialoge();
}

class _SuccessDialoge extends State<SuccessDialoge> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Successfully added content"),
            SizedBox(height: 10),
            Text("Your content is added successfully."),
            SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text("OK"),
            ),
          ],
        ),
      ),
    );
  }
}
