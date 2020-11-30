import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_common_widgets/_list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/_list_view/loader_list_tile.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/task/entities/department.dart';
import 'package:wallpost/task/services/departments_list_provider.dart';
import 'package:wallpost/task/ui/views/departments_list/departments_list_tile.dart';

abstract class DepartmentsListView {
  void reloadData();
}

abstract class SelectedDepartmentsListView {
  void reloadData();
}

class DepartmentsListPresenter {
  final DepartmentsListView view;
  final SelectedDepartmentsListView selectedDepartmentsView;
  final DepartmentsListProvider provider;
  List<Department> departments = [];
  bool isSelected = false;
  List<Department> _filterList = [];
  String _errorMessage;
  List<Department> selectedDepartments = [];

  DepartmentsListPresenter(this.view, this.selectedDepartmentsView)
      : provider = DepartmentsListProvider();

  DepartmentsListPresenter.initWith(
      this.view, this.selectedDepartmentsView, this.provider);

  Future<void> loadNextListOfDepartments() async {
    if (provider.isLoading || provider.didReachListEnd) return null;

    _resetErrors();
    try {
      var departmentsList = await provider.getNext();
      departments.addAll(departmentsList);
      _filterList.addAll(departmentsList);
      view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      view.reloadData();
    }
  }

  Future<List<Department>> getListOfDepartments() async {
    if (provider.isLoading || provider.didReachListEnd) return null;

    _resetErrors();
    try {
      var departmentsList = await provider.getNext();
      view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
    }
  }

  int getNumberOfItems() {
    if (_hasErrors()) return departments.length + 1;

    if (departments.isEmpty) return 1;

    if (provider.didReachListEnd) {
      return departments.length;
    } else {
      return departments.length + 1;
    }
  }

  void performFilter(String searchText) {
    _filterList = new List<Department>();
    for (int i = 0; i < departments.length; i++) {
      var item = departments[i];
      if (item.name.toLowerCase().contains(searchText.toLowerCase())) {
        _filterList.add(item);
      }
    }
    if (searchText.isEmpty) {
      _filterList = departments;
    }
    view.reloadData();
  }

  Widget getViewAtIndex(int index) {
    if (_shouldShowErrorAtIndex(index))
      return ErrorListTile('$_errorMessage\nTap here to reload.');

    if (_filterList.isEmpty) return _buildViewWhenThereAreNoResults();

    if (index < _filterList.length) {
      return DepartmentListTile(
        selectedDepartments.contains(_filterList[index]),
        _filterList[index],
        onDepartmentListTileTap: () {
          if (selectedDepartments.contains(_filterList[index])) {
            selectedDepartments.removeAt(index);
            selectedDepartmentsView.reloadData();
          } else {
            selectedDepartments.add(_filterList[index]);
            selectedDepartmentsView.reloadData();
          }
        },
      );
    } else {
      return LoaderListTile();
    }
  }

  Widget getSelectedFilterSection() {
    if (selectedDepartments == null || selectedDepartments.length == 0) {
      return SizedBox(height: 0);
    } else {
      return SizedBox(
        height: 60,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: List.generate(
            selectedDepartments.length,
            (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: RaisedButton(
                  child: Row(
                    children: [
                      Text(selectedDepartments[index].name),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: SvgPicture.asset(
                          'assets/icons/delete_icon.svg',
                          width: 15,
                          height: 15,
                        ),
                      ),
                    ],
                  ),
                  textColor: AppColors.filtersTextGreyColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                    side: BorderSide(
                      color: AppColors.filtersBackgroundGreyColor,
                      width: .5,
                    ),
                  ),
                  color: AppColors.filtersBackgroundGreyColor,
                  onPressed: () {
                    selectedDepartments.removeAt(index);
                    selectedDepartmentsView.reloadData();
                  },
                  elevation: 0,
                ),
              );
            },
          ),
        ),
      );
    }
  }

  bool _shouldShowErrorAtIndex(int index) {
    return _hasErrors() && index == departments.length;
  }

  Widget _buildViewWhenThereAreNoResults() {
    if (provider.didReachListEnd) {
      return ErrorListTile(
          'There are no departments to show. Tap here to reload.');
    } else {
      return LoaderListTile();
    }
  }

  //MARK: Util functions

  void reset() {
    provider.reset();
    _resetErrors();
    departments.clear();
    view.reloadData();
  }

  void resetFilter() {
    selectedDepartments.clear();
    view.reloadData();
  }

  void _resetErrors() {
    _errorMessage = null;
  }

  bool _hasErrors() {
    return _errorMessage != null;
  }
}
