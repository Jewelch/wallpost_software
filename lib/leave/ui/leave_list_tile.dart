import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class LeaveListTile extends StatefulWidget {
  @override
  _LeaveListTileState createState() => _LeaveListTileState();
}

class _LeaveListTileState extends State<LeaveListTile> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 4),
      child: Row(
        children: [
          Column(
            children: <Widget>[
              Icon(
                Icons.account_circle_sharp,
                size: 36,
                color: Colors.grey,
              ),
              Text('2', style: TextStyle(color: Colors.grey, fontSize: 12)),
              Text('Days', style: TextStyle(fontSize: 14))
            ],
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Name',
                  style: TextStyle(
                    color: AppColors.defaultColor,
                  ),
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'Start : ', style: TextStyle(color: Colors.black, fontSize: 12)),
                          TextSpan(text: '01.01.2020', style: TextStyle(color: Colors.grey, fontSize: 12))
                        ],
                      ),
                    ),
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(text: 'End : ', style: TextStyle(color: Colors.black, fontSize: 12)),
                          TextSpan(text: '01.01.2020', style: TextStyle(color: Colors.grey, fontSize: 12))
                        ],
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios_outlined, color: Colors.grey, size: 14),
                  ],
                ),
                SizedBox(height: 8),
                Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: AppColors.defaultColor),
                    child: Text(
                      'Casual',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                  Text(
                    'Approved',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 12,
                    ),
                  ),
                ])
              ],
            ),
          )
        ],
      ),
    );
  }
}
