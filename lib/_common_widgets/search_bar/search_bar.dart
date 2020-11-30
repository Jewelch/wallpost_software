import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_shared/constants/app_images.dart';

class SearchBar extends StatelessWidget {
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String> onSearchTextChanged;

  SearchBar({
    this.hint,
    this.controller,
    this.onSearchTextChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      margin: EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Color.fromRGBO(235, 235, 235, 1.0),
      ),
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(width: 12),
          SvgPicture.asset(
            AppImages.searchIcon,
            width: 16,
            height: 16,
          ),
          SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              maxLines: 1,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: hint,
                border: InputBorder.none,
                suffixIcon: controller.text.isEmpty ? null : IconButton(
                  onPressed: () {
                    if (controller.text.isEmpty) return;
                    controller.clear();
                    onSearchTextChanged('');
                  },
                  icon: Icon(Icons.clear, size: 18),
                  color: Colors.grey,
                ),
              ),
              style: TextStyle(fontSize: 16),
              onChanged: onSearchTextChanged,
            ),
          ),
        ],
      ),
    );
  }
}
