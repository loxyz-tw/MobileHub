import 'Entry.dart';

class KKTIXModel {
  String title;
  DateTime updated;
  List<Entry> entry;

  KKTIXModel({
    this.title,
    this.updated,
    this.entry,
  });

  factory KKTIXModel.fromJson(Map<String, dynamic> json) => KKTIXModel(
    title: json["title"],
    updated: DateTime.parse(json["updated"]),
    entry: List<Entry>.from(json["entry"].map((x) => Entry.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "title": title,
    "updated": updated.toIso8601String(),
    "entry": List<dynamic>.from(entry.map((x) => x.toJson())),
  };
}
