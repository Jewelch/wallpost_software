// import 'package:flutter/material.dart';
// import 'package:wallpost/approvals/entities/attendance_adjustment_approval.dart';
// import '../../../../../_common_widgets/text_styles/text_styles.dart';
// import '../../../../constants/dashboard_colors.dart';
//
// class AttendanceAdjustmentApprovalTile extends StatelessWidget {
//   final AttendanceAdjustmentApproval _approval;
//
//   AttendanceAdjustmentApprovalTile(this._approval);
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(10.0),
//       child: Container(
//         decoration: BoxDecoration(
//             border: Border.all(
//               color: DashboardColors.portalItemRedColor.withOpacity(0.6),
//             ),
//             color: DashboardColors.portalItemRedColor.withOpacity(0.6),
//             borderRadius: BorderRadius.all(Radius.circular(20))),
//         height: 180,
//         width: 140,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0, left: 20.0),
//               child: Text(
//                 "Attendance Adjustment",
//                 style: TextStyles.subTitleTextStyle
//                     .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 5),
//             Padding(
//               padding: const EdgeInsets.only(top: 8.0, left: 16.0),
//               child: Text(
//                 "by",
//                 style: TextStyles.titleTextStyle.copyWith(color: Colors.white),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(left: 16.0),
//               child: Text(
//                 _approval.name,
//                 style: TextStyles.subTitleTextStyle.copyWith(
//                     color: Colors.white,
//                     fontWeight: FontWeight.bold,
//                     fontSize: 13.0),
//               ),
//             ),
//             SizedBox(height: 5),
//             Padding(
//               padding: const EdgeInsets.only(bottom: 8.0, left: 16.0),
//               child: Text(
//                 _approval.reason,
//                 style: TextStyles.subTitleTextStyle
//                     .copyWith(color: Colors.white, fontWeight: FontWeight.bold),
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
