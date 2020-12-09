import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/leave/ui/leave_list_tile.dart';

class LeaveListScreen extends StatefulWidget {
  @override
  _LeaveListScreenState createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> {
  TextEditingController _listFilterTextFieldController =
      new TextEditingController();
  bool _listFilterVisible = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WPAppBar(
        title:
            SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name,
        leading: RoundedIconButton(
          iconName: 'assets/icons/back.svg',
          iconSize: 12,
          onPressed: () => Navigator.pop(context),
        ),
        trailing: RoundedIconButton(
          iconName: 'assets/icons/filters_icon.svg',
          onPressed: () =>
              {Navigator.pushNamed(context, RouteNames.leaveListFilter)},
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            children: [
              _headerFilterTextFieldWidget(),
              Divider(height: 4),
              _filterListWidget()
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _headerFilterTextFieldWidget() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _listFilterVisible
              ? Expanded(
                  child: TextField(
                    controller: _listFilterTextFieldController,
                    onSubmitted: (text) =>
                        print(_listFilterTextFieldController.text),
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter a search term'),
                  ),
                )
              : Text('Leave Requests',
                  style: TextStyle(color: Colors.black, fontSize: 16)),
          IconButton(
              icon: _listFilterVisible
                  ? SvgPicture.asset('assets/icons/delete_icon.svg',
                      width: 42, height: 23)
                  : SvgPicture.asset('assets/icons/search_icon.svg',
                      width: 42, height: 23),
              onPressed: () {
                setState(() {
                  _listFilterVisible
                      ? _listFilterVisible = false
                      : _listFilterVisible = true;
                });
              }),
        ],
      ),
    );
  }

  Container _filterListWidget() {
    return Container(
      child: Expanded(
        child: ListView.separated(
          itemCount: 3,
          separatorBuilder: (context, i) => const Divider(),
          itemBuilder: (context, i) {
            return LeaveListTile();
          },
        ),
      ),
    );
  }
}
