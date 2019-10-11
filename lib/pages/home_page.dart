import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/Event.dart';
import 'package:flutter_app/model/KKTIX.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;

Future<List<Event>> fetchEvents(http.Client client) async {
  final response =
  await client.get('https://kktix.com/events.json');

  // Use the compute function to run parseEvents in a separate isolate.
  return compute(parseEvents, response.body);
}

//Future<List<Event>> getHtml() async {
//  List<Event> list = [];
//  http.Response response = await http.get('https://www.accupass.com/?area=north');
//  dom.Document document = parser.parse(response.body);
//  document.getElementsByClassName('style-25ba7714-bottom').forEach((child) {
//    list.add(Event(
//      url: child.getElementsByTagName('a')[0].querySelector('href').toString(),
//      published: null,
//      title: child.getElementsByClassName("style-e485c04c-event-card-title")[0].toString(),
//      summary: null,
//      content: null,
//      res: 2,
//    ));
//  });
//  return list;
//}

// A function that converts a response body into a List<Entry>.
List<Event> parseEvents(String responseBody) {
  return KKTIXModel.fromJson(json.decode(responseBody)).entry;
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
      body: FutureBuilder<List<Event>>(
        future: fetchEvents(http.Client()),
        builder: (context, AsyncSnapshot<List<Event>> snapshot) {
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
  final List<Event> events;

  EventsListView({Key key, this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: new Column(children: <Widget>[
            new Container(child: Image.asset('assets/KKTIX-logo_green.png'),),
            new Container(child: Text(events[index].title),)
          ],)
          ,
          onTap: () => launch(events[index].url),
        );
      },
    );
  }
}
