import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/company_list_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar_with_title.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_main/services/logout_handler.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_list/entities/company_group.dart';
import 'package:wallpost/company_list/entities/company_list_item.dart';
import 'package:wallpost/company_list/entities/financial_summary.dart';
import 'package:wallpost/company_list/ui/presenters/companies_list_presenter.dart';
import 'package:wallpost/company_list/ui/view_contracts/company_list_view.dart';
import 'package:wallpost/company_list/ui/views/ShimmerEffect.dart';
import 'package:wallpost/company_list/ui/views/company_list_card.dart';
import 'package:wallpost/dashboard/ui/dashboard_screen.dart';

class CompanyListScreen extends StatefulWidget {
  @override
  _CompanyListScreenState createState() => _CompanyListScreenState();
}

class _CompanyListScreenState extends State<CompanyListScreen>
    implements CompaniesListView {
  late CompaniesListPresenter presenter;
  var _searchBarVisibilityNotifier = ItemNotifier<bool>();
  var _showErrorNotifier = ItemNotifier<bool>();
  var _companiesListNotifier = ItemNotifier<List<CompanyListItem>>();
  var _selectedCompanyNotifier = ItemNotifier<CompanyListItem>();
  var _groupSummary = ItemNotifier<FinancialSummary>();
  var _viewSelectorNotifier = ItemNotifier<int>();
  var _viewAppBarSelectorNotifier = ItemNotifier<bool>();
  var _profileImageUrl = ItemNotifier<String>();
  var _companyGroups = ItemNotifier<List<CompanyGroup>>();
  var _tappedIndexNotifier = ItemNotifier<int>();
  var _scrollController = ScrollController();

  String _noCompaniesMessage = "";
  String _noSearchResultsMessage = "";
  String _errorMessage = "";
  static const COMPANIES_VIEW = 1;
  static const NO_COMPANIES_VIEW = 2;
  static const NO_SEARCH_RESULTS_VIEW = 3;
  static const ERROR_VIEW = 4;
  static const SHIMMER_LOADING = 5;
  late Loader loader;

  @override
  void initState() {
    presenter = CompaniesListPresenter(this);
    presenter.loadCompanies();
    presenter.getProfileImageUrl();
    loader = Loader(context);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return OnTapKeyboardDismisser(
      //  scrollController: _scrollController,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: <Widget>[
          ItemNotifiable<bool>(
              notifier: _viewAppBarSelectorNotifier,
              builder: (context, view) {
                if (view == true) {
                  return searchContainer();
                }
                return _appBar();
              }),
          _summary(),
          Expanded(
              child: Container(
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            child: Column(children: [
              ItemNotifiable<int>(
                  notifier: _viewSelectorNotifier,
                  builder: (context, value) {
                    if (value == COMPANIES_VIEW || value == SHIMMER_LOADING) {
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

  Widget _leadingButton() {
    return Container(
        child: ItemNotifiable<String>(
            notifier: _profileImageUrl,
            builder: (context, imageUrl) {
              return FadeInImage.assetNetwork(
                placeholder: 'assets/logo/logo.png',
                image: imageUrl!,
                fit: BoxFit.cover,
              );
            }));
  }

  searchContainer() {
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
                            _tappedIndexNotifier.notify(null),
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
                  notifier: _companyGroups,
                  builder: (context, companiesGroup) {
                    if ((companiesGroup != null) &&
                        (companiesGroup.isNotEmpty)) {
                      return Container(
                          height: 40,
                          child: ItemNotifiable<int>(
                              notifier: _tappedIndexNotifier,
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

  Widget _groupElement(
      int index, int? tappedIndex, List<CompanyGroup> companiesGroup) {
    return Container(
        margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
        child: ItemNotifiable<String>(
            notifier: _profileImageUrl,
            builder: (context, imageUrl) {
              return ActionChip(
                elevation: 2,
                label: Text(companiesGroup[index].name),
                labelStyle: TextStyle(color: Colors.blue[800]),
                backgroundColor: AppColors.backGroundColor,
                side: BorderSide(
                    color: tappedIndex == index
                        ? Colors.blue.shade800
                        : Colors.transparent,
                    width: 1,
                    style: BorderStyle.solid),
                onPressed: () {
                  _tappedIndexNotifier.notify(index);
                  presenter.showGroup(index);
                },
              );
            }));
  }

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
                    color: Colors.blue,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
            ),
          );
        });
  }

  Widget _summary() {
    return ItemNotifiable<FinancialSummary>(
        notifier: _groupSummary,
        builder: (context, summary) {
          if (summary != null) {
            return Container(
                margin: EdgeInsets.fromLTRB(0, 0, 20, 0), child: card(summary));
          } else
            return Container();
        });
  }

  Widget card(FinancialSummary summary) {
    return Stack(
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
          Container(
            child: RotatedBox(
                quarterTurns: 2,
                child: Container(
                  width: double.infinity,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: new BorderRadius.vertical(
                      top: Radius.elliptical(150, 30),
                    ),
                  ),
                )),
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                  Colors.blue.shade800,
                  Colors.transparent,
                ],
                    stops: [
                  0.0,
                  0.9
                ],
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                    tileMode: TileMode.repeated)),
          ),
          ClipRRect(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(26),
                  bottomRight: Radius.circular(26)),
              child: Container(
                color: Colors.blue[800],
                width: double.infinity,
                height: 200,
              )),
          Container(
            decoration: new BoxDecoration(
                gradient: new LinearGradient(
                    colors: [
                  Colors.blue.shade800,
                  Colors.transparent,
                ],
                    stops: [
                  0.0,
                  0.9
                ],
                    begin: FractionalOffset.centerLeft,
                    end: FractionalOffset.centerRight,
                    tileMode: TileMode.repeated)),
            child: Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: new BorderRadius.vertical(
                    top: Radius.elliptical(150, 30),
                  ),
                )),
          ),
        ]),
        Column(
          children: <Widget>[
            Row(children: [
              Expanded(
                  flex: 5,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 30, 0, 0),
                      child: Text(
                        "Summary",
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          fontSize: 30.0,
                        ),
                      ))),
              Expanded(
                  flex: 5,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      droppedDownItem("YTD"),
                      droppedDownItem("2022")
                    ],
                  ))
            ]),
            SizedBox(height: 8),
            Row(children: [
              Expanded(
                  flex: 4,
                  child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 0, 0, 0),
                      child: Text(
                        "Profit & Loss",
                        style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: Colors.grey[400],
                          fontSize: 16.0,
                        ),
                      ))),
              Expanded(
                  flex: 6,
                  child: Center(
                      child: Text(
                    summary.overallRevenue.toString(),
                    style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.green,
                        fontSize: 28.0,
                        overflow: TextOverflow.ellipsis),
                  ))),
            ]),
            SizedBox(height: 6),
            Padding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                          flex: 3,
                          child: summaryElement(
                              "Fund Availability",
                              Colors.green,
                              summary.cashAvailability.toString())),
                      SizedBox.fromSize(size: Size(10, 0)),
                      Expanded(
                          flex: 3,
                          child: summaryElement(
                              "Receivables Overdue",
                              Colors.red,
                              summary.receivableOverdue.toString())),
                      SizedBox.fromSize(size: Size(10, 0)),
                      Expanded(
                          flex: 3,
                          child: summaryElement("Payables Overdue", Colors.red,
                              summary.payableOverdue.toString())),
                    ])),
          ],
        )
      ],
    );
  }

  Widget summaryElement(String label, Color color, String value) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 20),
        child: Column(
          children: [
            Divider(color: Colors.grey[400]),
            Text(
              value,
              style: TextStyle(
                fontWeight: FontWeight.w700,
                color: color,
                fontSize: 18.0,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w300,
                color: Colors.grey[400],
                fontSize: 11.0,
                overflow: TextOverflow.ellipsis,
              ),
            )
          ],
        ));
  }

  Widget droppedDownItem(String label) {
    return Padding(
        padding: const EdgeInsets.fromLTRB(0, 40, 0, 0),
        child: Row(children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
          CircularIconButton(
            iconName: 'assets/icons/down_arrow_icon.svg',
            iconSize: 12,
          )
        ]));
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


  Widget _getCompanies() {
    return ItemNotifiable<List<CompanyListItem>>(
        notifier: _companiesListNotifier,
        builder: (context, value) {
          if (value == null) {
            return ListView.builder(
                itemBuilder: (_, __) => _shimmerList());
          } else
            return Container(
              child: RefreshIndicator(
                onRefresh: () => presenter.refreshCompanies(),
                child: ListView.separated(
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: _scrollController,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return _getCompanyCard(index, value);
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider();
                  },
                ),
              ),
            );
        });
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
    return CompanyListCard(
        company: companyList[index],
        onPressed: () {
          presenter.selectCompanyAtIndex(index);
        });
  }


  Widget _shimmerList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 16.0, 0.0, 16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(flex: 2, child: _shimmerAvatar()),
                SizedBox(width: 20),
                Expanded(flex: 3, child: _shimmerTileElement()),
                SizedBox(width: 20),
                Expanded(flex: 3, child: _shimmerTileElement()),
              ],
            )),
      ],
    );
  }

  Widget _shimmerTileElement() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          ListShimmerEffect(
              height: 12,
              width: MediaQuery.of(context).size.width * 0.35,
              widget: Container(color: Colors.black)),
          SizedBox(height: 10),
          ListShimmerEffect(
              height: 12,
              width: MediaQuery.of(context).size.width * 0.35,
              widget: Container(color: Colors.black))
        ]);
  }

  Widget _shimmerAvatar() {
    return ListShimmerEffect(
        height: 80,
        width: 70,
        widget: Container(
          padding: EdgeInsets.all(2), // Border width
          decoration: BoxDecoration(
              color: AppColors.primaryContrastColor,
              borderRadius: BorderRadius.circular(20)),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: SizedBox.fromSize(
              size: Size.fromRadius(44), // Image radius
            ),
          ),
        ));
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewSelectorNotifier.notify(SHIMMER_LOADING);
  }

  @override
  void hideLoader() {}

  @override
  void showSearchBar() {
    _searchBarVisibilityNotifier.notify(true);
  }

  @override
  void hideSearchBar() {
    _searchBarVisibilityNotifier.notify(false);
  }

  @override
  void showSelectedCompany(CompanyListItem company) {
    _selectedCompanyNotifier.notify(company);
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
  void showProfileImage(String url) {
    _profileImageUrl.notify(url);
  }

  @override
  void showSummary(FinancialSummary groupSummary) {
    _groupSummary.notify(groupSummary);
  }

  @override
  void showCompanyGroups(List<CompanyGroup> companyGroups) {
    _companyGroups.notify(companyGroups);
  }
}
