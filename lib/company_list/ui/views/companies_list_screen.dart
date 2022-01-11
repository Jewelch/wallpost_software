import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar_with_title.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_wp_core/company_management/entities/company_list_item.dart';
import 'package:wallpost/company_list/ui/contracts/company_list_view.dart';
import 'package:wallpost/company_list/ui/presenters/companies_list_presenter.dart';
import 'package:wallpost/company_list/ui/views/company_list_card_with_revenue.dart';
import 'package:wallpost/company_list/ui/views/company_list_card_without_revenue.dart';

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
  static const LOADER_VIEW = 0;
  static const COMPANIES_VIEW = 1;
  static const NO_COMPANIES_VIEW = 2;
  static const NO_SEARCH_RESULTS_VIEW = 3;
  static const ERROR_VIEW = 4;

  @override
  void initState() {
    presenter = CompaniesListPresenter(this);
    presenter.getCompanies();
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
            CircularIconButton(
                iconName: 'assets/icons/menu_icon.svg',
                iconSize: 12,
                onPressed: () => {
                      // ScreenPresenter.present(
                      //   LeftMenuScreen(),
                      //   context,
                      //   slideDirection: SlideDirection.fromLeft,
                      // )
                    })
          ],
        ),
        body: SafeArea(
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
                    if (value == LOADER_VIEW) {
                      return Expanded(child: _loader());
                    } else if (value == COMPANIES_VIEW) {
                      return Expanded(child: _getCompanies());
                    } else if (value == NO_COMPANIES_VIEW) {
                      return Expanded(child: _noCompaniesMessageView());
                    } else if (value == NO_SEARCH_RESULTS_VIEW) {
                      return Expanded(child: _noSearchResultsMessageView());
                    }
                    return Expanded(child: _buildErrorAndRetryView());
                  })
              // _buildErrorAndRetryView()
            ]),
          ),
        ),
      ),
    );
  }

  Widget _searchBar() {
    return ItemNotifiable<bool>(
      notifier: _searchBarVisibilityNotifier,
      builder: (context, shouldShowSearchBar) {
        if (shouldShowSearchBar == true) {
          return SearchBarWithTitle(
            title: 'Companies',
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
          onRefresh: () => presenter.getCompanies(),
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

  Widget _loader() {
    return Container(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _noCompaniesMessageView() {
    return GestureDetector(
      onTap: () => presenter.getCompanies(),
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
    if (companyList[index].shouldShowRevenue) {
      return CompanyListCardWithRevenue(
        company: companyList[index],
        onPressed: () => {
          _selectCompanyAtIndex(index),
        },
      );
    } else
      return CompanyListCardWithOutRevenue(
        company: companyList[index],
        onPressed: () => {
          _selectCompanyAtIndex(index),
        },
      );
  }

  void _selectCompanyAtIndex(int index) async {
    // var selectedCompany = _filterList[index];
    // await loader.show('');
    // try {
    //   var _ =
    //       await CompanyDetailsProvider().getCompanyDetails(selectedCompany.id);
    //   await loader.hide();
    //   Navigator.pushNamedAndRemoveUntil(
    //       context, RouteNames.dashboard, (route) => false);
    // } on WPException catch (e) {
    //   await loader.hide();
    //   Alert.showSimpleAlert(
    //     context,
    //     title: 'Failed To Load Company Details',
    //     message: e.userReadableMessage,
    //     buttonTitle: 'Okay',
    //   );
    // }
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewSelectorNotifier.notify(LOADER_VIEW);
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
}
