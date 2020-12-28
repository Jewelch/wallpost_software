import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/task/entities/task_employee.dart';
import 'package:wallpost/task/entities/task_list_item.dart';
import 'package:wallpost/task/ui/views/task_details/task_comment_tile.dart';

class TaskDetailsScreen extends StatefulWidget {
  @override
  _TaskDetailsScreen createState() => _TaskDetailsScreen();
}

class _TaskDetailsScreen extends State<TaskDetailsScreen> with SingleTickerProviderStateMixin {
  TabController _tabController;
  TaskListItem _taskListItem;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    _taskListItem = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: 'Task Details',
        leading: RoundedBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: SizedBox(
                      width: 50,
                      height: 80,
                      child: Column(children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            border: Border.all(color: AppColors.defaultColor, width: 0),
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                                image: AssetImage('assets/icons/user_image_placeholder.png'), fit: BoxFit.fill),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Text('33%', style: TextStyles.labelTextStyle),
                        ),
                      ]),
                    ),
                  ),
                  Expanded(
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Container(
                        padding: EdgeInsets.only(top: 11.0, left: 10.0, right: 10.0),
                        child: Text(
                          _taskListItem.name,
                          style: TextStyles.titleTextStyle.copyWith(color: AppColors.defaultColor),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          softWrap: false,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text('Assigned to :', style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(_getAssigneesString(_taskListItem.assignees),
                                    style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.labelColor)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text('Status :', style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(_taskListItem.status,
                                    style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text('Created By :', style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(_taskListItem.name,
                                    style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.labelColor)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text('Created On :', style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(_convertToDateFormat(_taskListItem.startDate),
                                    style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.labelColor)),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3.0, left: 10.0, right: 10.0),
                        child: Container(
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Text('Code :', style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Text(_taskListItem.hashCode.toString(),
                                    style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.labelColor)),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
              Divider(
                height: 4,
              ),
              _tabBarWidget(),
              // ),
              _tabBarViewWidget(),
            ],
          ),
        ),
      ),
    );
  }

  String _getAssigneesString(List<TaskEmployee> assignees) {
    String allAssignees;
    allAssignees = assignees.first.fullName;
    if (assignees.length > 1) {
      for (var assignee in assignees) {
        allAssignees = allAssignees + ',' + assignee.fullName;
      }
      return allAssignees;
    } else {
      return allAssignees;
    }
  }

  String _convertToDateFormat(DateTime date) {
    var selectedCompany = SelectedCompanyProvider().getSelectedCompanyForCurrentUser();
    final DateFormat formatter = DateFormat(selectedCompany.dateFormat);
    final String formatted = formatter.format(date);
    return formatted;
  }

  SizedBox _tabBarWidget() {
    return SizedBox(
      height: 50,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        indicatorColor: AppColors.defaultColor,
        indicatorWeight: 3,
        tabs: [
          TabWidget(
            tabName: 'Details',
          ),
          TabWidget(
            tabName: 'Comments',
          ),
          TabWidget(
            tabName: 'Attachments',
          ),
        ],
      ),
    );
  }

  Container _tabBarViewWidget() {
    return Container(
      child: Expanded(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[_createDetailsWidget(), _createCommentsWidget(), _createCommentsWidget()],
        ),
      ),
    );
  }

  Widget _getCommentsCard(int index) {
    return TaskCommentTile(
      onPressed: () => {},
    );
  }

  Widget _createCommentsWidget() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 19,
            itemBuilder: (context, index) {
              return _getCommentsCard(index);
            },
          ),
        ),
        SizedBox(
          height: 120.0,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Container(
                  child: RaisedButton.icon(
                    onPressed: () {
                      print('Button Clicked.');
                    },
                    label: Text(
                      'Add comment',
                      style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor),
                    ),
                    icon: Icon(
                      Icons.add,
                      color: AppColors.defaultColor,
                    ),
                    textColor: Colors.white,
                    color: Colors.white,
                    elevation: 0.0,
                  ),
                ),
                Container(
                  child: RaisedButton.icon(
                    onPressed: () {
                      print('Button Clicked.');
                    },
                    label: Text(
                      'Send',
                      style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor),
                    ),
                    icon: ImageIcon(
                      AssetImage('assets/icons/send_icon.svg'),
                      size: 30,
                      color: AppColors.defaultColor,
                    ),
                    textColor: Colors.white,
                    color: Colors.white,
                    elevation: 0.0,
                  ),
                ),
              ]),
            ),
            SizedBox(
              height: 53.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: TextFormField(
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    helperMaxLines: 5,
                    hintText: 'Enter Comment',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(
                        color: Colors.red,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ],
    );
  }

  Widget _createDetailsWidget() {
    return Column(
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            detailsRowWidget('Start :', _convertToDateFormat(_taskListItem.startDate)),
            detailsRowWidget('End :', _convertToDateFormat(_taskListItem.endDate)),
            detailsRowWidget('Category :', 'Business Development'),
            detailsRowWidget('Task Duration :', '1'),
            detailsRowWidget('Duration In :', 'Working Days'),
            detailsRowWidget('Task Owner :', 'Muhammad Nadeem'),
            detailsRowWidget('Description :', 'Lorem ipsum'),
          ]),
        ),
      ],
    );
  }

  Widget detailsRowWidget(String _rowTitle, String _rowValue) {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0, left: 10.0, right: 10.0),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(child: Text(_rowTitle, style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black))),
            Expanded(
              flex: 2,
              child: Text(_rowValue, style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.labelColor)),
            ),
          ],
        ),
      ),
    );
  }
}

class TabWidget extends StatelessWidget {
  const TabWidget({
    Key key,
    @required String tabName,
  })  : _tabName = tabName,
        super(key: key);
  final String _tabName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Tab(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(text: _tabName, style: TextStyles.labelTextStyle.copyWith(color: Colors.black)),
            ],
          ),
        ),
      ),
    );
  }
}
