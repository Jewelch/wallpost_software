import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/approvals_list/entities/approval_aggregated.dart';
import 'package:wallpost/approvals_list/ui/presenters/approvals_aggregated_list_presenter.dart';
import 'package:wallpost/approvals_list/ui/view_contracts/approvals_list_view.dart';
import 'package:wallpost/approvals_list/ui/views/approvals_aggregated_list_loader.dart';
import 'package:wallpost/approvals_list/ui/views/approvals_list_app_bar.dart';

import '../../../_common_widgets/list_view/loader_list_tile.dart';
import '../../../company_list/views/company_list_loader.dart';
import '_filter.dart';

class ApprovalsListScreen extends StatefulWidget {
  @override
  _ApprovalsListScreenState createState() => _ApprovalsListScreenState();
}

class _ApprovalsListScreenState extends State<ApprovalsListScreen>
    with SingleTickerProviderStateMixin
    implements ApprovalsListView {
  late ApprovalsListPresenter presenter;

  @override
  void initState() {
    presenter = ApprovalsListPresenter(this);
    _scrollController = ScrollController();
    presenter.loadApprovalsList();
    super.initState();
  }

  String? selectedValue;

  late ScrollController _scrollController;
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const DATA_VIEW = 3;
  var _errorMessage = "";

  var _approvalsListNotifier =
  ItemNotifier<List<ApprovalAggregated>>(defaultValue: []);
  var _companiesListNotifier = ItemNotifier<List<String>>(defaultValue: []);
  var _modulesListNotifier = ItemNotifier<List<String>>(defaultValue: []);
  var _viewSelectorNotifier = ItemNotifier<int>(defaultValue: 0);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ItemNotifiable<int>(
          notifier: _viewSelectorNotifier,
          builder: (context, viewType) {
            if (viewType == LOADER_VIEW) {
              return ApprovalsAggregatedListLoader();
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

  Column _dataView() {
    return Column(
      children: [
        _appBar(),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                child: ItemNotifiable<List<String>>(
                    notifier: _companiesListNotifier,
                    builder: (context, companies) {
                      return Filter(
                        hint: " All Companies ",
                        buttonWidth: 180.0,
                        items: companies,
                        onClicked: (company) => presenter.filter(null, company!),
                      );
                    }),
              ),
              SizedBox(width: 16),
              Container(
                  child: ItemNotifiable<List<String>>(
                      notifier: _modulesListNotifier,
                      builder: (context, modules) {
                        return Filter(
                          hint: " All Modules ",
                          buttonWidth: 140.0,
                          items: modules,
                          onClicked: (module) => presenter.filter(module!,null),
                        );
                      }))
            ],
          ),
        ),
        Expanded(
            child: ItemNotifiable<List<ApprovalAggregated>>(
              notifier: _approvalsListNotifier,
              builder: (context, approvalList) {
                return ListView.builder(
                    controller: _scrollController,
                    shrinkWrap: false,
                    scrollDirection: Axis.vertical,
                    itemCount: approvalList.length,
                    itemBuilder: (context, index) {
                      return _item(approvalList[index]);
                    });
              },
            ))
      ],
    );
  }

  Padding _item(ApprovalAggregated approvalPending) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
          elevation: 2,
          color: Colors.white,
          child: Row(
              children: [
            Padding(
                padding: EdgeInsets.all(16),
                child: Text(approvalPending.approvalCount.toString(),
                    style: TextStyles.labelTextStyleBold.copyWith(
                        color: AppColors.defaultColorDark, fontSize: 18.0))),
            Padding(
              padding: const EdgeInsets.only(top: 8.0,bottom: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.0),
                  Text(approvalPending.approvalType,
                      style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.black,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: 4.0),
                  Row(
                    children: [
                      Text('${approvalPending.module} - ',
                          style: TextStyle(
                              color: Colors.orange,
                              fontWeight: FontWeight.w300,
                          )),
                      Text(approvalPending.companyName,
                          style: TextStyle(
                              color: Colors.grey, fontWeight: FontWeight.w400,overflow: TextOverflow.ellipsis
                          )),
                    ],
                  ),
                ],
              ),
            ),
            Spacer(),
            Icon(Icons.navigate_next, color: Colors.black)
          ])),
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
              onPressed: () => presenter.refresh(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _appBar() {
    return ApprovalsListAppBar(
      onBackPressed: () => Navigator.pop(context),
    );
  }

  @override
  void onDidLoadApprovals(List<ApprovalAggregated> approvals) {
    _viewSelectorNotifier.notify(DATA_VIEW);
    _approvalsListNotifier.notify(approvals);
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
  void onDidLoadCompanies(List<String> companies) {
    _companiesListNotifier.notify(companies);
  }

  @override
  void onDidLoadModules(List<String> modules) {
    _modulesListNotifier.notify(modules);
  }
}
