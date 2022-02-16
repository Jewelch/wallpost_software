// import 'dart:convert';
//
// import 'package:sift/sift.dart';
// import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
// import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
// import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
//
//
// class CompaniesGroup extends JSONInitializable implements JSONConvertible {
//   late num _groupId;
//   late String _name;
//   late String _defaultCurrency;
//   late num _isDefault;
//   List<Company> _companies = [];
//   late GroupSummary _groupSummary;
//
//   CompaniesGroup.fromJson(Map<String, dynamic> jsonMap)
//       : super.fromJson(jsonMap) {
//     var sift = Sift();
//
//     try {
//       _groupId = sift.readNumberFromMap(jsonMap, 'group_id');
//       _name = sift.readStringFromMap(jsonMap, 'name');
//       _defaultCurrency = sift.readStringFromMap(jsonMap, 'default_currency');
//       _isDefault = sift.readNumberFromMap(jsonMap, 'is_default');
//       _groupSummary =
//           GroupSummary.fromJson(sift.readMapFromMap(jsonMap, 'group_summary'));
//       sift
//           .readMapListFromMapWithDefaultValue(jsonMap, 'companies', null)
//           ?.forEach((v) {
//         _companies.add(Company.fromJson(v));
//       });
//     } on SiftException catch (e) {
//       print(e.errorMessage);
//       throw MappingException(
//           'Failed to cast Dashboard response. Error message - ${e.errorMessage}');
//     }
//   }
//
//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> jsonMap = {
//       'group_id': _groupId,
//       'name': _name,
//       'default_currency': _defaultCurrency,
//       'is_default': _isDefault,
//       'group_summary': _groupSummary,
//       'companies': _companies,
//     };
//     return jsonMap;
//   }
//
//   num get groupId => _groupId;
//
//   String get name => _name;
//
//   String get defaultCurrency => _defaultCurrency;
//
//   num get isDefault => _isDefault;
//
//   List<Company> get companies => _companies;
//
//   GroupSummary get groupSummary => _groupSummary;
// }
//
// class Company extends JSONInitializable implements JSONConvertible {
//   late num _companyId;
//   late String _companyName;
//   late num _notifications;
//   late num _approvalCount;
//   late String _avatar;
//   late FinancialSummary _financialSummary;
//
//   Company.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
//     var sift = Sift();
//     try {
//       _companyId = sift.readNumberFromMap(jsonMap, 'company_id');
//       _companyName = sift.readStringFromMap(jsonMap, 'company_name');
//       _notifications = sift.readNumberFromMap(jsonMap, 'notifications');
//       _approvalCount = sift.readNumberFromMap(jsonMap, 'approval_count');
//       _avatar = 'https://placeimg.com/640/480/any';
//       _financialSummary = FinancialSummary.fromJson(
//           sift.readMapFromMap(jsonMap, 'financial_summary'));
//     } on SiftException catch (e) {
//       print(e.errorMessage);
//       throw MappingException(
//           'Failed to cast Company response. Error message - ${e.errorMessage}');
//     }
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> jsonMap = {
//       'company_id': _companyId,
//       'company_name': _companyName,
//       'notifications': _notifications,
//       'approval_count': _approvalCount,
//       'financial_summary': _financialSummary,
//       'avatar': _avatar,
//     };
//     return jsonMap;
//   }
//
//   num get companyId => _companyId;
//
//   String get companyName => _companyName;
//
//   num get notifications  => _notifications;
//
//   num get approvalCount => _approvalCount;
//
//   String get  avatar  => _avatar ;
//
//   FinancialSummary get financialSummary => _financialSummary;
//
//
// }
//
// class GroupSummary extends JSONInitializable implements JSONConvertible {
//   late num _cashAvailability;
//   late num _receivableOverdue;
//   late num _payableOverdue;
//   late num _profitLoss;
//
//   GroupSummary.fromJson(Map<String, dynamic> jsonMap)
//       : super.fromJson(jsonMap) {
//     var sift = Sift();
//     try {
//       _cashAvailability = sift.readNumberFromMapWithDefaultValue(
//           jsonMap, 'cashAvailability', 0)!;
//       _receivableOverdue = sift.readNumberFromMapWithDefaultValue(
//           jsonMap, 'receivableOverdue', 0)!;
//       _payableOverdue =
//           sift.readNumberFromMapWithDefaultValue(jsonMap, 'payableOverdue', 0)!;
//       _profitLoss =
//           sift.readNumberFromMapWithDefaultValue(jsonMap, 'profitLoss', 0)!;
//     } on SiftException catch (e) {
//       print(e.errorMessage);
//       throw MappingException(
//           'Failed to cast GroupSummary response. Error message - ${e.errorMessage}');
//     }
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> jsonMap = {
//       'cashAvailability': _cashAvailability,
//       'receivableOverdue': _receivableOverdue,
//       'payableOverdue': _payableOverdue,
//       'profitLoss': _profitLoss,
//     };
//     return jsonMap;
//   }
//
//   num get cashAvailability  => _cashAvailability;
//
//   num get receivableOverdue => _receivableOverdue;
//
//   num get payableOverdue  => _cashAvailability;
//
//   num get profitLoss => _receivableOverdue;
// }
//
// class FinancialSummary extends JSONInitializable implements JSONConvertible {
//   late String _currency;
//   late String _actualRevenueDisplay;
//   late num _overallRevenue;
//   late num _cashAvailability;
//   late num _receivableOverdue;
//   late num _payableOverdue;
//   late num _profitLoss;
//   late num _profitLossPerc;
//
//   FinancialSummary.fromJson(Map<String, dynamic> jsonMap)
//       : super.fromJson(jsonMap) {
//     var sift = Sift();
//     try {
//       _currency = sift.readStringFromMap(jsonMap, 'currency');
//       _actualRevenueDisplay =
//           sift.readStringFromMap(jsonMap, 'actual_revenue_display');
//       _overallRevenue = sift.readNumberFromMap(jsonMap, 'overall_revenue');
//       _cashAvailability = sift.readNumberFromMap(jsonMap, 'cashAvailability');
//       _receivableOverdue = sift.readNumberFromMap(jsonMap, 'receivableOverdue');
//       _payableOverdue = sift.readNumberFromMap(jsonMap, 'payableOverdue');
//       _profitLoss = sift.readNumberFromMap(jsonMap, 'profitLoss');
//       _profitLossPerc = sift.readNumberFromMap(jsonMap, 'profitLossPerc');
//     } on SiftException catch (e) {
//       print(e.errorMessage);
//       throw MappingException(
//           'Failed to cast Financial Summary response. Error message - ${e.errorMessage}');
//     }
//   }
//
//   @override
//   Map<String, dynamic> toJson() {
//     Map<String, dynamic> jsonMap = {
//       'currency': _currency,
//       'actual_revenue_display': _actualRevenueDisplay,
//       'overall_revenue': _overallRevenue,
//       'cashAvailability': _cashAvailability,
//       'receivableOverdue': _receivableOverdue,
//       'payableOverdue': _payableOverdue,
//       'profitLoss': _profitLoss,
//       'profitLossPerc': _profitLossPerc,
//     };
//     return jsonMap;
//   }
//   String get currency  => _currency;
//
//   String get actualRevenueDisplay  => _actualRevenueDisplay;
//
//   num get overallRevenue  => _overallRevenue;
//
//   num get cashAvailability  => _cashAvailability;
//
//   num get receivableOverdue => _receivableOverdue;
//
//   num get payableOverdue  => _payableOverdue;
//
//   num get profitLoss => _profitLoss;
//
//   num get profitLossPerc => _profitLossPerc;
// }
