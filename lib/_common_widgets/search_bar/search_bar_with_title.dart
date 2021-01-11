import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class SearchBarWithTitle extends StatefulWidget {
  final String title;
  final Function(String) onChanged;
  final TextEditingController controller;

  SearchBarWithTitle({this.title, this.onChanged, this.controller});

  @override
  _SearchBarWithTitleState createState() => _SearchBarWithTitleState(controller);
}

class _SearchBarWithTitleState extends State<SearchBarWithTitle> {
  TextEditingController _controller;
  FocusNode _focusNode = FocusNode();

  _SearchBarWithTitleState(TextEditingController controller) {
    if (controller != null) {
      _controller = controller;
    } else {
      _controller = TextEditingController();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 12),
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        autocorrect: false,
        enableSuggestions: false,
        style: TextStyles.titleTextStyle,
        decoration: InputDecoration(
          hintText: widget.title,
          hintStyle: TextStyles.titleTextStyle,
          suffixIcon: _suffixIcon(),
          border: InputBorder.none,
        ),
        onChanged: (text) => widget.onChanged(text),
      ),
    );
  }

  Widget _suffixIcon() {
    if (_focusNode.hasFocus) {
      return IconButton(
        onPressed: () {
          _controller.clear();
          _focusNode.unfocus();
          setState(() {});
        },
        icon: SvgPicture.asset(
          'assets/icons/close_icon.svg',
          color: AppColors.defaultColor,
          width: 22,
          height: 22,
        ),
      );
    } else {
      return IconButton(
        onPressed: () {
          _focusNode.requestFocus();
          setState(() {});
        },
        icon: SvgPicture.asset(
          'assets/icons/search_icon.svg',
          color: AppColors.defaultColor,
          width: 22,
          height: 22,
        ),
      );
    }
  }
}
