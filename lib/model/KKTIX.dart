import 'Event.dart';

class KKTIXModel {
  String title;
  DateTime updated;
  List<Event> entry;

  KKTIXModel({
    this.title,
    this.updated,
    this.entry,
  });

  factory KKTIXModel.fromJson(Map<String, dynamic> json) => KKTIXModel(
    title: json['title'],
    updated: DateTime.parse(json['updated']),
    entry: List<Event>.from(json['entry'].map((x) => Event.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    'title': title,
    'updated': updated.toIso8601String(),
    'entry': List<dynamic>.from(entry.map((x) => x.toJson())),
  };
}
