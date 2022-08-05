import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/custom_shapes/my_portal_header_card.dart';
import 'package:wallpost/approvals_list/entities/approval_aggregated.dart';
import 'package:wallpost/dashboard/constants/dashboard_colors.dart';
import 'package:wallpost/dashboard/ui/my_portal/view_contracts/my_portal_view.dart';
import 'package:wallpost/dashboard/ui/my_portal/views/my_portal_app_bar.dart';
import '../../../../_common_widgets/custom_shapes/curve_bottom_to_top.dart';
import '../../../../_common_widgets/filter_views/multi_select_filter_chips.dart';
import '../../../../_common_widgets/list_view/loader_list_tile.dart';
import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../_shared/constants/app_colors.dart';
import '../presenters/my_portal_presenter.dart';

class MyPortalScreen extends StatefulWidget {
  final String? companyId;
  const MyPortalScreen(this.companyId);

  @override
  _MyPortalScreenState createState() => _MyPortalScreenState();
}

class _MyPortalScreenState extends State<MyPortalScreen>
    with SingleTickerProviderStateMixin
    implements MyPortalView {
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const DATA_VIEW = 3;

  late MyPortalPresenter _presenter;
  late ScrollController _scrollController;

  var _errorMessage = "";

  var _viewSelectorNotifier = ItemNotifier<int>(defaultValue: 0);
  var _activeTabIndex = ItemNotifier<int>(defaultValue: 0);
  var _actionsCountNotifier = ItemNotifier<num>(defaultValue: 0);
  var _approvalsListNotifier =
      ItemNotifier<List<ApprovalAggregated>>(defaultValue: []);

  late TabController _tabController;

  void _setActiveTabIndex() {
    _activeTabIndex.notify(_tabController.index);
  }

  @override
  void initState() {
    _scrollController = ScrollController();
    _presenter = MyPortalPresenter(this);
    _tabController = TabController(vsync: this, length: 1);
    _tabController.addListener(_setActiveTabIndex);
    _presenter.loadApprovalsList(widget.companyId);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ItemNotifiable<int>(
          notifier: _viewSelectorNotifier,
          builder: (context, viewType) {
            if (viewType == LOADER_VIEW) {
              return Container(
                child: Center(child: CircularProgressIndicator()),
              );
            } else if (viewType == ERROR_VIEW) {
              return _errorAndRetryView();
            } else if (viewType == DATA_VIEW) {
              return _dataView();
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _dataView() {
    return SingleChildScrollView(
        child: Column(
      children: [
        _topBar(),
        _mainContent(),
        Padding(
          padding: const EdgeInsets.only(right: 16.0, left: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Create",
                  style: TextStyles.largeTitleTextStyleBold.copyWith(
                      fontSize: 16.0,
                      color: AppColors.defaultColorWithTransparency)),
              Row(
                children: [
                  Icon(
                    Icons.arrow_upward,
                    color: AppColors.defaultColor,
                    size: 17.0,
                  ),
                  SizedBox(width: 3),
                  Text("More",
                      style: TextStyles.subTitleTextStyle
                          .copyWith(color: AppColors.defaultColor)),
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
    ));
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
                    style: TextStyles.largeTitleTextStyleBold.copyWith(
                        fontSize: 16.0,
                        color: AppColors.defaultColorWithTransparency)),
                Row(
                  children: [
                    Icon(
                      Icons.arrow_upward,
                      color: AppColors.defaultColor,
                      size: 17.0,
                    ),
                    SizedBox(width: 3),
                    Text("More",
                        style: TextStyles.subTitleTextStyle
                            .copyWith(color: AppColors.defaultColor)),
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
              _punchButton(AppColors.punchInDarkGreenColor,
                  MediaQuery.of(context).size.width, _backPunchButtonContent()),
              Positioned(
                  child: _punchButton(
                      AppColors.successColor,
                      MediaQuery.of(context).size.width * 0.78,
                      _frontPunchButtonContent()))
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
          Text("More",
              style: TextStyles.subTitleTextStyle.copyWith(color: Colors.white))
        ],
      ),
    ));
  }

  _frontPunchButtonContent() {
    return Container(
        child: Padding(
      padding:
          const EdgeInsets.only(right: 16.0, top: 8.0, bottom: 8.0, left: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Punch In",
                  style: TextStyles.subTitleTextStyle
                      .copyWith(color: Colors.white, fontSize: 18.0)),
              Text("Barawi Commercial avenue",
                  style: TextStyles.subTitleTextStyle
                      .copyWith(color: Colors.white))
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("8:01 AM",
                  style: TextStyles.subTitleTextStyle
                      .copyWith(color: Colors.white, fontSize: 18.0)),
              Text("Absent",
                  style: TextStyles.subTitleTextStyle
                      .copyWith(color: Colors.white))
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
                style: TextStyles.screenTitleTextStyle.copyWith(
                    color: DashboardColors.portalTitleRedColor,
                    fontSize: 22.0,
                    fontWeight: FontWeight.w900),
              ),
              SizedBox(width: 10),
              SvgPicture.asset('assets/icons/down_arrow_icon.svg',
                  height: 14, width: 14, color: AppColors.cautionColor)
            ],
          ),
        ),
        MyPortalHeaderCard(
          content: DefaultTabController(
            initialIndex: 0,
            length: 0,
            child: Column(
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
                                  borderSide: BorderSide(
                                      color: Colors.white, width: 3.0),
                                ),
                                tabs: <Widget>[
                                  Tab(
                                    child: ItemNotifiable<num>(
                                      notifier: _actionsCountNotifier,
                                      builder: (context, actionCount) => Text(
                                        'Actions ($actionCount)',
                                        maxLines: 1,
                                        style: TextStyles.subTitleTextStyle
                                            .copyWith(
                                                color: index == 0
                                                    ? Colors.white
                                                    : Colors.grey,
                                                fontSize:
                                                    index == 0 ? 14.0 : 13.0,
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
                            style: TextStyles.titleTextStyle
                                .copyWith(color: Colors.white, fontSize: 18.0),
                          ),
                          SizedBox(width: 10),
                          SvgPicture.asset('assets/icons/right_arrow_icon.svg',
                              height: 16, width: 16, color: Colors.white)
                        ],
                      ),
                    ),
                  ],
                ),
                ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 165),
                    child: ItemNotifiable<List<ApprovalAggregated>>(
                      notifier: _approvalsListNotifier,
                      builder: (context, approvalsList) {
                        if (approvalsList.isEmpty)
                          return Center(
                            child: Padding(
                              padding: const EdgeInsets.all(24.0),
                              child: Container(
                                height: 85,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: AppColors.noActionsGreen,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SvgPicture.asset(
                                          'assets/icons/celebration.svg',
                                          height: 24,
                                          width: 24,
                                          color:
                                              AppColors.screenBackgroundColor),
                                      SizedBox(width: 15),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text("Congrats!",
                                              style: TextStyles
                                                  .screenTitleTextStyle
                                                  .copyWith(
                                                      color: Colors.white,
                                                      fontSize: 22.0,
                                                      fontWeight:
                                                          FontWeight.w900)),
                                          Text("All actions cleared so far.",
                                              style: TextStyles.titleTextStyle
                                                  .copyWith(
                                                      color: Colors.white)),
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
            ),
          ),
        ),
      ],
    );
  }

  Widget _approvalsListView(List<ApprovalAggregated> approvals) {
    return ListView.builder(
        controller: _scrollController,
        shrinkWrap: false,
        scrollDirection: Axis.horizontal,
        physics: BouncingScrollPhysics(),
        itemCount: approvals.length,
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

  Widget _item(ApprovalAggregated approval) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              color: AppColors.portalItemRedColor.withOpacity(0.6),
            ),
            color: AppColors.portalItemRedColor.withOpacity(0.6),
            borderRadius: BorderRadius.all(Radius.circular(20))),
        height: 180,
        width: 140,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0, left: 20.0),
              child: Text(
                approval.companyName,
                style: TextStyles.subTitleTextStyle
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 5),
            // Padding(
            //   padding: const EdgeInsets.only(top: 8.0, left: 16.0),
            //   child: Text(
            //     "by",
            //     style: TextStyles.titleTextStyle.copyWith(color: Colors.white),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Text(
                approval.approvalCount.toString(),
                style: TextStyles.subTitleTextStyle.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13.0),
              ),
            ),
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
              child: Text(
                approval.module,
                style: TextStyles.subTitleTextStyle
                    .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            )
          ],
        ),
      ),
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
                style: TextStyles.titleTextStyle,
              ),
              onPressed: () => _presenter.refresh(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void onLoad() {
    _viewSelectorNotifier.notify(LOADER_VIEW);
  }

  @override
  void showErrorMessage(String message) {
    _errorMessage = message;
    _viewSelectorNotifier.notify(ERROR_VIEW);
  }

  @override
  void onDidLoadApprovals(List<ApprovalAggregated> approvalsList) {
    _viewSelectorNotifier.notify(DATA_VIEW);
    _approvalsListNotifier.notify(approvalsList);
  }

  @override
  void onDidLoadActionsCount(num totalActions) {
    _actionsCountNotifier.notify(totalActions);
  }
}
