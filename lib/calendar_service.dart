import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'datamodel.dart';

class CalendarService {
  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/events.json');
  }

  Future<List<Event>> loadEvents() async {
    final file = await _getFile();
    if (!await file.exists()) return [];

    final str = await file.readAsString();
    final jsonList = jsonDecode(str) as List;
    return jsonList.map((e) => Event.fromJson(e)).toList();
  }

  Future<void> saveEvents(List<Event> events) async {
    final file = await _getFile();
    await file.writeAsString(
      jsonEncode(events.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> addEvent(Event event) async {
    final events = await loadEvents();
    events.add(event);
    await saveEvents(events);
  }

  Future<void> deleteEvent(String id) async {
    final events = await loadEvents();
    events.removeWhere((e) => e.id == id);
    await saveEvents(events);
  }

  Future<void> removePastEvents() async {
    final events = await loadEvents();
    final now = DateTime.now();

    events.removeWhere(
      (e) => e.date.isBefore(DateTime(now.year, now.month, now.day)),
    );

    await saveEvents(events);
  }
}
