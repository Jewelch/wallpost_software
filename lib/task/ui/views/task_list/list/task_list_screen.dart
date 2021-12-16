// @dart=2.9

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_back_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/filter_views/filter_tab_bar.dart';
import 'package:wallpost/_common_widgets/filter_views/selected_filters_view.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar_with_title.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/task/ui/presenters/task_list_presenter.dart';
import 'package:wallpost/task/ui/views/task_list/filters/task_list_filters_screen.dart';

class TaskListScreen extends StatefulWidget {
  @override
  _TaskScreen createState() => _TaskScreen();
}

class _TaskScreen extends State<TaskListScreen> with SingleTickerProviderStateMixin, TaskListView {
  ScrollController _taskListScrollController = ScrollController();
  TabController _tabController;
  TaskListPresenter _presenter;
  var _selectedFiltersViewController = SelectedFiltersViewController();
  List<String> selectedItems = [];

  @override
  void initState() {
    _setupScrollDownToLoadMoreItems();
    _tabController = new TabController(length: 6, vsync: this);
    _presenter = TaskListPresenter(this);
    _presenter.loadTaskCount();
    _presenter.loadNextListOfTasks();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _taskListScrollController.addListener(() {
      if (_taskListScrollController.position.pixels == _taskListScrollController.position.maxScrollExtent) {
        _presenter.loadNextListOfTasks();
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
          onPressed: () => goToTaskFilter(),
        ),
      ),
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SearchBarWithTitle(
                title: 'Tasks',
                onChanged: (searchText) => _presenter.updateSearchText(searchText),
              ),
              Divider(height: 1),
              selectedItems.isEmpty
                  ? Container()
                  : SizedBox(
                      height: 40,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: SelectedFiltersView(
                          controller: _selectedFiltersViewController,
                          onItemPressed: (index) {
                            var selectedItem = selectedItems[index];
                            _deselectItem(selectedItem);
                          },
                        ),
                      ),
                    ),
              FilterTabBar(
                controller: _tabController,
                onTabChanged: (index) => _presenter.updateStatus(index),
                items: [
                  FilterTabBarItem(title: 'Overdue', count: _presenter.getOverdueTaskCount()),
                  FilterTabBarItem(title: 'Due Today', count: _presenter.getCountOfTasksThatAreDueToday()),
                  FilterTabBarItem(title: 'Due In A Week', count: _presenter.getCountOfTasksThatAreDueInAWeek()),
                  FilterTabBarItem(title: 'Upcoming Due', count: _presenter.getUpcomingDueTaskCount()),
                  FilterTabBarItem(title: 'Completed', count: _presenter.getCompletedTaskCount()),
                  FilterTabBarItem(title: 'All', count: _presenter.getCountOfAllTasks()),
                ],
              ),
              Expanded(
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
            ],
          ),
        ),
      ),
    );
  }

  Widget _createListWidget() {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: () {
              _presenter.reset();
              _presenter.loadNextListOfTasks();
              return Future.value(null);
            },
            child: ListView.builder(
              controller: _taskListScrollController,
              itemCount: _presenter.getNumberOfTasks(),
              itemBuilder: (context, index) {
                return _presenter.getTaskViewForIndex(index);
              },
            ),
          ),
        ),
      ],
    );
  }

  void goToTaskFilter() async {
    var selectedFilters =
        await ScreenPresenter.present(TaskListFiltersScreen(_presenter.getFilters().clone()), context);
    if (selectedFilters != null) {
      _presenter.updateFilters(selectedFilters);
      refreshSelectedFilterNames();
    }
  }

  void _deselectItem(String title) {
    var indexOfItemToRemove = selectedItems.indexOf(title);
    selectedItems.removeAt(indexOfItemToRemove);
    _selectedFiltersViewController.removeItemAtIndex(indexOfItemToRemove);

    if ('${_presenter.getFilters().year}' == title) _presenter.getFilters().resetYearFilter();
    _presenter.getFilters().departments.removeWhere((element) => element.name == title);
    _presenter.getFilters().categories.removeWhere((element) => element.name == title);
    _presenter.getFilters().assignees.removeWhere((element) => element.fullName == title);
  }

  refreshSelectedFilterNames() {
    setState(() {
      selectedItems.clear();
      selectedItems.add(_presenter.getFilters().year.toString());
      selectedItems.addAll(_presenter.getFilters().departments.map((e) => e.name).toList());
      selectedItems.addAll(_presenter.getFilters().categories.map((e) => e.name).toList());
      selectedItems.addAll(_presenter.getFilters().assignees.map((e) => e.fullName).toList());
      _selectedFiltersViewController.replaceAllItems(selectedItems);
    });
  }

  //MARK: Task list view functions

  @override
  void onTaskSelected(int index) {
    Navigator.pushNamed(context, RouteNames.taskDetails, arguments: _presenter.getTaskForIndex(index));
  }

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }
}
