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

class _LeaveListScreenState extends State<LeaveListScreen>
    implements LeaveListView {
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
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _presenter.loadNextListOfLeave();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WPAppBar(
        title:
            SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name,
        leading: CircularBackButton(onPressed: () => Navigator.pop(context)),
        trailing: CircularIconButton(
          iconName: 'assets/icons/filters_icon.svg',
          iconSize: 15,
          onPressed: () => goToLeaveFilter(),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Leave Requests', style: TextStyles.titleTextStyle),
              SizedBox(height: 4),
              Divider(),
              Expanded(child: _filterListWidget())
            ],
          ),
        ),
      ),
    );
  }

  Widget _filterListWidget() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: RefreshIndicator(
        onRefresh: _getRefreshList,
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

  void goToLeaveFilter() async {
    var selectedFilters = await ScreenPresenter.present(
        LeaveListFilterScreen(_presenter.getFilters().clone()), context);
    if (selectedFilters != null) _presenter.updateFilters(selectedFilters);
  }

  Future<void> _getRefreshList() async {
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
    Navigator.pushNamed(context, RouteNames.leaveListdetails,
        arguments: _presenter.getLeaveListForIndex(index));
  }
}
