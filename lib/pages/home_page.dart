import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/KKTIXModel.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

//import 'package:html/parser.dart' as parser;
//import 'package:html/dom.dart' as dom;

Future<KKTIXModel> fetchEvents(http.Client client) async {
  final response =
  await client.get('https://kktix.com/events.json');

  // Use the compute function to run parseEvents in a separate isolate.
  return compute(parseEvents, response.body);
}

//Future<List<String>> getHtml() async {
//  http.Response response = await http.get('https://www.accupass.com/?area=north');
//  dom.Document document = parser.parse(response.body);
//  List<String> title = document.getElementsByClassName('style-e485c04c-event-card-title');
//}

// A function that converts a response body into a List<Entry>.
KKTIXModel parseEvents(String responseBody) {
  return KKTIXModel.fromJson(json.decode(responseBody));
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
      body: FutureBuilder<KKTIXModel>(
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
  final KKTIXModel events;

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
