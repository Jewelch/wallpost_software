import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/screen_presenter/center_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../../../../../../_common_widgets/form_widgets/form_text_field.dart';

class SelectExpireOrNot extends StatefulWidget {
  final void Function(bool, int day) onSelectExpiration;
  final bool? initialValue;

  SelectExpireOrNot._(this.onSelectExpiration, this.initialValue, {Key? key}) : super(key: key);

  static Future<dynamic> show(BuildContext context,
      {required void Function(bool, int days) onSelectExpiration, required bool? initialValue}) {
    var centerSheetController = CenterSheetController();
    return CenterSheetPresenter.present(
      context: context,
      content: SelectExpireOrNot._(onSelectExpiration, initialValue),
      controller: centerSheetController,
    );
  }

  @override
  State<SelectExpireOrNot> createState() => _SelectExpireOrNotState();
}

class _SelectExpireOrNotState extends State<SelectExpireOrNot> {
  late bool isExpired;
  final TextEditingController _daysC = TextEditingController();

  @override
  void initState() {
    super.initState();
    isExpired = widget.initialValue ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(bottom: 25.0, right: 18, left: 18, top: 18),
      decoration: BoxDecoration(
        color: AppColors.screenBackgroundColor,
        borderRadius: BorderRadius.all(
          Radius.circular(24),
        ),
        border: Border.all(color: Colors.transparent),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: Navigator.of(context).pop,
                  child: Text(
                    "Cancel",
                    style: TextStyles.screenTitleTextStyle.copyWith(
                      color: AppColors.defaultColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: null,
                  child: Text(
                    "By Date",
                    style: TextStyles.screenTitleTextStyle.copyWith(
                      color: AppColors.textColorBlack,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    var daysInNumber = int.tryParse(_daysC.text) ?? 7;
                    widget.onSelectExpiration(isExpired, daysInNumber);
                  },
                  child: Text(
                    "Apply",
                    style: TextStyles.screenTitleTextStyle.copyWith(
                      color: AppColors.defaultColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpired = true;
                });
              },
              child: _Option(
                title: "Only Expired",
                isSelected: isExpired,
              ),
            ),
            SizedBox(height: 24),
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpired = false;
                });
              },
              child: _Option(
                title: "Expire In",
                isSelected: !isExpired,
              ),
            ),
            SizedBox(height: 24),
            if (!isExpired)
              FormTextField(
                controller: _daysC,
                hint: "Days",
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                onChanged: (s) {
                  var text = s;
                  var value = "";
                  for (var i = 0; i < text.length; i++) {
                    if (num.tryParse(text[i]) == null) continue;
                    value += text[i];
                  }
                  _daysC.text = value;
                },
              ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _Option extends StatelessWidget {
  final String title;
  final bool isSelected;
  const _Option({required this.title, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 8),
      padding: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
      decoration: BoxDecoration(
          border: Border.all(color: AppColors.textFieldBackgroundColor), borderRadius: BorderRadius.circular(6)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyles.subTitleTextStyleBold.copyWith(
              color: _getAppropriateColor(),
            ),
          ),
          Icon(
            Icons.radio_button_checked_outlined,
            color: _getAppropriateColor(),
          ),
        ],
      ),
    );
  }

  Color _getAppropriateColor() {
    if (isSelected) {
      return AppColors.defaultColor;
    } else {
      return AppColors.textColorDarkGray;
    }
  }
}
