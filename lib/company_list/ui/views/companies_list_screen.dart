import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar_with_title.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_main/services/logout_handler.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/company_list/ui/contracts/company_list_view.dart';
import 'package:wallpost/company_list/ui/presenters/companies_list_presenter.dart';
import 'package:wallpost/company_list/ui/views/company_list_card_with_revenue.dart';
import 'package:wallpost/dashboard/ui/dashboard_screen.dart';

class CompanyListScreen extends StatefulWidget {
  @override
  _CompanyListScreenState createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen> implements CompaniesListView {
  late CompaniesListPresenter presenter;
  var _searchBarVisibilityNotifier = ItemNotifier<bool>();
  var _showErrorNotifier = ItemNotifier<bool>();
  var _companiesListNotifier = ItemNotifier<List<CompanyListItem>?>();
  var _viewSelectorNotifier = ItemNotifier<int>();
  var _scrollController = ScrollController();

  String _noCompaniesMessage = "";
  String _noSearchResultsMessage = "";
  String _errorMessage = "";
  static const COMPANIES_VIEW = 1;
  static const NO_COMPANIES_VIEW = 2;
  static const NO_SEARCH_RESULTS_VIEW = 3;
  static const ERROR_VIEW = 4;
  late Loader loader;

  @override
  void initState() {
    presenter = CompaniesListPresenter(this);
    presenter.loadCompanies();
    loader = Loader(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OnTapKeyboardDismisser(
      //  scrollController: _scrollController,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: SimpleAppBar(
          title: 'Group Dashboard',
          leadingButtons: [
            CircularIconButton(iconName: 'assets/icons/menu_icon.svg', iconSize: 12, onPressed: () => presenter.logout()
                // ScreenPresenter.present(
                //   LeftMenuScreen(),
                //   context,
                //   slideDirection: SlideDirection.fromLeft,
                // )
                )
          ],
        ),
        body: Column(children: <Widget>[
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              color: AppColors.primaryContrastColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(children: [
              _searchBar(),
              ItemNotifiable<int>(
                  notifier: _viewSelectorNotifier,
                  builder: (context, value) {
                    if (value == COMPANIES_VIEW) {
                      return Expanded(child: _getCompanies());
                    } else if (value == NO_COMPANIES_VIEW) {
                      return Expanded(child: _noCompaniesMessageView());
                    } else if (value == NO_SEARCH_RESULTS_VIEW) {
                      return Expanded(child: _noSearchResultsMessageView());
                    }
                    return Expanded(child: _buildErrorAndRetryView());
                  })
            ]),
          )),
        ]),
      ),
    );
  }

  Widget _searchBar() {
    return ItemNotifiable<bool>(
      notifier: _searchBarVisibilityNotifier,
      builder: (context, shouldShowSearchBar) {
        if (shouldShowSearchBar == true) {
          return SearchBarWithTitle(
            title: 'Choose company',
            onChanged: (searchText) => presenter.performSearch(searchText),
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _getCompanies() {
    return ItemNotifiable<List<CompanyListItem>>(
      notifier: _companiesListNotifier,
      builder: (context, value) => Container(
        padding: EdgeInsets.only(top: 8, bottom: 8),
        child: RefreshIndicator(
          onRefresh: () => presenter.loadCompanies(),
          child: ListView.builder(
            physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
            controller: _scrollController,
            itemCount: value?.length,
            itemBuilder: (context, index) {
              if (value != null) {
                return _getCompanyCard(index, value);
              } else
                return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _noCompaniesMessageView() {
    return GestureDetector(
      onTap: () => presenter.loadCompanies(),
      child: Container(
        child: Center(
            child: Text(
          _noCompaniesMessage,
          textAlign: TextAlign.center,
          style: TextStyles.failureMessageTextStyle,
        )),
      ),
    );
  }

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
    return ItemNotifiable<bool>(
        notifier: _showErrorNotifier,
        builder: (context, value) {
          if (value == true) {
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
          } else
            return Container();
        });
  }

  Widget _getCompanyCard(int index, List<CompanyListItem> companyList) {
    //if (companyList[index].shouldShowRevenue) {
    return CompanyListCardWithRevenue(
      company: companyList[index],
      onPressed: () => {
        presenter.selectCompanyAtIndex(index),
      },
    );
    // need to check with specifications
    // } else
    //   return CompanyListCardWithOutRevenue(
    //     company: companyList[index],
    //     onPressed: () =>
    //     {
    //       presenter.selectCompanyAtIndex(index),
    //     },
    //   );
  }

  //MARK: View functions

  @override
  void showLoader() {
    SchedulerBinding.instance?.addPostFrameCallback((_) {
      loader.showLoadingIndicator("Loading");
    });
  }

  @override
  void hideLoader() {
    loader.hideOpenDialog();
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
  void showCompanyList(List<CompanyListItem> companies) {
    _companiesListNotifier.notify(companies);
    _viewSelectorNotifier.notify(COMPANIES_VIEW);
  }

  @override
  void showNoCompaniesMessage(String message) {
    _noCompaniesMessage = message;
    _viewSelectorNotifier.notify(NO_COMPANIES_VIEW);
  }

  @override
  void showNoSearchResultsMessage(String message) {
    _noSearchResultsMessage = message;
    _viewSelectorNotifier.notify(NO_SEARCH_RESULTS_VIEW);
  }

  @override
  void showErrorMessage(String message) {
    _errorMessage = message;
    _showErrorNotifier.notify(true);
    _viewSelectorNotifier.notify(ERROR_VIEW);
  }

  @override
  void onCompanyDetailsLoadedSuccessfully() {
    ScreenPresenter.presentAndRemoveAllPreviousScreens(DashboardScreen(), context);
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
}
