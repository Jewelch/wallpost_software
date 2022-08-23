import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/filter_views/dropdown_filter.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/aggregated_approvals_list/ui/presenters/aggregated_approvals_list_presenter.dart';
import 'package:wallpost/aggregated_approvals_list/ui/view_contracts/aggregated_approvals_list_view.dart';
import 'package:wallpost/aggregated_approvals_list/ui/views/aggregated_approvals_loader_view.dart';

import '../../../_common_widgets/buttons/rounded_back_button.dart';
import '../../../_shared/extensions/color_utils.dart';
import '../../../attendance_adjustment_approval/ui/views/attendance_adjustment_approval_list_screen.dart';
import '../../entities/aggregated_approval.dart';

class AggregatedApprovalsListScreen extends StatefulWidget {
  final String? companyId;

  AggregatedApprovalsListScreen({this.companyId});

  @override
  _AggregatedApprovalsListScreenState createState() => _AggregatedApprovalsListScreenState();
}

class _AggregatedApprovalsListScreenState extends State<AggregatedApprovalsListScreen>
    implements AggregatedApprovalsListView {
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const NO_MATCHING_ITEMS_VIEW = 3;
  static const DATA_VIEW = 4;

  late ScrollController _scrollController;
  late AggregatedApprovalsListPresenter _presenter;
  var _viewTypeNotifier = ItemNotifier<int>(defaultValue: 0);
  var _errorMessage = "";

  @override
  void initState() {
    _scrollController = ScrollController();
    _presenter = AggregatedApprovalsListPresenter(this, companyId: widget.companyId);
    _presenter.loadApprovalsList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: "Approvals",
        leadingButton: RoundedBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: ItemNotifiable<int>(
          notifier: _viewTypeNotifier,
          builder: (context, viewType) {
            if (viewType == LOADER_VIEW) {
              return AggregatedApprovalsLoaderView();
            } else if (viewType == ERROR_VIEW) {
              return _errorAndRetryView();
            } else if (viewType == NO_MATCHING_ITEMS_VIEW) {
              return _noMatchingItemsView();
            } else if (viewType == DATA_VIEW) {
              return _dataView();
            }
            return Container();
          },
        ),
      ),
    );
  }

  Widget _errorAndRetryView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextButton(
            child: Text(
              _errorMessage,
              textAlign: TextAlign.center,
              style: TextStyles.titleTextStyle,
            ),
            onPressed: () => _presenter.loadApprovalsList(),
          ),
        ],
      ),
    );
  }

  Column _noMatchingItemsView() {
    return Column(
      children: [
        SizedBox(height: 20),
        _companyAndModuleFilter(),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton(
                child: Text(_errorMessage, textAlign: TextAlign.center, style: TextStyles.titleTextStyle),
                onPressed: () => _presenter.loadApprovalsList(),
              ),
            ],
          ),
        )
      ],
    );
  }

  Column _dataView() {
    return Column(
      children: [
        SizedBox(height: 20),
        _companyAndModuleFilter(),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => _presenter.loadApprovalsList(),
            child: ListView.builder(
                physics: AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                scrollDirection: Axis.vertical,
                itemCount: _presenter.getNumberOfRows(),
                itemBuilder: (context, index) {
                  return _listItem(_presenter.getItemAtIndex(index));
                }),
          ),
        ),
      ],
    );
  }

  Widget _listItem(AggregatedApproval aggregatedApproval) {
    return Container(
      height: 90,
      margin: EdgeInsets.only(top: 16, left: 12, right: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: AppColors.listItemBorderColor),
      ),
      child: InkWell(
        onTap: () {
          if (aggregatedApproval.isAttendanceAdjustmentApproval()) {
            ScreenPresenter.present(
              AttendanceAdjustmentApprovalListScreen(companyId: aggregatedApproval.companyId),
              context,
            );
          }
        },
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 22),
            Text(
              aggregatedApproval.approvalCount.toString(),
              style: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.defaultColorDark),
            ),
            SizedBox(width: 22),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(aggregatedApproval.approvalType, style: TextStyles.titleTextStyleBold),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text('${aggregatedApproval.module.toUpperCase()} - ',
                          style: TextStyles.subTitleTextStyle.copyWith(
                            color: ColorUtils.initColorFromHex(aggregatedApproval.moduleColor),
                            fontWeight: FontWeight.bold,
                          )),
                      Flexible(
                        child: Text(
                          aggregatedApproval.companyName,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyles.subTitleTextStyle.copyWith(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 8),
            SvgPicture.asset(
              "assets/icons/arrow_right_icon.svg",
              width: 16,
              height: 16,
            ),
            SizedBox(width: 12),
          ],
        ),
      ),
    );
  }

  Widget _companyAndModuleFilter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          if (_presenter.shouldShowCompanyFilter())
            Expanded(
              child: DropdownFilter(
                items: _presenter.getCompanyNames(),
                selectedValue: _presenter.getSelectedCompanyName(),
                onDidSelectItemWithValue: (companyName) => _presenter.filter(companyName: companyName),
              ),
            ),
          if (_presenter.shouldShowCompanyFilter()) SizedBox(width: 12),
          Expanded(
            child: DropdownFilter(
              items: _presenter.getModuleNames(),
              selectedValue: _presenter.getSelectedModuleName(),
              onDidSelectItemWithValue: (moduleName) => _presenter.filter(moduleName: moduleName),
            ),
          ),
        ],
      ),
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewTypeNotifier.notify(LOADER_VIEW);
  }

  @override
  void onDidLoadApprovals() {
    _viewTypeNotifier.notify(DATA_VIEW);
  }

  @override
  void showErrorMessage(String message) {
    _errorMessage = message;
    _viewTypeNotifier.notify(ERROR_VIEW);
  }

  @override
  void showNoMatchingResultsMessage(String message) {
    _errorMessage = message;
    _viewTypeNotifier.notify(NO_MATCHING_ITEMS_VIEW);
  }
}
