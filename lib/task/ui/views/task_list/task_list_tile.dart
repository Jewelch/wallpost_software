import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/task/entities/task_employee.dart';
import 'package:wallpost/task/entities/task_list_item.dart';

class TaskListTile extends StatelessWidget {
  final TaskListItem taskListItem;
  final VoidCallback onTaskListTileTap;

  TaskListTile(
    this.taskListItem, {
    this.onTaskListTileTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        child: Container(
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 50,
                    height: 80,
                    child: Column(children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: AppColors.defaultColor, width: 0),
                          borderRadius: BorderRadius.circular(50),
                          image: DecorationImage(
                              image: AssetImage(
                                  'assets/icons/user_image_placeholder.png'),
                              fit: BoxFit.fill),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7.0),
                        child: Text(
                            taskListItem.progressPercentage.toString() + '%',
                            style: TextStyle(fontSize: 12)),
                      ),
                    ]),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: 11.0, left: 10.0, right: 10.0),
                            child: Text(
                              taskListItem.name,
                              style: TextStyles.titleTextStyle
                                  .copyWith(color: AppColors.defaultColor),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 3.0, left: 10.0, right: 10.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text('Assigned to :',
                                      style: TextStyles.subTitleTextStyle
                                          .copyWith(color: Colors.black)),
                                  Text(
                                      _getAssigneesString(
                                          taskListItem.assignees),
                                      style: TextStyles.subTitleTextStyle
                                          .copyWith(
                                              color: AppColors.labelColor)),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 3.0, left: 8.0, right: 10.0),
                            child: Row(
                              children: [
                                Container(
                                  child: Expanded(
                                    child: Row(
                                      children: [
                                        Text('Start : ',
                                            style: TextStyles.subTitleTextStyle
                                                .copyWith(color: Colors.black)),
                                        Text(
                                            _convertToDateFormat(
                                                taskListItem.startDate),
                                            style: TextStyles.subTitleTextStyle
                                                .copyWith(
                                                    color:
                                                        AppColors.labelColor)),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Expanded(
                                    child: Row(
                                      children: [
                                        Text('End :',
                                            style: TextStyles.subTitleTextStyle
                                                .copyWith(color: Colors.black)),
                                        Text(
                                            _convertToDateFormat(
                                                taskListItem.endDate),
                                            style: TextStyles.subTitleTextStyle
                                                .copyWith(
                                                    color:
                                                        AppColors.labelColor)),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, right: 8.0, top: 8.0, bottom: 16.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 70,
                                  height: 16,
                                  child: Center(
                                      child: Text(
                                    taskListItem.status,
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 10),
                                  )),
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      borderRadius: BorderRadius.circular(40),
                                      color: AppColors.defaultColor),
                                ),
                                taskListItem.isEscalated
                                    ? Container(
                                        width: 70,
                                        height: 16,
                                        child: Center(
                                            child: Text(
                                          'Escalated',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 10),
                                        )),
                                        decoration: BoxDecoration(
                                            shape: BoxShape.rectangle,
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            color: Colors.purple),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              Divider(height: 1.0, color: Colors.grey),
            ],
          ),
        ),
        onTap: () {
          if (onTaskListTileTap != null) onTaskListTileTap();
        });
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
    var selectedCompany =
        SelectedCompanyProvider().getSelectedCompanyForCurrentUser();
    final DateFormat formatter = DateFormat(selectedCompany.dateFormat);
    final String formatted = formatter.format(date);
    return formatted;
  }
}
