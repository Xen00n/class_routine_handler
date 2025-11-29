import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../calendar_service.dart';
import '../datamodel.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarService service = CalendarService();

  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;

  Map<DateTime, List<Event>> events = {};

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    await service.removePastEvents();
    final data = await service.loadEvents();

    final map = <DateTime, List<Event>>{};
    for (var e in data) {
      final key = DateTime(e.date.year, e.date.month, e.date.day);
      map.putIfAbsent(key, () => []).add(e);
    }

    setState(() => events = map);
  }

  List<Event> _getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return events[key] ?? [];
  }

  void _showAddEventDialog() {
    String title = "";
    String description = "";
    DateTime selectedDate = _selectedDay ?? DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Event",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Title (required)",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => title = v,
                  ),

                  const SizedBox(height: 12),

                  TextField(
                    maxLines: 2,
                    decoration: const InputDecoration(
                      labelText: "Description (optional)",
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (v) => description = v,
                  ),

                  const SizedBox(height: 12),

                  ElevatedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime(2010),
                        lastDate: DateTime(2050),
                      );
                      if (picked != null) selectedDate = picked;
                    },
                    child: const Text("Pick Date"),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: const Text("Cancel"),
                        onPressed: () => Navigator.pop(context),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        child: const Text("Add"),
                        onPressed: () async {
                          if (title.trim().isEmpty) return;

                          final event = Event(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            title: title,
                            description: description,
                            date: selectedDate,
                          );

                          await service.addEvent(event);
                          Navigator.pop(context);
                          _loadEvents();
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildEventList() {
    if (_selectedDay == null) {
      return const Center(child: Text("Select a day"));
    }

    final list = _getEventsForDay(_selectedDay!);

    if (list.isEmpty) {
      return const Center(child: Text("No events"));
    }

    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (_, i) {
        final e = list[i];
        return Card(
          child: ListTile(
            title: Text(e.title),
            subtitle: (e.description != null && e.description!.isNotEmpty)
                ? Text(e.description!)
                : null,
            trailing: IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () async {
                await service.deleteEvent(e.id);
                _loadEvents();
              },
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true, // important

      appBar: AppBar(
        title: const Text("Calendar Events"),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: _showAddEventDialog,
          ),
        ],
      ),

      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(2010),
            lastDay: DateTime(2050),
            focusedDay: _focusedDay,

            calendarFormat: _calendarFormat,
            onFormatChanged: (format) {
              setState(() => _calendarFormat = format);
            },

            availableCalendarFormats: const {CalendarFormat.month: "Month"},

            eventLoader: _getEventsForDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

            onDaySelected: (selected, focused) {
              setState(() {
                _selectedDay = selected;
                _focusedDay = focused;
              });
            },
          ),

          const SizedBox(height: 10),

          Expanded(child: _buildEventList()),
        ],
      ),
    );
  }
}
