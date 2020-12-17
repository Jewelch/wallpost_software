import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/leave/ui/presenters/leave_list_presenter.dart';

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
        leading: RoundedIconButton(
          iconName: 'assets/icons/back.svg',
          iconSize: 15,
          onPressed: () => Navigator.pop(context),
        ),
        trailing: RoundedIconButton(
          iconName: 'assets/icons/filters_icon.svg',
          iconSize: 15,
          onPressed: () =>
              Navigator.pushNamed(context, RouteNames.leaveListFilter),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Leave Requests',
                  style: TextStyle(color: Colors.black, fontSize: 16)),
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
            return _presenter.getViewAtIndex(index);
          },
        ),
      ),
    );
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
}
