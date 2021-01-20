import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
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
                    padding: const EdgeInsets.only(top: 14.0),
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
                              top: 12.0, left: 10.0, right: 10.0),
                          child: Text(
                            'Basheer Thathamaparambath',
                            style: TextStyles.titleTextStyle
                                .copyWith(color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, left: 10.0, right: 10.0),
                          child: Container(
                            child: Text(
                                'Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
                                style: TextStyles.subTitleTextStyle
                                    .copyWith(color: AppColors.labelColor)),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 4.0, left: 8.0, right: 10.0),
                          child: Row(
                            children: [
                              Container(
                                child: Text('5 minutes ago',
                                    style: TextStyles.subTitleTextStyle
                                        .copyWith(
                                            fontStyle: FontStyle.italic,
                                            color: AppColors.labelColor)),
                              ),
                            ],
                          ),
                        ),
                      ]),
                ),
              ],
            ),
            Divider(height: 1.0, color: Colors.grey),
          ],
        ),
      ),
      onTap: onPressed,
    );
  }
}
