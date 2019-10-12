import 'dart:async' show Future;
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/model/Event.dart';
import 'package:flutter_app/model/KKTIX.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

import 'package:html/parser.dart' as parser;
import 'package:html/dom.dart' as dom;
import 'package:html_unescape/html_unescape.dart';

Future<List<Event>> fetchEvents(http.Client client) async {
  final response =
  await client.get('https://kktix.com/events.json');

  // Use the compute function to run parseEvents in a separate isolate.
  return compute(parseEvents, response.body);
}

Future<List<Event>> getHtml() async {
  List<Event> list = [];
  http.Response response = await http.get('https://old.accupass.com/editorchoice/learning');
  var unescape = new HtmlUnescape();
  dom.Document document = parser.parse(response.body.trim());

  var l = document.getElementsByClassName('col-xs-12 col-sm-6 col-md-4');
  l.forEach((child) {
    dom.Document doc = parser.parse(unescape.convert(child.innerHtml));
    String divString = doc.getElementsByTagName('body')[0].innerHtml.replaceAll('\"', '').replaceAll('=', '');
    int titleStartIndex = divString.indexOf('name:');
    int titleEndIndex = findLastIndexAfter(divString, titleStartIndex);
    String title = divString.substring(titleStartIndex + 5, titleEndIndex);
    int urlStartIndex = divString.indexOf('eventidnumber:');
    int urlEndIndex = findLastIndexAfter(divString, urlStartIndex);
    String url = "https://www.accupass.com/event/" + divString.substring(urlStartIndex + 14, urlEndIndex);
    list.add(Event(
      url: url,
      published: null,
      title: title,
      summary: null,
      content: null,
      res: 2,
    ));
  });
  return list;
}

int findLastIndexAfter(String str, int index) {
  for (int i = index; i < str.length; i++) {
    if (str.codeUnitAt(i) == ','.codeUnitAt(0)) {
      return i;
    }
  }
  return index + 20;
}

// A function that converts a response body into a List<Event>.
List<Event> parseEvents(String responseBody) {
  return KKTIXModel.fromJson(json.decode(responseBody)).entry;
}

class HomePage extends StatelessWidget {
  final String title;

  HomePage({Key key, this.title}) : super(key: key);

  Future<List<Event>> getCombinedData() async {
    List<Event> listCombined = await fetchEvents(http.Client());
    listCombined.addAll(await getHtml());
    return listCombined;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder<List<Event>>(
        future: getCombinedData(),
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
  final List<Event> events;
  EventsListView({Key key, this.events}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String assetUri;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10.0
      ),
      itemCount: events.length,
      itemBuilder: (context, index) {
        switch (events[index].res) {
          case 1:
            assetUri = 'assets/KKTIX-logo_green.png';
            break;
          case 2:
            assetUri = 'assets/accupass.png';
        }
        return GestureDetector(
          child: new Column(children: <Widget>[
            new Container(child: Image.asset(assetUri),),
            new Container(child: Text(events[index].title),)
          ],)
          ,
          onTap: () => launch(events[index].url),
        );
      },
    );
  }
}
