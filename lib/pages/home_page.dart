import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

Future<EventList> fetchEvents(http.Client client) async {
  final response =
  await client.get('https://kktix.com/events.json');

  // Use the compute function to run parseEvents in a separate isolate.
  return compute(parseEvents, response.body);
}

// A function that converts a response body into a List<Entry>.
EventList parseEvents(String responseBody) {
  return EventList.fromJson(json.decode(responseBody));
}

class EventList {
  String title;
  DateTime updated;
  List<Entry> entry;

  EventList({
    this.title,
    this.updated,
    this.entry,
  });

  factory EventList.fromJson(Map<String, dynamic> json) => EventList(
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

class Entry {
  String url;
  DateTime published;
  String title;
  String summary;
  String content;

  Entry({
    this.url,
    this.published,
    this.title,
    this.summary,
    this.content,
  });

  factory Entry.fromJson(Map<String, dynamic> json) => Entry(
    url: json["url"],
    published: DateTime.parse(json["published"]),
    title: json["title"],
    summary: json["summary"],
    content: json["content"],
  );

  Map<String, dynamic> toJson() => {
    "url": url,
    "published": published.toIso8601String(),
    "title": title,
    "summary": summary,
    "content": content,
  };
}

class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<EventList>(
        future: fetchEvents(http.Client()),
        builder: (context, snapshot) {
          if (snapshot.hasError) print(snapshot.error);

          return snapshot.hasData
              ? EventsListView(events: snapshot.data)
              : Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}

class EventsListView extends StatelessWidget {
  final EventList events;

  EventsListView({Key key, this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: events.entry.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: new Column(children: <Widget>[
            new Container(child: Image.asset('assets/KKTIX-logo_green.png'),),
            new Container(child: Text(events.entry[index].title),)
          ],)
          ,
          onTap: () => launch(events.entry[index].url),
        );
      },
    );
  }
}
