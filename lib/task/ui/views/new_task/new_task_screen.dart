import 'dart:io';

import 'package:date_format/date_format.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_back_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filter_chips.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/task/entities/task_employee.dart';

class CreateTaskScreen extends StatefulWidget {
  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  List<TaskEmployee> taskAssigneesList = List<TaskEmployee>();
  List<TaskEmployee> taskOwnersList = List<TaskEmployee>();
  DateTime _selectedTaskStartDate;
  DateTime _selectedTaskEndDate;

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
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SizedBox(
                    height: 40,
                    child:
                        Text('Create Task', style: TextStyles.titleTextStyle)),
              ),
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildTaskNameSection()),
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildTaskDescriptionSection()),
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildAssigneesSection()),
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildTaskOwnerSection()),
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildStartEndDateSection()),
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
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
              hintText:
                  "Web - Tax free shopping - ( Logistic Officer - Terminal to Issue - Active tab )",
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

  Column _buildAssigneesSection() {
    var taskAssigneesTitles = taskAssigneesList.map((e) => e.fullName).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Assign to',
            style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
        SizedBox(height: 8),
        MultiSelectFilterChips(
          titles: taskAssigneesTitles,
          selectedIndices: [],
          allowMultipleSelection: true,
          controller: _employeesFilterController,
          showTrailingButton: false,
          onTrailingButtonPressed: () {
            goToAssigneesFilter();
          },
        ),
        SizedBox(height: 12),
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
    var taskAssigneesTitles = taskAssigneesList.map((e) => e.fullName).toList();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 12),
            Text('Task Owner',
                style:
                    TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
            SizedBox(height: 8),
            MultiSelectFilterChips(
              titles: taskAssigneesTitles,
              selectedIndices: [],
              allowMultipleSelection: true,
              controller: _employeesFilterController,
              showTrailingButton: false,
            ),
            SizedBox(height: 12),
          ],
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
    );
  }

  void goToTaskOwnerFilter() async {
    final selectedEmployees =
        await Navigator.pushNamed(context, RouteNames.taskEmployeeListScreen);
    setState(() {
      taskOwnersList = selectedEmployees;
    });
  }

  Widget _buildStartEndDateSection() {
    return Container(
      height: 50.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                  _selectedTaskEndDate == null
                      ? 'DD.MM.YYYY'
                      : formatDate(
                          _selectedTaskStartDate, [dd, '.', mm, '.', yyyy]),
                  style: TextStyles.subTitleTextStyle),
            ),
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
            Text('4 Files Added', style: TextStyles.subTitleTextStyle),
          ],
        ),
        IconButton(
            icon: SvgPicture.asset(
              'assets/icons/close_icon.svg',
              color: AppColors.defaultColor,
              width: 22,
              height: 22,
            ),
            onPressed: _openFileExplorer)
      ],
    );
  }

  void _openFileExplorer() async {
    File _pickedFile;
    FilePickerResult _filePickerResult;
    setState(() {
      //_isLoading = true;
    });
    try {
      _filePickerResult = await FilePicker.platform.pickFiles(
        type: FileType.any,
        // allowedExtensions: (_extension?.isNotEmpty ?? false)
        //     ? _extension?.replaceAll(' ', '')?.split(',')
        //     : null);
      );
    } on Exception catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (_filePickerResult != null) {
      setState(() {
        _pickedFile = File(_filePickerResult.files.single.path);
      });
    }
    if (!mounted) return;
    {
      // Flushbar(
      //   showProgressIndicator: true,
      //   progressIndicatorBackgroundColor: Colors.blueGrey,
      //   title: 'Status:',
      //   message: 'File loaded: $_pickedFile',
      //   duration: Duration(seconds: 3),
      //   backgroundColor: Colors.green,
      // )..show(context);
    }
    setState(() {
      //_isLoading = false;
    });
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
