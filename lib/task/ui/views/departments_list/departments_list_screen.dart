import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/task/ui/presenters/departments_list_presenter.dart';

class DepartmentsListScreen extends StatefulWidget {
  @override
  _DepartmentsListScreenState createState() => _DepartmentsListScreenState();
}

class _DepartmentsListScreenState extends State<DepartmentsListScreen> implements DepartmentsListView {
  var _searchBarController = TextEditingController();
  ScrollController _departmentsListScrollController = ScrollController();
  ScrollController _selectedDepartmentsListScrollController = ScrollController();
  DepartmentsListPresenter _presenter;

  @override
  void initState() {
    _presenter = DepartmentsListPresenter(this);
    _presenter.loadNextListOfDepartments(_searchBarController.text);
    _setupScrollDownToLoadMoreItems();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _departmentsListScrollController.addListener(() {
      if (_departmentsListScrollController.position.pixels ==
          _departmentsListScrollController.position.maxScrollExtent) {
        _presenter.loadNextListOfDepartments(_searchBarController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: 'Select Department',
        leadingSpace: 0,
        trailingSpace: 12,
        leading: RoundedIconButton(
          iconName: 'assets/icons/back.svg',
          iconSize: 20,
          iconColor: AppColors.defaultColor,
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        trailing: RoundedIconButton(
          iconName: 'assets/icons/check.svg',
          iconSize: 20,
          iconColor: AppColors.defaultColor,
          color: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          SearchBar(
            hint: 'Search by department name',
            controller: _searchBarController,
            onSearchTextChanged: (searchText) {
              _presenter.reset();
              _presenter.loadNextListOfDepartments(searchText);
            },
          ),
          SizedBox(height: 8),
          SizedBox(
            height: _presenter.getNumberOfSelectedDepartments() == 0 ? 0 : 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: _selectedDepartmentsListScrollController,
              children: List.generate(
                _presenter.getNumberOfSelectedDepartments(),
                (index) {
                  var edgeInsets = EdgeInsets.only(left: 12);
                  if (index == _presenter.getNumberOfSelectedDepartments() - 1)
                    edgeInsets = edgeInsets.copyWith(right: 12);

                  return Padding(
                    padding: edgeInsets,
                    child: _presenter.getSelectedDepartmentViewForIndex(index),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                _presenter.reset();
                _presenter.loadNextListOfDepartments(_searchBarController.text);
                return Future.value(null);
              },
              child: ListView.builder(
                controller: _departmentsListScrollController,
                itemCount: _presenter.getNumberOfDepartments(),
                itemBuilder: (context, index) {
                  return _presenter.getDepartmentViewForIndex(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }

  @override
  void onDepartmentAdded() {
    if (this.mounted) setState(() {});

    Future.delayed(Duration(milliseconds: 200)).then((value) {
      _selectedDepartmentsListScrollController.animateTo(
          _selectedDepartmentsListScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut);
    });
  }

  @override
  void onDepartmentRemoved() {
    if (this.mounted) setState(() {});
  }
}
