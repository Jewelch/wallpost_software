import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class LeaveListFilterScreen extends StatefulWidget {
  @override
  _LeaveListFilterScreenState createState() => _LeaveListFilterScreenState();
}

class _LeaveListFilterScreenState extends State<LeaveListFilterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
                    onPressed: () => {Navigator.pop(context)},
                  ),
                ),
                Expanded(
                  child: Container(
                    height: 32,
                    width: double.infinity,
                    child: Row(
                      children: [
                        SizedBox(width: 8),
                        Expanded(
                          child: Container(
                            child: Center(
                              child: Text('Filters',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  child: IconButton(
                    icon: SvgPicture.asset('assets/icons/reset_icon.svg',
                        width: 42, height: 23),
                    onPressed: () => {},
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
                    onPressed: () => {},
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
      ),
      body: Column(
        children: [_buildCategoryList()],
      ),
    );
  }

  Widget _buildCategoryList() {
    return Column(
      children: [
        SizedBox(height: 12),
        Text('Department', style: TextStyle(color: Colors.black, fontSize: 14)),
        SizedBox(height: 8),
      ],
    );
  }
}
