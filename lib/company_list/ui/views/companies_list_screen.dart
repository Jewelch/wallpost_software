import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
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

class _CompanyListScreenState extends State<CompanyListScreen>
    implements CompaniesListView {
  late CompaniesListPresenter presenter;
  var _showErrorNotifier = ItemNotifier<bool>();
  var _companiesListNotifier = ItemNotifier<List<CompanyListItem>?>();
  var _viewSelectorNotifier = ItemNotifier<int>();
  var _scrollController = ScrollController();

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
              SearchBarWithTitle(
                title: 'Companies',
                onChanged: (searchText) => presenter.performSearch(searchText),
              ),
              ItemNotifiable<int>(
                  notifier: _viewSelectorNotifier,
                  builder: (context, value) {
                    if (value == LOADER_VIEW) {
                      return Expanded(child: _loader());
                    } else if (value == COMPANIES_VIEW) {
                      return Expanded(child: _getCompanies());
                    } else if (value == NO_COMPANIES_VIEW) {
                      return Expanded(child: _noCompaniesMessage());
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
            )),
      ),
    );
  }

  Widget _loader() {
    return Container(
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _noCompaniesMessage() {
    return Container(
      child: Center(child: Text("No companies Available")),
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
                        'Failed to load companies\nTap Here To Retry',
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

  // void _getCompanies() async {
  //   try {
  //     var companies = await _companiesListProvider.get();
  //     setState(() {
  //       _companies.addAll(companies);
  //       _filterList.addAll(companies);
  //     });
  //   } on WPException catch (error) {
  //     // Alert.showSimpleAlert(
  //     //   context,
  //     //   title: 'Failed To Load Companies',
  //     //   message: error.userReadableMessage,
  //     //   buttonTitle: 'Okay',
  //     // );
  //     // setState(() {});
  //   }
  // }

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

  @override
  void showLoader() {
    _viewSelectorNotifier.notify(LOADER_VIEW);
  }

  @override
  void companiesRetrievedSuccessfully(List<CompanyListItem> companies) {
    _companiesListNotifier.notify(companies);
    _viewSelectorNotifier.notify(COMPANIES_VIEW);
  }

  @override
  void companiesRetrievedSuccessfullyWithEmptyList() {
    _viewSelectorNotifier.notify(NO_COMPANIES_VIEW);
  }

  @override
  void companiesRetrievedError(String title, String message) {
    _showErrorNotifier.notify(true);
    _viewSelectorNotifier.notify(ERROR_VIEW);

    //Alert.showSimpleAlert(context: context, title: title, message: message);
  }


}
