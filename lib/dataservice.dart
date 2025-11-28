import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'datamodel.dart';

class DataService {
  static final subjects = [
    "coeg",
    "comp301",
    "comp307",
    "comp315",
    "mgts",
    "project",
  ];

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/contents.json');
  }

  // Load all contents
  Future<Map<String, List<Content>>> loadAllContents() async {
    final file = await _getFile();
    if (!await file.exists()) {
      // initialize empty map
      return {for (var s in subjects) s: []};
    }
    final jsonStr = await file.readAsString();
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    return data.map(
      (key, value) => MapEntry(
        key,
        (value as List).map((e) => Content.fromJson(e)).toList(),
      ),
    );
  }

  // Save all contents
  Future<void> saveAllContents(Map<String, List<Content>> allContents) async {
    final file = await _getFile();
    final jsonMap = allContents.map(
      (key, value) => MapEntry(key, value.map((c) => c.toJson()).toList()),
    );
    await file.writeAsString(jsonEncode(jsonMap));
  }

  // Add content to a subject
  Future<void> addContent(String subject, Content content) async {
    final allContents = await loadAllContents();
    allContents[subject]?.add(content);
    await saveAllContents(allContents);
    print("successfully added content to $subject");
  }
}
