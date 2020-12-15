import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';
import 'package:wallpost/task/ui/presenters/task_list_presenter.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreen createState() => _TaskScreen();
}

//remove me
class _TaskScreen extends State<TaskScreen>
    with SingleTickerProviderStateMixin, TaskListView {
  var _searchBarController = TextEditingController();
  TabController _tabController;
  TaskListPresenter _presenter;
  int _selectedTab = 0;
  ScrollController _tasksListScrollController = ScrollController();
  TasksListFilters _filters = TasksListFilters();
  bool _listFilterVisible = false;

  @override
  void initState() {
    _presenter = TaskListPresenter(this);
    _presenter.loadTaskCount(_selectedTab, _filters);
    _setupScrollDownToLoadMoreItems();
    super.initState();
    _tabController = new TabController(length: 6, vsync: this);
    _tabController.addListener(_setActiveTabIndex);
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
          iconSize: 12,
          onPressed: () => Navigator.pop(context),
        ),
        trailing: RoundedIconButton(
          iconName: 'assets/icons/filters_icon.svg',
          onPressed: () => goToTaskFilter(),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerFilterTextFieldWidget(),
              Divider(
                height: 4,
              ),
              _buildTabBarWidget(),
              // ),
              _filterListWidget(),
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
                  child: SearchBar(
                    hint: 'Enter a search term',
                    controller: _searchBarController,
                    onSearchTextChanged: (searchText) {
                      _presenter.reset();
                      _filters.searchText = searchText;
                      _presenter.loadNextListOfTasks(_selectedTab, _filters);
                    },
                  ),
                )
              : Text('Task Requests',
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

  SizedBox _buildTabBarWidget() {
    return SizedBox(
      height: 50,
      child: TabBar(
        isScrollable: true,
        controller: _tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        indicatorColor: AppColors.defaultColor,
        indicatorWeight: 3,
        tabs: [
          TabWidget(
            tabCount: _presenter.overdueCount,
            tabName: 'Overdue',
          ),
          TabWidget(
            tabCount: _presenter.dueTodayCount,
            tabName: 'Due Today',
          ),
          TabWidget(
            tabCount: _presenter.dueInAWeekCount,
            tabName: 'Due in a week',
          ),
          TabWidget(
            tabCount: _presenter.upcomingDueCount,
            tabName: 'Upcoming Due',
          ),
          TabWidget(
            tabCount: _presenter.completedCount,
            tabName: 'Completed',
          ),
          TabWidget(
            tabCount: _presenter.allCount,
            tabName: 'All',
          ),
        ],
      ),
    );
  }

  Container _filterListWidget() {
    return Container(
      child: Expanded(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            _createListWidget(),
            _createListWidget(),
            _createListWidget(),
            _createListWidget(),
            _createListWidget(),
            _createListWidget(),
          ],
        ),
      ),
    );
  }

  Widget _createListWidget() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _tasksListScrollController,
            itemCount: _presenter.getNumberOfTask(),
            itemBuilder: (context, index) {
              return _presenter.getTaskViewForIndex(index);
            },
          ),
        ),
      ],
    );
  }

  void goToTaskFilter() async {
    _filters.reset();
    await Navigator.pushNamed(context, RouteNames.taskFilter,
        arguments: _filters);
    _selectedTab = _tabController.index;
    _presenter.reset();
    _presenter.loadNextListOfTasks(_selectedTab, _filters);
  }

  void _setupScrollDownToLoadMoreItems() {
    _tasksListScrollController.addListener(() {
      if (_tasksListScrollController.position.pixels ==
          _tasksListScrollController.position.maxScrollExtent) {
        _presenter.loadNextListOfTasks(_selectedTab, _filters);
      }
    });
  }

  void _setActiveTabIndex() {
    _presenter.reset();
    _presenter.loadNextListOfTasks(_tabController.index, _filters);
  }

  @override
  void onTaskSelected() {
    Navigator.pushNamed(context, RouteNames.taskDetails);
  }

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }
}

class TabWidget extends StatelessWidget {
  const TabWidget({
    Key key,
    @required String tabName,
    @required num tabCount,
  })  : _totalCount = tabCount,
        _tabName = tabName,
        super(key: key);

  final num _totalCount;
  final String _tabName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Tab(
        child: Column(
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: '$_totalCount',
                      style: TextStyle(
                          color: AppColors.defaultColor, fontSize: 22))
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: _tabName,
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
