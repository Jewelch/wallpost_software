// @dart=2.9

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_back_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/leave/ui/presenters/leave_list_presenter.dart';
import 'package:wallpost/leave/ui/views/leave_list/leave_list_filter_screen.dart';

class LeaveListScreen extends StatefulWidget {
  @override
  _LeaveListScreenState createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> implements LeaveListView {
  LeaveListPresenter _presenter;
  ScrollController _scrollController;

  @override
  void initState() {
    _scrollController = ScrollController();
    _presenter = LeaveListPresenter(this);
    _presenter.loadNextListOfLeave();
    _setupScrollDownToLoadMoreItems();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _presenter.loadNextListOfLeave();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WPAppBar(
        title: SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name,
        leading: CircularBackButton(onPressed: () => Navigator.pop(context)),
        trailing: CircularIconButton(
          iconName: 'assets/icons/filters_icon.svg',
          iconSize: 15,
          onPressed: () => goToLeaveFilter(),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 8),
                child: Text('Leave Requests', style: TextStyles.titleTextStyle),
              ),
              SizedBox(height: 8),
              Divider(height: 1),
              Expanded(child: _buildLeaveListWidget())
            ],
          ),
        ),
      ),
    );
  }

  void goToLeaveFilter() async {
    var filters = LeaveListFilterScreen(_presenter.getFilters().clone());
    var selectedFilters = await ScreenPresenter.present(filters, context);
    if (selectedFilters != null) _presenter.updateFilters(selectedFilters);
  }

  Widget _buildLeaveListWidget() {
    return Container(
      child: RefreshIndicator(
        onRefresh: _refreshLeaveList,
        child: ListView.separated(
          controller: _scrollController,
          itemCount: _presenter.getNumberOfItems(),
          separatorBuilder: (context, i) => const Divider(),
          itemBuilder: (BuildContext context, index) {
            return _presenter.getLeaveListViewAtIndex(index);
          },
        ),
      ),
    );
  }

  Future<void> _refreshLeaveList() async {
    setState(() {
      _presenter.reset();
      _presenter.loadNextListOfLeave();
    });
  }

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }

  @override
  void onLeaveSelected(int index) {
    Navigator.pushNamed(context, RouteNames.leaveListdetails, arguments: _presenter.getLeaveListForIndex(index));
  }
}
