// @dart=2.9

import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_back_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filter_chips.dart';
import 'package:wallpost/_common_widgets/filter_views/selected_filters_view.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/task/entities/task_employee.dart';
import 'package:wallpost/task/ui/views/new_task/task_assignee_list_screen.dart';

class CreateTaskScreen extends StatefulWidget {
  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  List<TaskEmployee> taskAssigneesList = [];
  List<TaskEmployee> taskOwnersList = [];
  DateTime _selectedTaskStartDate;
  DateTime _selectedTaskEndDate;

  var _selectedAssigneeViewController = SelectedFiltersViewController();
  var _selectedOwnerViewController = SelectedFiltersViewController();
  List<String> stringTaskAssigneesList = [];
  List<String> stringTaskOwnersList = [];
  List<String> selectedFileUrls = [];

  var _employeesFilterController = MultiSelectFilterChipsController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: new ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                    height: 40,
                    child:
                        Text('Create Task', style: TextStyles.titleTextStyle)),
              ),
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildTaskNameSection()),
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildTaskDescriptionSection()),
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildAssigneesSection()),
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildTaskOwnerSection()),
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildStartEndDateSection()),
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: _buildUploadFileSection()),
              SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return WPAppBar(
      title: SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name,
      leading: CircularBackButton(onPressed: () => Navigator.pop(context)),
      trailing: CircularIconButton(
        iconName: 'assets/icons/check_mark_icon.svg',
        onPressed: () => Navigator.pop(context),
      ),
    );
  }

  Column _buildTaskNameSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Name',
            style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
        Container(
          margin: EdgeInsets.only(top: 2, bottom: 2),
          height: 50.0,
          child: TextField(
            style: TextStyles.subTitleTextStyle,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "Name",
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Column _buildTaskDescriptionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Description',
            style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
        Container(
          margin: EdgeInsets.only(top: 2, bottom: 2),
          height: 50.0,
          child: TextField(
            style: TextStyles.subTitleTextStyle,
            maxLines: 2,
            decoration: InputDecoration(
              hintText: "Task Description",
              fillColor: Colors.white,
              filled: true,
              border: InputBorder.none,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAssigneesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('Assign To',
                  style: TextStyles.subTitleTextStyle
                      .copyWith(color: Colors.black)),
            ),
            IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/search_icon.svg',
                  color: AppColors.defaultColor,
                  width: 22,
                  height: 22,
                ),
                onPressed: () {
                  goToTaskAssigneeFilter();
                })
          ],
        ),
        stringTaskAssigneesList.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: SizedBox(
                  height: 40,
                  child: SelectedFiltersView(
                    controller: _selectedAssigneeViewController,
                    onItemPressed: (index) {
                      var selectedItem = stringTaskAssigneesList[index];
                      _deselectAssignee(selectedItem);
                    },
                  ),
                ),
              ),
      ],
    );
  }

  void goToAssigneesFilter() async {
    final selectedEmployees =
        await Navigator.pushNamed(context, RouteNames.taskEmployeeListScreen);
    setState(() {
      taskAssigneesList = selectedEmployees;
    });
  }

  Widget _buildTaskOwnerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
              child: Text('Task Owner',
                  style: TextStyles.subTitleTextStyle
                      .copyWith(color: Colors.black)),
            ),
            IconButton(
                icon: SvgPicture.asset(
                  'assets/icons/search_icon.svg',
                  color: AppColors.defaultColor,
                  width: 22,
                  height: 22,
                ),
                onPressed: () {
                  goToTaskOwnerFilter();
                })
          ],
        ),
        stringTaskOwnersList.isEmpty
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(top: 4.0, bottom: 4.0),
                child: SizedBox(
                  height: 40,
                  child: SelectedFiltersView(
                    controller: _selectedOwnerViewController,
                    onItemPressed: (index) {
                      var selectedItem = stringTaskOwnersList[index];
                      _deselectOwner(selectedItem);
                    },
                  ),
                ),
              ),
      ],
    );
  }

  void goToTaskAssigneeFilter() async {
    var didSelectTaskAssignee = await ScreenPresenter.present(
        TaskAssigneeListScreen(taskAssigneesList), context) as bool;
    if (didSelectTaskAssignee != null && didSelectTaskAssignee == true) {
      setState(() {
        stringTaskAssigneesList =
            taskAssigneesList.map((e) => e.fullName).toList();
        _selectedAssigneeViewController
            .replaceAllItems(stringTaskAssigneesList);
      });
    }
  }

  void _deselectAssignee(String title) {
    var indexOfItemToRemove = stringTaskAssigneesList.indexOf(title);
    stringTaskAssigneesList.removeAt(indexOfItemToRemove);
    taskAssigneesList.removeAt(indexOfItemToRemove);
    _selectedAssigneeViewController.removeItemAtIndex(indexOfItemToRemove);
  }

  void goToTaskOwnerFilter() async {
    var didSelectTaskOwner = await ScreenPresenter.present(
        TaskAssigneeListScreen(taskOwnersList), context) as bool;
    if (didSelectTaskOwner != null && didSelectTaskOwner == true) {
      setState(() {
        stringTaskOwnersList = taskOwnersList.map((e) => e.fullName).toList();
        _selectedOwnerViewController.replaceAllItems(stringTaskOwnersList);
      });
    }
  }

  void _deselectOwner(String title) {
    var indexOfItemToRemove = stringTaskOwnersList.indexOf(title);
    stringTaskOwnersList.removeAt(indexOfItemToRemove);
    taskOwnersList.removeAt(indexOfItemToRemove);
    _selectedOwnerViewController.removeItemAtIndex(indexOfItemToRemove);
  }

  Widget _buildStartEndDateSection() {
    return Container(
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Start Date ',
              style:
                  TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
          InkWell(
            onTap: () {
              _selectTaskStartDate(context);
            },
            child: Text(
                _selectedTaskStartDate == null
                    ? 'DD.MM.YYYY'
                    : formatDate(
                        _selectedTaskStartDate, [dd, '.', mm, '.', yyyy]),
                style: TextStyles.subTitleTextStyle),
          ),
          SvgPicture.asset(
            'assets/icons/calendar_icon.svg',
            color: AppColors.labelColor,
            width: 15,
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12.0),
            child: Text('End Date ',
                style:
                    TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
          ),
          InkWell(
            onTap: () {
              _selectTaskEndDate(context);
            },
            child: Text(
                _selectedTaskEndDate == null
                    ? 'DD.MM.YYYY'
                    : formatDate(
                        _selectedTaskEndDate, [dd, '.', mm, '.', yyyy]),
                style: TextStyles.subTitleTextStyle),
          ),
          SvgPicture.asset(
            'assets/icons/calendar_icon.svg',
            color: AppColors.labelColor,
            width: 15,
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _buildUploadFileSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            Text('Upload File',
                style:
                    TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
            Text(
                selectedFileUrls.length == 1
                    ? '1 File Added'
                    : selectedFileUrls.length.toString() + ' Files Added',
                style: TextStyles.subTitleTextStyle),
          ],
        ),
        IconButton(
            icon: SvgPicture.asset(
              'assets/icons/attachment_icon.svg',
              color: AppColors.labelColor,
              width: 22,
              height: 22,
            ),
            onPressed: _openFileExplorer)
      ],
    );
  }

  void _openFileExplorer() async {
    FilePickerResult _filePickerResult;
    setState(() {});
    try {
      _filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.any,
      );
    } on Exception catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (_filePickerResult != null) {
      setState(() {
        selectedFileUrls.add(_filePickerResult.files.single.path);
      });
    }
  }

  Future<void> _selectTaskStartDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedTaskStartDate == null
            ? DateTime(2020)
            : _selectedTaskStartDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedTaskStartDate)
      setState(() {
        _selectedTaskStartDate = picked;
      });
  }

  Future<void> _selectTaskEndDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _selectedTaskEndDate == null
            ? DateTime(2020)
            : _selectedTaskEndDate,
        firstDate: DateTime(1900, 1),
        lastDate: DateTime.now());
    if (picked != null && picked != _selectedTaskEndDate)
      setState(() {
        _selectedTaskEndDate = picked;
      });
  }
}
