import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/_list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/_list_view/loader_list_tile.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/task/entities/department.dart';
import 'package:wallpost/task/services/departments_list_provider.dart';
import 'package:wallpost/task/ui/views/departments_list/departments_list_tile.dart';

abstract class DepartmentsListView {
  void reloadData();

  void onDepartmentAdded();

  void onDepartmentRemoved();
}

class DepartmentsListPresenter {
  final DepartmentsListView _view;
  final DepartmentsListProvider _provider;
  List<Department> _departments = [];
  List<Department> _selectedDepartments = [];
  String _errorMessage;
  String _searchText;

  DepartmentsListPresenter(this._view) : _provider = DepartmentsListProvider();

  Future<void> loadNextListOfDepartments(String searchText) async {
    if (_provider.isLoading || _provider.didReachListEnd) return null;

    _searchText = searchText;
    _resetErrors();

    try {
      var departmentsList = await _provider.getNext(searchText: _searchText);
      _departments.addAll(departmentsList);
      _view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      _view.reloadData();
    }
  }

  //MARK: Functions to get departments list count and views

  int getNumberOfDepartments() {
    if (_hasErrors()) return _departments.length + 1;

    if (_departments.isEmpty) return 1;

    if (_provider.didReachListEnd) {
      return _departments.length;
    } else {
      return _departments.length + 1;
    }
  }

  Widget getDepartmentViewForIndex(int index) {
    if (_shouldShowErrorAtIndex(index)) return _buildErrorView(_errorMessage);

    if (_departments.isEmpty) return _buildViewWhenThereAreNoResults();

    if (index < _departments.length) {
      return _buildDepartmentViewForIndex(index);
    } else {
      return LoaderListTile();
    }
  }

  bool _shouldShowErrorAtIndex(int index) {
    return _hasErrors() && index == _departments.length;
  }

  Widget _buildErrorView(String errorMessage) {
    return ErrorListTile(
      '$errorMessage Tap here to reload.',
      onTap: () {
        loadNextListOfDepartments(_searchText);
        _view.reloadData();
      },
    );
  }

  Widget _buildViewWhenThereAreNoResults() {
    if (_provider.didReachListEnd) {
      return ErrorListTile(
        'There are no departments to show. Tap here to reload.',
        onTap: () {
          _provider.reset();
          loadNextListOfDepartments(_searchText);
          _view.reloadData();
        },
      );
    } else {
      return LoaderListTile();
    }
  }

  Widget _buildDepartmentViewForIndex(int index) {
    return DepartmentListTile(
      isDepartmentSelected(_departments[index]),
      _departments[index],
      onDepartmentListTileTap: () {
        if (isDepartmentSelected(_departments[index])) {
          _selectedDepartments.removeWhere((selectedDepartment) => selectedDepartment.name == _departments[index].name);
          _view.onDepartmentRemoved();
        } else {
          _selectedDepartments.add(_departments[index]);
          _view.onDepartmentAdded();
        }
      },
    );
  }

  //MARK: Functions to get selected department count and views

  int getNumberOfSelectedDepartments() {
    return _selectedDepartments.length;
  }

  Widget getSelectedDepartmentViewForIndex(int index) {
    return RaisedButton(
      textColor: AppColors.filtersTextGreyColor,
      color: AppColors.filtersBackgroundGreyColor,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
        side: BorderSide(color: AppColors.filtersBackgroundGreyColor, width: .5),
      ),
      child: Row(
        children: [
          Text(
            _selectedDepartments[index].name,
            style: TextStyle(color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: SvgPicture.asset('assets/icons/delete_icon.svg', width: 15, height: 15),
          ),
        ],
      ),
      onPressed: () {
        _selectedDepartments.removeAt(index);
        _view.onDepartmentRemoved();
      },
    );
  }

  //MARK: Util functions

  void reset() {
    _departments.clear();
    _provider.reset();
    _resetErrors();
    _view.reloadData();
  }

  void resetFilter() {
    _selectedDepartments.clear();
    _view.reloadData();
  }

  void _resetErrors() {
    _errorMessage = null;
  }

  bool _hasErrors() {
    return _errorMessage != null;
  }

  bool isDepartmentSelected(Department department) {
    for (Department selectedDepartment in _selectedDepartments) {
      if (selectedDepartment.name == department.name) return true;
    }

    return false;
  }
}
