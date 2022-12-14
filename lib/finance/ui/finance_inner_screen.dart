// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
//
// import '../../_common_widgets/buttons/rounded_back_button.dart';
// import '../../_shared/constants/app_colors.dart';
// import '../../dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';
// import 'finanace_cash_montly_list.dart';
// import 'finance_boxes_view.dart';
// import 'finance_cash_detail_aggregated_view.dart';
// import 'finance_inner_appbar.dart';
// import 'finance_tab_view.dart';
//
// class FinanceInnerScreen extends StatelessWidget{
//   const FinanceInnerScreen({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           _AppBar(),
//           FinanceBoxesView(),
//        /*   _buildBottomTabView(),
//
//           _buildMonthlyCashListView()*/
//           Stack(
//             clipBehavior: Clip.none,
//
//             children: [
//             _buildBottomTabView(),
//               Positioned(
//                 top: 230,
//                   left: 0,
//                   right: 0,
//
//                   child: _buildMonthlyCashListView())
//           ],)
//
//         ],
//       ),
//     );
//   }
//
//   Widget _buildBottomTabView() {
//     return  Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: PerformanceViewHolder(
//           content: Column(children: [
//             FinanceHorizontalTab(),
//             SizedBox(height: 15,),
//             FinanceCashDetailAggregated(),
//             SizedBox(height: 15,),
//
//             _buildMonthlyCashListHeadView()
//
//           ],),
//
//       ),
//     );
//
//
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
//                         width: 50, height: 50,color: AppColors.defaultColor,)),
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
//                         width: 20, height: 15,color: AppColors.defaultColor,)),
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