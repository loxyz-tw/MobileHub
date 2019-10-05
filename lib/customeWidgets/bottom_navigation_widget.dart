import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/pages/home_page.dart';
import 'package:flutter_app/pages/search_page.dart';
import 'package:flutter_app/pages/setting_page.dart';

class BottomNavigationWidget extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      // Prevent swipe popping of this page. Use explicit exit buttons only.
      onWillPop: () => Future<bool>.value(true),
      child: DefaultTextStyle(
        style: CupertinoTheme.of(context).textTheme.textStyle,
        child: CupertinoTabScaffold(
          tabBar: CupertinoTabBar(
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home),
                title: Text('Home'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.search),
                title: Text('Search'),
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.profile_circled),
                title: Text('Profile'),
              ),
            ],
          ),
          tabBuilder: (BuildContext context, int index) {
            assert(index >= 0 && index <= 2);
            switch (index) {
              case 0:
                return CupertinoTabView(
                  builder: (BuildContext context) {
                    return Homepage();
                  },
                  defaultTitle: 'Colors',
                );
                break;
              case 1:
                return CupertinoTabView(
                  builder: (BuildContext context) => SearchPage(),
                  defaultTitle: 'Search Page',
                );
                break;
              case 2:
                return CupertinoTabView(
                  builder: (BuildContext context) => SettingPage(),
                  defaultTitle: 'Account',
                );
                break;
            }
            return null;
          },
        ),
      ),
    );
  }
}