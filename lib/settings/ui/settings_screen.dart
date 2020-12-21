import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_routing/route_names.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool isSwitched = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: 'Settings',
        leading: RoundedIconButton(
          iconName: 'assets/icons/back.svg',
          onPressed: () => {Navigator.pop(context)},
        ),
        showDivider: true,
      ),
      body: Container(
        child: ListView(
          children: [
            /* - Uncomment to show finger print setting
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
            */
            ListTile(
              title: Text('Change Password'),
              onTap: () =>
                  {Navigator.of(context).pushNamed(RouteNames.changePassword)},
            ),
          ],
        ),
      ),
    );
  }
}
