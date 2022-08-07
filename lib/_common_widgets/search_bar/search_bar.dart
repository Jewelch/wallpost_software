import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/constants/app_images.dart';

class SearchBar extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onSearchTextChanged;

  SearchBar({
    required this.hint,
    TextEditingController? textEditingController,
    required this.onSearchTextChanged,
  }) : this.controller = textEditingController ?? TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: AppColors.filtersBackgroundColour,
      ),
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(width: 12),
          SvgPicture.asset(
            AppImages.searchIcon,
            width: 18,
            height: 18,
            color: AppColors.defaultColorDark,
          ),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
              textAlignVertical: TextAlignVertical(y: 1),
              decoration: InputDecoration(
                hintText: hint,
                hintStyle: TextStyles.titleTextStyle.copyWith(color: AppColors.defaultColorDarkContrastColor),
                border: OutlineInputBorder(borderSide: BorderSide.none),
                suffixIcon: controller.text.isEmpty
                    ? null
                    : IconButton(
                        icon: Icon(Icons.clear, size: 18),
                        color: Colors.grey,
                        onPressed: () {
                          if (controller.text.isEmpty) return;
                          controller.clear();
                          onSearchTextChanged('');
                        },
                      ),
              ),
              style: TextStyles.titleTextStyle.copyWith(color: AppColors.defaultColorDark),
              onChanged: onSearchTextChanged,
            ),
          ),
        ],
      ),
    );
  }
}
