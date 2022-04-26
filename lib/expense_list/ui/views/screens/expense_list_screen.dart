import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/app_bars/app_bar_with_title.dart';
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
    _presenter.getNextExpenses();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _presenter.getNextExpenses();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(title: "Expense Requests",),
      body: SafeArea(
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
    );
  }

  Widget _buildLoaderView() {
    return ExpenseListLoader();
  }

  Widget _buildErrorView() {
    return GestureDetector(
      onTap: () => _presenter.getNextExpenses(),
      child: Container(
        height: 100,
        child: Text(_presenter.errorMessage),
      ),
    );
  }

  Widget _buildListView() {
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      children: [
        ListView.builder(
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
                  child: CircularProgressIndicator(),
                );
              case ExpenseListItemType.ErrorMessage:
                return GestureDetector(
                  onTap: () => _presenter.getNextExpenses(),
                  child: Container(
                    height: 100,
                    child: Text(_presenter.errorMessage),
                  ),
                );
              case ExpenseListItemType.EmptySpace:
                return Container();
            }
          },
        ),
      ],
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewTypeNotifier.notify(viewTypeLoader);
  }

  @override
  void showErrorMessage(String message) {
    _viewTypeNotifier.notify(viewTypeError);
  }

  @override
  void updateExpenseList() {
    _viewTypeNotifier.notify(viewTypeLeaveList);
  }
}
