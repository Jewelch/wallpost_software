/*
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/views/attendance_detail/attendance_detail_loader.dart';
import 'package:wallpost/finance/ui/finanace_cash_montly_list.dart';
import 'package:wallpost/finance/ui/finance_boxes_view.dart';
import 'package:wallpost/finance/ui/finance_cash_detail_aggregated_view.dart';
import 'package:wallpost/finance/ui/finance_inner_appbar.dart';
import 'package:wallpost/finance/ui/finance_tab_view.dart';
import 'package:wallpost/finance/ui/presenters/finance_dashboard_presenter.dart';
import 'package:wallpost/finance/ui/view_contracts/finance_dasbooard_view.dart';

import '../../../dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';



class FinanceDashBoardScreen extends StatefulWidget{
  const FinanceDashBoardScreen({Key? key}) : super(key: key);

  @override
  State<FinanceDashBoardScreen> createState() => _FinanceDashBoardScreenState();
}

class _FinanceDashBoardScreenState extends State<FinanceDashBoardScreen> implements FinanceDasBoardView{

  late final FinanceDasBoardPresenter presenter;
  final _viewTypeNotifier = ItemNotifier(defaultValue: LOADER_VIEW);
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const DATA_VIEW = 3;
  var _errorMessage = "";


  @override
  void initState() {
    presenter=FinanceDasBoardPresenter(this);
    presenter.loadFinanceDashBoardDetails();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: SimpleAppBar(
        title: "Company Name",
        leadingButton: RoundedBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: ItemNotifiable<int>(
          notifier: _viewTypeNotifier,
          builder: (context, viewType) {
            if (viewType == LOADER_VIEW) return AttendanceDetailLoader();

            if (viewType == ERROR_VIEW) return _errorAndRetryView();

            if (viewType == DATA_VIEW) return _dataView();

            return Container();
          },
        ),
      ),
    );

  }

  //MARK: Functions to build the error and retry view

  Widget _errorAndRetryView() {
    return _errorButton(title: _errorMessage, onPressed: () => presenter.loadFinanceDashBoardDetails());
  }

  Widget _errorButton({required String title, required VoidCallback onPressed}) {
    return Container(
      child: Center(
        child: TextButton(
          child: Text(title, textAlign: TextAlign.center, style: TextStyles.titleTextStyle),
          onPressed: onPressed,
        ),
      ),
    );
  }

  Widget _dataView(){
    return  Column(
        children: [
          FinanceBoxesView(),
       */
/*   _buildBottomTabView(),

          _buildMonthlyCashListView()*//*

          Stack(
            clipBehavior: Clip.none,

            children: [
            _buildBottomTabView(),
              Positioned(
                top: 230,
                  left: 0,
                  right: 0,

                  child: _buildMonthlyCashListView())
          ],)

        ],

    );
  }



  Widget _buildBottomTabView() {
    return  Padding(
      padding: const EdgeInsets.all(16.0),
      child: PerformanceViewHolder(
          content: Column(children: [
            FinanceHorizontalTab(),
            SizedBox(height: 15,),
            FinanceCashDetailAggregated(),
            SizedBox(height: 15,),

            _buildMonthlyCashListHeadView()

          ],),

      ),
    );


  }

  Widget _buildMonthlyCashListHeadView() {
    return Padding(
      padding: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 32),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap:() {

            },
            child: Row(
              children: [
                Container(
                    height: 15,
                    width: 20,
                    child: SvgPicture.asset('assets/icons/back_icon.svg',
                        width: 50, height: 50,color: AppColors.defaultColor,)),
                Text(
                  'Previous',
                  style: TextStyle(color: AppColors.defaultColor),
                ),
              ],
            ),
          ),
          Text('3 Months'),
          GestureDetector(
            onTap: () {

            },
            child: Row(
              children: [
                Text(
                  "Next",
                  style: TextStyle(color: AppColors.defaultColor),
                ),
                Container(
                    height: 15,
                    width: 20,
                    child: SvgPicture.asset('assets/icons/arrow_right_icon.svg',
                        width: 20, height: 15,color: AppColors.defaultColor,)),
              ],
            ),
          )
        ],
      ),
    );
  }

  _buildMonthlyCashListView() {
    return Padding(
      padding: const EdgeInsets.only(left: 16,right: 16),
      child: Container( height:230 ,child: PerformanceViewHolder(content: FinanceCashMonthlyList())),
    );
  }

  @override
  void showErrorAndRetryView(String message) {
    // TODO: implement showErrorAndRetryView
  }

  @override
  void showLoader() {
    _viewTypeNotifier.notify(LOADER_VIEW);
  }

  @override
  void onDidLoadFinanceDashBoardData() {
    _viewTypeNotifier.notify(DATA_VIEW);
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key? key,
  }) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return FinanceDetailAppBar(
      companyName:"Company name",
      onLeftMenuButtonPress: () => {},
      onAddButtonPress: () {},
      leadingButton: RoundedBackButton(backgroundColor: Colors.white,
          iconColor: AppColors.defaultColor,
          onPressed: () => Navigator.pop(context)),
      onTitlePress: () => Navigator.pop(context),
    );
  }
}*/
