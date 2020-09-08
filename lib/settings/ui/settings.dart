import 'package:flutter/material.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';

class Settings extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Settings',
        leading: RoundedIconButton(
          iconName: 'assets/icons/back.svg',
          onPressed: () => {Navigator.pop(context)},
        ),
      ),
      body: Container(
        child: ListView(
          children: ListTile.divideTiles(context: context, tiles: [
            ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Fingerprint'),
                  Switch(
                      value: isSwitched,
                      onChanged: (value) {
                        setState(() {
                          isSwitched = value;
                        });
                      })
                ],
              ),
            ),
            ListTile(
              title: Text('Change Password'),
              onTap: () =>
                  {Navigator.of(context).pushNamed(RouteNames.changePassword)},
            ),
          ]).toList(),
        ),
      ),
    );
  }
}
