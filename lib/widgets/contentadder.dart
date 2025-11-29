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
        showDialog(context: context, builder: (_) => errorDialoge);
      });
      errorDialogeKey = 0;
    } else if (successDialogeKey == 1) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showDialog(context: context, builder: (_) => successDialoge);
      });
      successDialogeKey = 0;
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.subjectName)),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Title", style: TextStyle(fontSize: 30)),
              SizedBox(
                width: 600,
                child: TextField(
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter Title",
                  ),
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: title ?? "",
                      selection: TextSelection.collapsed(
                        offset: (title ?? "").length,
                      ),
                    ),
                  ),
                  onChanged: (value) => title = value,
                ),
              ),

              SizedBox(height: 20),
              Text("Description", style: TextStyle(fontSize: 30)),
              SizedBox(
                width: 600,
                height: 200,
                child: TextField(
                  maxLines: 18,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue, width: 2.0),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Enter Description",
                  ),
                  controller: TextEditingController.fromValue(
                    TextEditingValue(
                      text: description ?? "",
                      selection: TextSelection.collapsed(
                        offset: (description ?? "").length,
                      ),
                    ),
                  ),
                  onChanged: (value) => description = value,
                ),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20,
                  ),
                  textStyle: const TextStyle(fontSize: 20),
                ),
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
                child: Text("Upload File", style: TextStyle(fontSize: 20)),
              ),

              SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 20,
                  ),
                  textStyle: const TextStyle(fontSize: 30),
                ),
                onPressed: () async {
                  if (filepath == null || filepath == "") {
                    filepath = "_nofile_";
                  }
                  if (title == null ||
                      description == null ||
                      title == "" ||
                      description == "") {
                    setState(() => errorDialogeKey = 1);
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
          ),
        ),
      ),
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
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 200,
          width: 300,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Error Occurred", style: TextStyle(fontSize: 20)),
                SizedBox(height: 30),
                Text(
                  "Please fill all the fields and try again.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          ),
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
        padding: const EdgeInsets.all(10.0),
        child: SizedBox(
          height: 200,
          width: 400,
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Successfully added content",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                Text(
                  "Your content is added successfully.",
                  style: TextStyle(fontSize: 15),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text("OK"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
