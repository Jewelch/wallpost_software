import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/expense_list/entities/expense_request_status_filter.dart';
import 'package:wallpost/expense_list/ui/models/expense_list_item_type.dart';
import 'package:wallpost/expense_list/ui/presenters/expense_list_presenter.dart';
import 'package:wallpost/expense_list/ui/view_contracts/expense_list_view.dart';
import 'package:wallpost/expense_list/ui/views/widgets/expense_list_item.dart';
import 'package:wallpost/expense_list/ui/views/widgets/expense_list_loader.dart';

class ExpenseListScreen extends StatefulWidget {
  const ExpenseListScreen({Key? key}) : super(key: key);

  @override
  _ExpenseListScreenState createState() => _ExpenseListScreenState();
}

class _ExpenseListScreenState extends State<ExpenseListScreen> implements ExpenseListView {
  late ExpenseListPresenter _presenter;
  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier(defaultValue: 1);
  final _scrollController = ScrollController();
  final int viewTypeLoader = 1;
  final int viewTypeError = 2;
  final int viewTypeLeaveList = 3;

  @override
  void initState() {
    _setupScrollDownToLoadMoreItems();
    _presenter = ExpenseListPresenter(this);
    _presenter.loadExpenseRequests();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _presenter.loadExpenseRequests();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: SimpleAppBar(
        title: "Expense Requests",
        leadingButton: RoundedBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _presenter.refresh,
          child: Column(
            children: [
              SizedBox(height: 16),
              Container(
                height: 40,
                margin: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: AppColors.dropDownColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: DropdownButton<ExpenseRequestStatusFilter>(
                    items: _presenter.expenseRequestsFilters.map((filter) {
                      return DropdownMenuItem(
                        value: filter,
                        child: Text(filter.toReadableString()),
                      );
                    }).toList(),
                    value: _presenter.selectedStatusFilter,
                    onChanged: (filter) => setState(() {
                      if (filter != null) _presenter.selectFilter(filter);
                    }),
                    icon: SvgPicture.asset(
                      'assets/icons/down_arrow_icon.svg',
                      color: AppColors.defaultColorDark,
                      width: 14,
                      height: 14,
                    ),
                    style: TextStyles.titleTextStyle.copyWith(color: AppColors.defaultColorDark),
                    dropdownColor: AppColors.dropDownColor,
                    underline: SizedBox(),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ItemNotifiable(
                  notifier: _viewTypeNotifier,
                  builder: (context, viewType) {
                    if (viewType == viewTypeLoader) {
                      return _buildLoaderView();
                    } else if (viewType == viewTypeError) {
                      return _buildErrorView();
                    } else {
                      return _buildListView();
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoaderView() {
    return Container(height: MediaQuery.of(context).size.height, child: ExpenseListLoader());
  }

  Widget _buildErrorView() {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24, bottom: 50),
      child: Center(
        child: GestureDetector(
          onTap: () => _presenter.loadExpenseRequests(),
          child: Container(
            child: Text(
              _presenter.errorMessage,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildListView() {
    return ListView.builder(
      shrinkWrap: true,
      controller: _scrollController,
      physics: BouncingScrollPhysics(),
      itemCount: _presenter.getNumberOfListItems(),
      itemBuilder: (context, index) {
        switch (_presenter.getItemTypeAtIndex(index)) {
          case ExpenseListItemType.ExpenseListItem:
            return ExpenseListItem(_presenter.getExpenseListItemAtIndex(index));
          case ExpenseListItemType.Loader:
            return Container(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            );
          case ExpenseListItemType.ErrorMessage:
            return GestureDetector(
              onTap: () => _presenter.loadExpenseRequests(),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: 200,
                child: Text(
                  _presenter.errorMessage,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          case ExpenseListItemType.EmptySpace:
            return Container();
        }
      },
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewTypeNotifier.notify(viewTypeLoader);
  }

  @override
  void showErrorMessage(String message) {
    print(message);
    _viewTypeNotifier.notify(viewTypeError);
  }

  @override
  void updateExpenseList() {
    _viewTypeNotifier.notify(viewTypeLeaveList);
  }
}
