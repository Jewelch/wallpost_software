import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class TaskListCard extends StatelessWidget {
  final VoidCallback onPressed;

  TaskListCard({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 50,
                  height: 80,
                  child: Column(children: [
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        border:
                            Border.all(color: AppColors.defaultColor, width: 0),
                        borderRadius: BorderRadius.circular(50),
                        image: DecorationImage(
                            image: AssetImage(
                                'assets/icons/user_image_placeholder.png'),
                            fit: BoxFit.fill),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 7.0),
                      child: Text('33%', style: TextStyle(fontSize: 12)),
                    ),
                  ]),
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: 11.0, left: 10.0, right: 10.0),
                          child: Text(
                            'WallPost App Android and IOS Main Navigation ',
                            style: TextStyle(
                                color: AppColors.defaultColor, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 3.0, left: 10.0, right: 10.0),
                          child: Container(
                            alignment: Alignment.centerLeft,
                            child: Row(
                              children: [
                                Text('Assigned to :',
                                    style: TextStyle(
                                        color: AppColors.blackColor,
                                        fontSize: 14)),
                                Text('Jaseel Kiliyanthodi',
                                    style: TextStyle(
                                        color: AppColors.labelColor,
                                        fontSize: 14)),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 3.0, left: 8.0, right: 10.0),
                          child: Row(
                            children: [
                              Container(
                                child: Expanded(
                                  child: Row(
                                    children: [
                                      Text('Start : ',
                                          style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 14)),
                                      Text('21.02.2018',
                                          style: TextStyle(
                                              color: AppColors.labelColor,
                                              fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ),
                              Container(
                                child: Expanded(
                                  child: Row(
                                    children: [
                                      Text('End :',
                                          style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 14)),
                                      Text('21.02.2018',
                                          style: TextStyle(
                                              color: AppColors.labelColor,
                                              fontSize: 14)),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8.0, top: 8.0, bottom: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 70,
                                height: 16,
                                child: Center(
                                    child: Text(
                                  'In Progress',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                )),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(40),
                                    color: AppColors.defaultColor),
                              ),
                              Container(
                                width: 70,
                                height: 16,
                                child: Center(
                                    child: Text(
                                  'Escalated',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 10),
                                )),
                                decoration: BoxDecoration(
                                    shape: BoxShape.rectangle,
                                    borderRadius: BorderRadius.circular(40),
                                    color: AppColors.statusRedColor),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ],
            ),
            Divider(height: 1.0, color: AppColors.greyColor),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }
}
