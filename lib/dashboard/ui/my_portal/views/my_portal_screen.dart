import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/custom_shapes/my_portal_header_card.dart';
import 'package:wallpost/approvals/ui/views/approval_list_widget.dart';
import 'package:wallpost/dashboard/constants/dashboard_colors.dart';
import 'package:wallpost/dashboard/ui/my_portal/view_contracts/my_portal_view.dart';
import 'package:wallpost/dashboard/ui/my_portal/views/list_tiles/attendance_adjustment_approval_tile.dart';
import 'package:wallpost/dashboard/ui/my_portal/views/list_tiles/expense_request_approval_tile.dart';
import 'package:wallpost/dashboard/ui/my_portal/views/list_tiles/leave_approval_tile.dart';
import 'package:wallpost/dashboard/ui/my_portal/views/my_portal_app_bar.dart';

import '../../../../_common_widgets/custom_shapes/curve_bottom_to_top.dart';
import '../../../../_common_widgets/filter_views/multi_select_filter_chips.dart';
import '../../../../_common_widgets/list_view/loader_list_tile.dart';
import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../_shared/constants/app_colors.dart';
import '../../../../approvals/entities/approval.dart';
import '../presenters/my_portal_presenter.dart';

class MyPortalScreen extends StatefulWidget {
  @override
  _MyPortalScreenState createState() => _MyPortalScreenState();
}

class _MyPortalScreenState extends State<MyPortalScreen> implements MyPortalView {


  late MyPortalPresenter _presenter;
  var _approvalsListNotifier = ItemNotifier<List<Approval>>(defaultValue: []);




  @override
  void initState() {
    _presenter = MyPortalPresenter(this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _dataView(),
      ),
    );
  }

  Widget _dataView() {
    return Column(
      children: [
        _topBar(),
        _mainContent(),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Create",
                  style: TextStyles.largeTitleTextStyleBold
                      .copyWith(fontSize: 16.0, color: AppColors.defaultColorWithTransparency)),
              Row(
                children: [
                  Icon(
                    Icons.arrow_upward,
                    color: AppColors.defaultColor,
                    size: 17.0,
                  ),
                  SizedBox(width: 3),
                  Text("More", style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor)),
                ],
              ),
              // style: TextStyles.subTitleTextStyle
              //     .copyWith(color: Colors.white))
            ],
          ),
        ),
        SizedBox(height: 5),
        Container(
          height: 38,
          child: MultiSelectFilterChips(
            titles: ["Lead", "Proposal", "Timesheet"],
            selectedIndices: [],
            onItemSelected: (index) => {},
            onItemDeselected: (index) => {},
          ),
        ),
        Stack(
          clipBehavior: Clip.none,
          children: [CurveBottomToTop(), _punchBlock()],
        )
      ],
    );
  }

  Widget _punchBlock() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8.0, 48.0, 8.0, 8.0),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0, left: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Requests",
                    style: TextStyles.largeTitleTextStyleBold
                        .copyWith(fontSize: 16.0, color: AppColors.defaultColorWithTransparency)),
                Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: AppColors.defaultColor,
                      size: 17.0,
                    ),
                    SizedBox(width: 3),
                    Text("More", style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.defaultColor)),
                  ],
                ),
                // style: TextStyles.subTitleTextStyle
                //     .copyWith(color: Colors.white))
              ],
            ),
          ),
          SizedBox(height: 10),
          Container(
            height: 40,
            child: MultiSelectFilterChips(
              titles: ["Leave", "Expense", "Support Ticket"],
              selectedIndices: [],
              onItemSelected: (index) => {},
              onItemDeselected: (index) => {},
            ),
          ),
          SizedBox(height: 24),
          Stack(
            children: [
              _punchButton(
                  //TODO
                  Colors.purple,
                  MediaQuery.of(context).size.width,
                  _backPunchButtonContent()),
              Positioned(
                  child: _punchButton(
                      AppColors.successColor, MediaQuery.of(context).size.width * 0.78, _frontPunchButtonContent()))
            ],
          ),
        ],
      ),
    );
  }

  _backPunchButtonContent() {
    return Container(
        child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Icon(
            Icons.arrow_upward,
            color: Colors.white,
            size: 17.0,
          ),
          SizedBox(width: 3),
          Text("More", style: TextStyles.subTitleTextStyle.copyWith(color: Colors.white))
        ],
      ),
    ));
  }

  _frontPunchButtonContent() {
    return Container(
        child: Padding(
      padding: const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0, left: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Punch In", style: TextStyles.subTitleTextStyle.copyWith(color: Colors.white, fontSize: 18.0)),
              Text("Barawi Commercial avenue", style: TextStyles.subTitleTextStyle.copyWith(color: Colors.white))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("8:01 AM", style: TextStyles.subTitleTextStyle.copyWith(color: Colors.white, fontSize: 18.0)),
              Text("Absent", style: TextStyles.subTitleTextStyle.copyWith(color: Colors.white))
            ],
          ),
        ],
      ),
    ));
  }

  Widget _punchButton(
    Color color,
    double width,
    Container content,
  ) {
    return Container(
      alignment: Alignment.topLeft,
      child: Container(
        width: width,
        height: 65,
        decoration: BoxDecoration(
          border: Border.all(
            color: color,
          ),
          color: color,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              spreadRadius: 0.8,
              blurRadius: 4,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: content,
      ),
    );
  }

  Widget _mainContent() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Row(
            children: [
              Text(
                "My Portal",
                style: TextStyles.screenTitleTextStyle
                    .copyWith(color: DashboardColors.portalTitleRedColor, fontSize: 22.0, fontWeight: FontWeight.w900),
              ),
              SizedBox(width: 10),
              SvgPicture.asset('assets/icons/down_arrow_icon.svg', height: 14, width: 14, color: AppColors.cautionColor)
            ],
          ),
        ),
        MyPortalHeaderCard(
          content: DefaultTabController(
            initialIndex: 0,
            length: 0,
            child: ApprovalsListWidget(),
          ),
        ),
      ],
    );
  }


  Widget _topBar() {
    return _appBar();
  }

  Widget _appBar() {
    return MyPortalAppBar(
      profileImageUrl: _presenter.getProfileImageUrl(),
      onAddButtonPressed: () {},
    );
  }

  @override
  void onDidLoadApprovals(List<Approval> approvalsList) {
    _approvalsListNotifier.notify(approvalsList);
  }


}
