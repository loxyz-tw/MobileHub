import 'package:flutter/cupertino.dart';

class SettingPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(

      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: CupertinoTheme.of(context).brightness == Brightness.light
              ? CupertinoColors.extraLightBackgroundGray
              : CupertinoColors.darkBackgroundGray,
        ),
        child: ListView(
          children: <Widget>[
            const Padding(padding: EdgeInsets.only(top: 32.0)),
            GestureDetector(
              onTap: () {
                Navigator.of(context, rootNavigator: true).push(
                  CupertinoPageRoute<bool>(
                    fullscreenDialog: true,
                    builder: (BuildContext context) => UserDialog(),
                  ),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  color: CupertinoTheme.of(context).scaffoldBackgroundColor,
                  border: const Border(
                    top: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
                    bottom: BorderSide(color: Color(0xFFBCBBC1), width: 0.0),
                  ),
                ),
                height: 44.0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: SafeArea(
                    top: false,
                    bottom: false,
                    child: Row(
                      children: <Widget>[
                        Text(
                          'Sign in',
                          style: TextStyle(color: CupertinoTheme.of(context).primaryColor),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        leading: CupertinoButton(
          child: const Text('Cancel'),
          padding: EdgeInsets.zero,
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const Icon(
              CupertinoIcons.profile_circled,
              size: 160.0,
              color: Color(0xFF646464),
            ),
            const Padding(padding: EdgeInsets.only(top: 18.0)),
            CupertinoButton.filled(
              child: const Text('Sign in'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}