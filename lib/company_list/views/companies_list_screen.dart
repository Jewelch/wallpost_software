import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/company_list_app_bar.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar_with_title.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_main/services/logout_handler.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_core/entities/company_group.dart';
import 'package:wallpost/company_core/entities/company_list_item.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';
import 'package:wallpost/company_list/presenters/companies_list_presenter.dart';
import 'package:wallpost/company_list/view_contracts/company_list_view.dart';
import 'package:wallpost/company_list/views/company_list_card.dart';
import 'package:wallpost/company_list/views/company_list_loader.dart';
import 'package:wallpost/company_list/views/financial_summary_card.dart';
import 'package:wallpost/dashboard/ui/dashboard_screen.dart';

class CompanyListScreen extends StatefulWidget {
  @override
  _CompanyListScreenState createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen>
    implements CompaniesListView {
  late CompaniesListPresenter presenter;
  var _scrollController = ScrollController();
  var _viewSelectorNotifier = ItemNotifier<int>();
  var _viewAppBarSelectorNotifier = ItemNotifier<bool>();
  var _searchBarVisibilityNotifier = ItemNotifier<bool>();
  var _appBarVisibilityNotifier = ItemNotifier<bool>();
  var _companyGroupsNotifier = ItemNotifier<List<CompanyGroup>>();
  var _financialSummaryNotifier = ItemNotifier<FinancialSummary>();
  var _companiesListNotifier = ItemNotifier<List<CompanyListItem>>();
  var _showErrorNotifier = ItemNotifier<String>();
  var _profileImageNotifier = ItemNotifier<String>();
  var _groupItemTapNotifier = ItemNotifier<int>();

  String _noSearchResultsMessage = "";
  String _errorMessage = "";
  static const COMPANIES_VIEW = 1;
  static const NO_SEARCH_RESULTS_VIEW = 2;
  static const ERROR_VIEW = 3;
  static const LOADER_VIEW = 4;

  @override
  void initState() {
    presenter = CompaniesListPresenter(this);
    presenter.loadCompanies();
    presenter.loadUserDetails();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OnTapKeyboardDismisser(
      //  scrollController: _scrollController,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: <Widget>[
            ItemNotifiable<bool>(
              notifier: _appBarVisibilityNotifier,
              builder: (context, showAppBar) {
                return (showAppBar == true) ?
                ItemNotifiable<bool>(
                  notifier: _viewAppBarSelectorNotifier,
                  builder: (context, showSearch) {
                    return (showSearch == true) ? _filtersView() : _appBar();
                  },
                ) : Container();
              },
            ),
            _financialSummaryView(),
            Expanded(
              child: Container(
                child: Column(
                  children: [
                    ItemNotifiable<int>(
                      notifier: _viewSelectorNotifier,
                      builder: (context, value) {
                        if (value == LOADER_VIEW) {
                          return Expanded(child: CompanyListLoader());
                        } else if (value == COMPANIES_VIEW) {
                          return Expanded(child: _companyListView());
                        } else if (value == NO_SEARCH_RESULTS_VIEW) {
                          return Expanded(child: _noSearchResultsMessageView());
                        } else if (value == ERROR_VIEW) {
                          return Expanded(child: _buildErrorAndRetryView());
                        }
                        return Container();
                      },
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //MARK: Function to build the app bar

  _appBar() {
    return ItemNotifiable<bool>(
        notifier: _searchBarVisibilityNotifier,
        builder: (context, showSearchBar) {
          return CompanyListAppBar(
            //title: 'Group Dashboard',
            leadingButton: _leadingButton(),
            trailingButton: SvgPicture.asset(
              'assets/icons/search_icon.svg',
              color: Colors.white,
              width: 14,
              height: 14,
            ),
            onLeadingButtonPressed: () => presenter.logout(),
            onTrailingButtonPressed: () => {
              if (showSearchBar == true)
                _viewAppBarSelectorNotifier.notify(true)
            },
            textButton1: TextButton(
              onPressed: () {},
              child: Text(
                "Group Summary",
                style: TextStyle(
                    color: Color(0xff0096E3),
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ),
          );
        });
  }

  Widget _leadingButton() {
    return Container(
        child: ItemNotifiable<String>(
            notifier: _profileImageNotifier,
            builder: (context, imageUrl) {
              return FadeInImage.assetNetwork(
                placeholder: 'assets/logo/placeholder.jpg',
                image: imageUrl!,
                fit: BoxFit.cover,
              );
            }));
  }

  //MARK: Functions to build the filters view

  _filtersView() {
    return Padding(
      padding: EdgeInsets.fromLTRB(8, 40, 8, 12),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          Row(
            children: <Widget>[
              Expanded(flex: 8, child: _searchBar()),
              Expanded(
                flex: 2,
                child: Center(
                  child: GestureDetector(
                      onTap: () => {
                            _viewAppBarSelectorNotifier.notify(false),
                            _groupItemTapNotifier.notify(null),
                            presenter.resetSearch()
                          },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red, fontSize: 18),
                      )),
                ),
              ),
            ],
          ),
          SizedBox(height: 8),
          Container(
              child: ItemNotifiable<List<CompanyGroup>>(
                  notifier: _companyGroupsNotifier,
                  builder: (context, companiesGroup) {
                    if ((companiesGroup != null) &&
                        (companiesGroup.isNotEmpty)) {
                      return Container(
                          height: 40,
                          child: ItemNotifiable<int>(
                              notifier: _groupItemTapNotifier,
                              builder: (context, tappedIndex) {
                                return ListView.builder(
                                  itemBuilder: (context, index) {
                                    return _groupElement(
                                        index, tappedIndex, companiesGroup);
                                  },
                                  shrinkWrap: true,
                                  scrollDirection: Axis.horizontal,
                                  itemCount: companiesGroup.length,
                                );
                              }));
                    } else
                      return Container();
                  })),
        ],
      ),
    );
  }

  Widget _searchBar() {
    return ItemNotifiable<bool>(
      notifier: _searchBarVisibilityNotifier,
      builder: (context, shouldShowSearchBar) {
        if (shouldShowSearchBar == true) {
          return SearchBarWithTitle(
            title: 'Search',
            onChanged: (searchText) => presenter.performSearch(searchText),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _groupElement(
      int index, int? tappedIndex, List<CompanyGroup> companiesGroup) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
      child: ItemNotifiable<String>(
        notifier: _profileImageNotifier,
        builder: (context, imageUrl) {
          return ActionChip(
            elevation: 2,
            label: Text(companiesGroup[index].name),
            labelStyle: TextStyle(color: Color(0xff003C81)),
            backgroundColor: AppColors.backGroundColor,
            side: BorderSide(
                color: tappedIndex == index
                    ? Color(0xff003C81)
                    : Colors.transparent,
                width: 1,
                style: BorderStyle.solid),
            onPressed: () {
              _groupItemTapNotifier.notify(index);
              presenter.showGroup(index);
            },
          );
        },
      ),
    );
  }

  //MARK: Function to build the financial summary

  Widget _financialSummaryView() {
    return ItemNotifiable<FinancialSummary>(
      notifier: _financialSummaryNotifier,
      builder: (context, summary) {
        if (summary != null) {
          return Container(child: FinancialSummaryCard(summary));
        } else
          return Container();
      },
    );
  }

  //MARK: Functions to make the company list view

  Widget _companyListView() {
    return ItemNotifiable<List<CompanyListItem>>(
      notifier: _companiesListNotifier,
      builder: (context, companyList) {
        return Container(
          child: RefreshIndicator(
            onRefresh: () => presenter.refresh(),
            child: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.separated(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                controller: _scrollController,
                itemCount: companyList!.length,
                itemBuilder: (context, index) {
                  return _getCompanyCard(index, companyList);
                },
                separatorBuilder: (BuildContext context, int index) {
                  return Divider();
                },
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _getCompanyCard(int index, List<CompanyListItem> companyList) {
    return CompanyListCard(
        company: companyList[index],
        onPressed: () {
          presenter.selectCompanyAtIndex(index);
        });
  }

  //MARK: Functions to build error views

  Widget _noSearchResultsMessageView() {
    return Container(
      child: Center(
          child: Text(
        _noSearchResultsMessage,
        textAlign: TextAlign.center,
        style: TextStyles.failureMessageTextStyle,
      )),
    );
  }

  Widget _buildErrorAndRetryView() {
    return ItemNotifiable<String>(
        notifier: _showErrorNotifier,
        builder: (context, errorMessage) {
          return Container(
            height: 150,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    child: Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: TextStyles.failureMessageTextStyle,
                    ),
                    onPressed: () => presenter.refresh(),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //MARK: View functions

  @override
  void showProfileImage(String url) {
    _profileImageNotifier.notify(url);
  }

  @override
  void showLoader() {
    _viewSelectorNotifier.notify(LOADER_VIEW);
    _appBarVisibilityNotifier.notify(false);
  }

  @override
  void hideLoader() {
    _appBarVisibilityNotifier.notify(true);

  }

  @override
  void showSearchBar() {
    _searchBarVisibilityNotifier.notify(true);
  }

  @override
  void hideSearchBar() {
    _searchBarVisibilityNotifier.notify(false);
  }

  @override
  void showCompanyGroups(List<CompanyGroup> companyGroups) {
    _companyGroupsNotifier.notify(companyGroups);
  }

  @override
  void hideCompanyGroups() {}

  @override
  void showFinancialSummary(FinancialSummary groupSummary) {
    _financialSummaryNotifier.notify(groupSummary);
  }

  @override
  void hideFinancialSummary() {
    _financialSummaryNotifier.notify(null);
  }

  @override
  void showCompanyList(List<CompanyListItem> companies) {
    _companiesListNotifier.notify(companies);
    _viewSelectorNotifier.notify(COMPANIES_VIEW);
  }

  @override
  void hideCompanyList() {}

  @override
  void showNoSearchResultsMessage(String message) {
    _noSearchResultsMessage = message;
    _viewSelectorNotifier.notify(NO_SEARCH_RESULTS_VIEW);
  }

  @override
  void showErrorMessage(String message) {
    _errorMessage = message;
    _showErrorNotifier.notify(message);
    _viewSelectorNotifier.notify(ERROR_VIEW);
  }

  @override
  void goToCompanyDetailScreen() {
    ScreenPresenter.presentAndRemoveAllPreviousScreens(
        DashboardScreen(), context);
  }

  @override
  void onCompanyDetailsLoadingFailed(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void showLogoutAlert(String title, String message) {
    Alert.showSimpleAlertWithButtons(
      context: context,
      title: title,
      message: message,
      buttonOneTitle: "Yes",
      buttonTwoTitle: "Cancel",
      buttonOneOnPressed: () {
        LogoutHandler().logout(context);
      },
    );
  }

  @override
  void showAppBar(bool visibility) {
    _viewAppBarSelectorNotifier.notify(visibility);
  }

  @override
  void selectGroupItem(int? index) {
    _groupItemTapNotifier.notify(index);
  }
}
