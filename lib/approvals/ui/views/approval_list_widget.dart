import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/approvals/entities/attendance_adjustment_approval.dart';
import 'package:wallpost/approvals/entities/expense_request_approval.dart';
import 'package:wallpost/approvals/entities/leave_approval.dart';
import 'package:wallpost/approvals/ui/presenters/approval_list_widget_presenter.dart';
import 'package:wallpost/approvals/ui/view_contracts/approval_list_widget_view.dart';

import '../../../_common_widgets/list_view/loader_list_tile.dart';
import '../../../_common_widgets/text_styles/text_styles.dart';
import '../../../_shared/constants/app_colors.dart';
import '../../../dashboard/constants/dashboard_colors.dart';
import '../../../dashboard/ui/my_portal/views/list_tiles/attendance_adjustment_approval_tile.dart';
import '../../../dashboard/ui/my_portal/views/list_tiles/expense_request_approval_tile.dart';
import '../../../dashboard/ui/my_portal/views/list_tiles/leave_approval_tile.dart';
import '../../entities/approval.dart';

class ApprovalsListWidget extends StatefulWidget {
  const ApprovalsListWidget({Key? key}) : super(key: key);

  @override
  State<ApprovalsListWidget> createState() => _ApprovalsListWidgetState();
}

class _ApprovalsListWidgetState extends State<ApprovalsListWidget>
    with SingleTickerProviderStateMixin
    implements ApprovalListWidgetView {
  late ApprovalListWidgetPresenter _presenter;
  late ScrollController _scrollController;
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const DATA_VIEW = 3;
  var _errorMessage = "";

  var _approvalsListNotifier = ItemNotifier<List<Approval>>(defaultValue: []);
  var _viewSelectorNotifier = ItemNotifier<int>(defaultValue: 0);
  var _actionsCountNotifier = ItemNotifier<num>(defaultValue: 0);
  var _activeTabIndex = ItemNotifier<int>(defaultValue: 0);

  late TabController _tabController;

  void _setActiveTabIndex() {
    _activeTabIndex.notify(_tabController.index);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _presenter = ApprovalListWidgetPresenter(this);
    _tabController = TabController(vsync: this, length: 1);
    _tabController.addListener(_setActiveTabIndex);
    _presenter.loadApprovals();
    _setupScrollDownToLoadMoreItems();
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ItemNotifiable<int>(
      notifier: _viewSelectorNotifier,
      builder: (context, viewType) {
        if (viewType == LOADER_VIEW) {
          return Container(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (viewType == ERROR_VIEW) {
          return _errorAndRetryView();
        } else if (viewType == DATA_VIEW) {
          return _approvalListContainer();
        }
        return Container();
      },
    );
  }

  Widget _approvalListContainer() {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: Container(
                child: SizedBox(
                    height: 55,
                    width: 140,
                    child: ItemNotifiable(
                      notifier: _activeTabIndex,
                      builder: (context, index) => TabBar(
                        controller: _tabController,
                        indicatorSize: TabBarIndicatorSize.label,
                        indicator: const UnderlineTabIndicator(
                          insets: EdgeInsets.all(8.0),
                          borderSide: BorderSide(color: Colors.white, width: 3.0),
                        ),
                        tabs: <Widget>[
                          Tab(
                            child: ItemNotifiable<num>(
                              notifier: _actionsCountNotifier,
                              builder: (context, actionCount) => Text(
                                'Actions ($actionCount)',
                                maxLines: 1,
                                style: TextStyles.subTitleTextStyle.copyWith(
                                    color: index == 0 ? Colors.white : Colors.grey,
                                    fontSize: index == 0 ? 14.0 : 13.0,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 42.0, right: 16.0),
              child: Row(
                children: [
                  Text(
                    "All",
                    style: TextStyles.titleTextStyle.copyWith(color: Colors.white, fontSize: 18.0),
                  ),
                  SizedBox(width: 10),
                  SvgPicture.asset('assets/icons/right_arrow_icon.svg', height: 16, width: 16, color: Colors.white)
                ],
              ),
            ),
          ],
        ),
        ConstrainedBox(
            constraints: BoxConstraints(maxHeight: 165),
            child: ItemNotifiable<List<Approval>>(
              notifier: _approvalsListNotifier,
              builder: (context, approvalsList) {
                if (_presenter.isEmpty())
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Container(
                        height: 85,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: DashboardColors.noActionsGreen,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SvgPicture.asset('assets/icons/celebration.svg',
                                  height: 24, width: 24, color: AppColors.screenBackgroundColor),
                              SizedBox(width: 15),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Congrats!",
                                      style: TextStyles.screenTitleTextStyle
                                          .copyWith(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.w900)),
                                  Text("All actions cleared so far.",
                                      style: TextStyles.titleTextStyle.copyWith(color: Colors.white)),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                else
                  return _approvalsListView(approvalsList);
              },
            )),
      ],
    );
  }

  Widget _approvalsListView(List<Approval> approvals) {
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: false,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: _presenter.getNumberOfItems(),
        itemBuilder: (context, index) {
          if (index < _presenter.approvals.length) {
            return _item(_presenter.approvals[index]);
          } else {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [LoaderListTile()],
            );
          }
        });
  }

  Widget _item(Approval approval) {
    if (approval.isLeaveApproval()) {
      return LeaveApprovalTile(approval as LeaveApproval);

    }

    if (approval.isExpReqApp()) {
      return ExpenseRequestApprovalTile(approval as ExpenseRequestApproval);
    }

    if (approval.isAtAdApproval()) {
      return AttendanceAdjustmentApprovalTile(approval as AttendanceAdjustmentApproval);
    }
    return SizedBox();
  }

  Widget _errorAndRetryView() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Text(
                _errorMessage,
                textAlign: TextAlign.center,
                style: TextStyles.titleTextStyle.copyWith(color: Colors.white),
              ),
              onPressed: () => _presenter.refresh(),
            ),
          ],
        ),
      ),
    );
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _presenter.loadApprovals();
      }
    });
  }

  @override
  void onDidLoadApprovals(List<Approval> approvals) {
    _approvalsListNotifier.notify(approvals);
  }

  @override
  void showErrorMessage(String message) {
    _errorMessage = message;
    _viewSelectorNotifier.notify(ERROR_VIEW);
  }

  @override
  void onDidLoadData() {
    _viewSelectorNotifier.notify(DATA_VIEW);
  }

  @override
  void onLoad() {
    _viewSelectorNotifier.notify(LOADER_VIEW);
  }

  @override
  void onDidLoadActionsCount(num totalActions) {
    _actionsCountNotifier.notify(totalActions);
  }
}
