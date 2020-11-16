import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class FilterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onBackPressed;
  final VoidCallback onResetFiltersPressed;
  final VoidCallback onDoFilterPressed;

  @override
  final Size preferredSize;

  FilterAppBar({
    this.onBackPressed,
    this.onResetFiltersPressed,
    this.onDoFilterPressed,
  }) : preferredSize = Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleSpacing: 0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          Row(
            children: [
              SizedBox(
                child: IconButton(
                  icon: SvgPicture.asset('assets/icons/delete_icon.svg',
                      width: 42, height: 23),
                  onPressed: () => {onBackPressed(), print('back')},
                ),
              ),
              Expanded(child: _makeCenterTitleView()),
              SizedBox(
                child: IconButton(
                  icon: SvgPicture.asset('assets/icons/reset_icon.svg',
                      width: 42, height: 23),
                  onPressed: () => {onResetFiltersPressed()},
                ),
              ),
              SizedBox(
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/check.svg',
                    width: 42,
                    height: 23,
                    color: AppColors.defaultColor,
                  ),
                  onPressed: () => {onDoFilterPressed()},
                ),
              ),
            ],
          ),
          Divider(
            height: 4,
            color: AppColors.blackColor,
          ),
        ],
      ),
    );
  }

  Widget _makeCenterTitleView() {
    return Container(
      height: 32,
      width: double.infinity,
      child: Row(
        children: [
          SizedBox(width: 8),
          Expanded(
            child: Container(
              child: Center(
                child: Text('Filter',
                    style: TextStyle(color: Colors.black, fontSize: 18)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
