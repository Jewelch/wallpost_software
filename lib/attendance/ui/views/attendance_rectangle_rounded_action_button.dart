import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class AttendanceRectangleRoundedActionButton extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final String? time;
  final String? status;
  final Color? attendanceButtonColor;
  final Color? moreButtonColor;
  final VoidCallback onButtonPressed;
  final VoidCallback onMorePressed;

  AttendanceRectangleRoundedActionButton({
    required this.title,
    required this.subtitle,
    required this.time,
    this.status,
    required this.attendanceButtonColor,
    required this.moreButtonColor,
    required this.onButtonPressed,
    required this.onMorePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          new Positioned(
            right: 0,
            child:
            Container(
              width: MediaQuery.of(context).size.width * 0.3,
              child: MaterialButton(
                height: 64,
                elevation: 0,
                highlightElevation: 0,
                padding: EdgeInsets.only(left: 28),
                color: moreButtonColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child:  RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.arrow_upward,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: " More",
                      ),
                    ],
                  ),
                ),
                onPressed: onMorePressed,
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width * 0.7,
            child: MaterialButton(
              elevation: 0,
              highlightElevation: 0,
              height: 64,
              padding: EdgeInsets.all(8.0),
              color: attendanceButtonColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.0),
                side: BorderSide(color:Colors.transparent,),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title!,
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(subtitle!,
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.locationAddressTextColor))
                      ],
                    ),
                    Column(
                      children: [
                        //  Text( _timeString!,
                        Text(time!,
                            style:
                            TextStyle(fontSize: 16, color: Colors.white)),
                        SizedBox(
                          height: 2,
                        ),

                        if(status==null) Text(""),
                        if(status!=null)
                        Text(status!,
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.attendanceStatusColor))
                      ],
                    ),
                  ]),
              onPressed: onButtonPressed,
            ),
          ),

        ],
      ),
    );

  }


  // Widget _buildPunchInhButton() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width,
  //     margin: EdgeInsets.all(20),
  //     child: Stack(
  //       children: <Widget>[
  //         Positioned(
  //           right: 10,
  //           child: GestureDetector(
  //             onTap: (){
  //               print("dark green");
  //             },
  //             child: Container(
  //               width: MediaQuery.of(context).size.width * 0.32,
  //               padding: EdgeInsets.only(right: 8),
  //               height: 64,
  //               decoration: BoxDecoration(
  //                 color: AppColors.punchInButtonDarkColor,
  //                 borderRadius: BorderRadius.all(
  //                   Radius.circular(20.0),
  //                 ),
  //               ),
  //               child: Align(
  //                   alignment: Alignment.centerRight,
  //                   child: RichText(
  //                     text: TextSpan(
  //                       children: [
  //                         WidgetSpan(
  //                           child: Icon(
  //                             Icons.arrow_upward,
  //                             size: 20,
  //                             color: Colors.white,
  //                           ),
  //                         ),
  //                         TextSpan(
  //                           text: " More",
  //                         ),
  //                       ],
  //                     ),
  //                   )),
  //             ),
  //           ),
  //         ),
  //         GestureDetector(
  //           onTap: (){
  //             print("light green");
  //           },
  //           child: Container(
  //             width: MediaQuery.of(context).size.width * 0.68,
  //             margin: EdgeInsets.only(right: 72),
  //             padding: EdgeInsets.all(12),
  //             height: 64,
  //             decoration: BoxDecoration(
  //               color: AppColors.punchInButtonLightColor,
  //               borderRadius: BorderRadius.all(
  //                 Radius.circular(20.0),
  //               ),
  //             ),
  //             child: Row(
  //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 children: [
  //                   Column(
  //                     crossAxisAlignment: CrossAxisAlignment.start,
  //                     children: [
  //                       Text(
  //                         "Punch In",
  //                         style: TextStyle(fontSize: 16, color: Colors.white),
  //                       ),
  //                       SizedBox(
  //                         height: 2,
  //                       ),
  //                       Text(_locationAddress.length > 20 ? '${_locationAddress.substring(0, 20)}...' : _locationAddress,
  //                           style: TextStyle(
  //                               fontSize: 12,
  //                               color: AppColors.locationAddressTextColor))
  //                     ],
  //                   ),
  //                   Column(
  //                     children: [
  //                       //  Text( _timeString!,
  //                       Text("10:10",
  //                           style:
  //                           TextStyle(fontSize: 16, color: Colors.white)),
  //                       SizedBox(
  //                         height: 2,
  //                       ),
  //                       Text("Absent",
  //                           style: TextStyle(
  //                               fontSize: 12,
  //                               color: AppColors.attendanceStatusColor))
  //                     ],
  //                   ),
  //                 ]),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

}