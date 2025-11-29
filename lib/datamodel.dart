class Content {
  String title;
  String filepath;
  String description;

  Content({
    required this.title,
    required this.filepath,
    required this.description,
  });

  Map<String, dynamic> toJson() => {
    'title': title,
    'filepath': filepath,
    'description': description,
  };

  factory Content.fromJson(Map<String, dynamic> json) => Content(
    title: json['title'],
    filepath: json['filepath'],
    description: json['description'],
  );
}

class Subject {
  String name;
  List<Content> contents;

  Subject({required this.name, required this.contents});

  Map<String, dynamic> toJson() => {
    'name': name,
    'contents': contents.map((c) => c.toJson()).toList(),
  };

  factory Subject.fromJson(Map<String, dynamic> json) => Subject(
    name: json['name'],
    contents: (json['contents'] as List)
        .map((c) => Content.fromJson(c))
        .toList(),
  );
}

class Event {
  String id;
  String title;
  String? description;
  DateTime date;

  Event({
    required this.id,
    required this.title,
    this.description,
    required this.date,
  });

  factory Event.fromJson(Map<String, dynamic> json) => Event(
    id: json['id'],
    title: json['title'],
    description: json['description'],
    date: DateTime.parse(json['date']),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "date": date.toIso8601String(),
  };
}
