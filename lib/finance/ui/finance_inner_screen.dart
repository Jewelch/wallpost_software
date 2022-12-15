// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:wallpost/finance/ui/presenters/finance_dashboard_presenter.dart';
// import 'package:wallpost/finance/ui/view_contracts/finance_dasbooard_view.dart';
//
// import '../../_common_widgets/buttons/rounded_back_button.dart';
// import '../../_common_widgets/text_styles/text_styles.dart';
// import '../../_shared/constants/app_colors.dart';
// import '../../dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';
// import 'bill_view.dart';
// import 'finanace_cash_montly_list.dart';
// import 'finance_boxes_view.dart';
// import 'finance_cash_detail_aggregated_view.dart';
// import 'finance_inner_appbar.dart';
// import 'finance_tab_view.dart';
// import 'invoice_view.dart';
//
// class FinanceInnerScreen extends StatefulWidget {
//   const FinanceInnerScreen({Key? key}) : super(key: key);
//
//   @override
//   State<FinanceInnerScreen> createState() => _FinanceInnerScreenState();
//
//
// }
//
// class _FinanceInnerScreenState extends State<FinanceInnerScreen> implements FinanceDasBoardView {
//   late final FinanceDasBoardPresenter presenter;
//
//
//   @override
//   void initState() {
//     presenter=FinanceDasBoardPresenter(this);
//     presenter.loadFinanceDashBoardDetails();
//     super.initState();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           _AppBar(),
//           FinanceBoxesView(),
//           Stack(
//             clipBehavior: Clip.none,
//
//             children: [
//             _buildBottomTabView(),
//               if(presenter.selectedModuleIndex==0)
//               Positioned(
//                 top: 230,
//                   left: 0,
//                   right: 0,
//
//                   child: _buildMonthlyCashListView()),
//               if(presenter.selectedModuleIndex==1)
//                 Positioned(
//                     top: 120,
//                     left: 0,
//                     right: 0,
//
//                     child: _buildInvoiceView()),
//               if(presenter.selectedModuleIndex==2)
//                 Positioned(
//                     top: 120,
//                     left: 0,
//                     right: 0,
//
//                     child: _buildBillView())
//
//           ],)
//
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBottomTabView() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: PerformanceViewHolder(
//         content: Column(
//           children: [
//             FinanceHorizontalTab(presenter, () {
//               setState(() {});
//             }),
//             if (presenter.selectedModuleIndex == 0) getCashView(),
//             if (presenter.selectedModuleIndex == 1) getInvoiceView(),
//             if (presenter.selectedModuleIndex == 2) getBillView(),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget getCashView(){
//
//     return Column(children: [
//       SizedBox(height: 15,),
//       FinanceCashDetailAggregated(),
//       SizedBox(height: 15,),
//
//       _buildMonthlyCashListHeadView(),
//       SizedBox(height: 15,),
//
//     ],);
//   }
//   getInvoiceView() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16,bottom: 32),
//       child: Text('Invoices To Collect',style: TextStyles.extraLargeTitleTextStyleBold,
//       ),
//     );
//   }
//   getBillView() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 16,bottom: 32),
//       child: Text('Bills To Pay',style: TextStyles.extraLargeTitleTextStyleBold,),
//     );
//   }
//
//   Widget _buildMonthlyCashListHeadView() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16,right: 16,top: 16,bottom: 32),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap:() {
//
//             },
//             child: Row(
//               children: [
//                 Container(
//                     height: 15,
//                     width: 20,
//                     child: SvgPicture.asset('assets/icons/back_icon.svg',
//                       width: 50, height: 50,color: AppColors.defaultColor,)),
//                 Text(
//                   'Previous',
//                   style: TextStyle(color: AppColors.defaultColor),
//                 ),
//               ],
//             ),
//           ),
//           Text('3 Months'),
//           GestureDetector(
//             onTap: () {
//
//             },
//             child: Row(
//               children: [
//                 Text(
//                   "Next",
//                   style: TextStyle(color: AppColors.defaultColor),
//                 ),
//                 Container(
//                     height: 15,
//                     width: 20,
//                     child: SvgPicture.asset('assets/icons/arrow_right_icon.svg',
//                       width: 20, height: 15,color: AppColors.defaultColor,)),
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
//
//   _buildMonthlyCashListView() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16,right: 16),
//       child: Container( height:230 ,child: PerformanceViewHolder(content: FinanceCashMonthlyList())),
//     );
//   }
//   _buildInvoiceView() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16,right: 16),
//       child: Container( height:180 ,child: PerformanceViewHolder(content: InVoiceBoxView())),
//     );
//   }
//   _buildBillView() {
//     return Padding(
//       padding: const EdgeInsets.only(left: 16,right: 16),
//       child: Container( height:180 ,child: PerformanceViewHolder(content: BillBoxView())),
//     );
//   }
//
//   @override
//   void onDidLoadFinanceDashBoardData() {
//     // TODO: implement onDidLoadFinanceDashBoardData
//   }
//
//   @override
//   void showErrorAndRetryView(String message) {
//     // TODO: implement showErrorAndRetryView
//   }
//
//   @override
//   void showLoader() {
//     // TODO: implement showLoader
//   }
//
// }
//
// class _AppBar extends StatelessWidget {
//   const _AppBar({
//     Key? key,
//   }) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return FinanceDetailAppBar(
//       companyName:"Company name",
//       onLeftMenuButtonPress: () => {},
//       onAddButtonPress: () {},
//       leadingButton: RoundedBackButton(backgroundColor: Colors.white,
//           iconColor: AppColors.defaultColor,
//           onPressed: () => Navigator.pop(context)),
//       onTitlePress: () => Navigator.pop(context),
//     );
//   }
// }