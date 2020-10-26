import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class MyPortalNotificationView extends StatefulWidget {
  @override
  _MyPortalNotificationViewState createState() =>
      _MyPortalNotificationViewState();
}

class _MyPortalNotificationViewState extends State<MyPortalNotificationView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.separated(
        padding: EdgeInsets.zero,
        separatorBuilder: (context, i) => const Divider(),
        itemCount: 1,
        itemBuilder: (context, i) {
          return (ListTile(
            contentPadding: EdgeInsets.zero,
            leading: Icon(Icons.account_circle_sharp),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'title',
                  style: TextStyle(color: AppColors.defaultColor),
                ),
                RichText(
                  text: TextSpan(children: [
                    TextSpan(
                        text: 'QAR ',
                        style: TextStyle(color: AppColors.defaultColor)),
                    TextSpan(
                        text: '180',
                        style: TextStyle(
                            color: AppColors.defaultColor,
                            fontWeight: FontWeight.bold))
                  ]),
                )
              ],
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: 'Requested By : ',
                            style:
                                TextStyle(color: Colors.black, fontSize: 12)),
                        TextSpan(
                            text: 'Smith',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ])),
                      Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Colors.grey,
                      )
                    ]),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Request No : ',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12)),
                          TextSpan(
                              text: '18/2020',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12))
                        ]),
                      ),
                      RichText(
                        text: TextSpan(children: [
                          TextSpan(
                              text: 'Request On : ',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 12)),
                          TextSpan(
                              text: '18/22/2020',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 12))
                        ]),
                      )
                    ]),
              ],
            ),
          ));
        },
        // children: [

        // ],
      ),
    );
  }
}
