import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class TaskCommentTile extends StatelessWidget {
  final VoidCallback onPressed;

  TaskCommentTile({this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 13.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              border: Border.all(
                                  color: AppColors.defaultColor, width: 0),
                              borderRadius: BorderRadius.circular(50),
                              image: DecorationImage(
                                  image: AssetImage(
                                      'assets/icons/user_image_placeholder.png'),
                                  fit: BoxFit.fill),
                            ),
                          ),
                        ]),
                  ),
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              top: 11.0, left: 10.0, right: 10.0),
                          child: Text(
                            'Basheer Thathamaparambath',
                            style: TextStyle(
                                color: AppColors.blackColor, fontSize: 16),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 3.0, left: 10.0, right: 10.0),
                          child: Container(
                            child: Text(
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                                style: TextStyle(
                                    color: AppColors.labelColor, fontSize: 14)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 3.0, left: 8.0, right: 10.0),
                          child: Row(
                            children: [
                              Container(
                                child: Text('5 minutes ago',
                                    style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: AppColors.labelColor,
                                        fontSize: 14)),
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
