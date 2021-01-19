import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class TaskAttachmentTile extends StatelessWidget {
  final VoidCallback onPressed;

  TaskAttachmentTile({this.onPressed});

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
                  height: 70,
                  child: Center(
                    child: SvgPicture.asset('assets/icons/doc_icon.svg',
                        width: 25, height: 25, color: AppColors.defaultColor),
                  ),
                ),
                Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 12.0),
                          child: Text(
                            'Sample Doc',
                            style: TextStyles.titleTextStyle
                                .copyWith(color: Colors.black),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 4.0, bottom: 20),
                          child: Container(
                            child: Text('Microsoft WordDocument',
                                style: TextStyles.subTitleTextStyle
                                    .copyWith(color: AppColors.labelColor)),
                          ),
                        ),
                      ]),
                ),
                SizedBox(
                  width: 70,
                  height: 70,
                  child: Center(
                    child: SvgPicture.asset('assets/icons/download_icon.svg',
                        width: 25, height: 25, color: AppColors.defaultColor),
                  ),
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
