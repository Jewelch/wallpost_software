import 'package:flutter/material.dart';

import '../../_common_widgets/filter_views/custom_filter_chip.dart';
import '../../_shared/constants/app_colors.dart';

class FinanceHorizontalTab extends StatefulWidget{
  final VoidCallback onCashPressed,onInvoicePressed,onBillPressed;

   FinanceHorizontalTab({ required this.onCashPressed, required this.onInvoicePressed, required this.onBillPressed});

  @override
  State<FinanceHorizontalTab> createState() => _FinanceHorizontalTabState(onCashPressed,onInvoicePressed,onBillPressed);
}

class _FinanceHorizontalTabState extends State<FinanceHorizontalTab> {
  int _selectedIndex =0;
  final VoidCallback onCashPressed,onInvoicePressed,onBillPressed;

  _FinanceHorizontalTabState(this.onCashPressed, this.onInvoicePressed, this.onBillPressed);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return buildList();
  }

  Widget buildList() {
    return  SizedBox(
        height: 32,
        child:ListView.separated(
      scrollDirection: Axis.horizontal,
      shrinkWrap: true,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return CustomFilterChip(
            backgroundColor: (index==_selectedIndex)?AppColors.defaultColor:Colors.transparent,
            borderColor: Colors.transparent,
            title: Text(
               gettabTittle(index),
              style: TextStyle(
                color: (index==_selectedIndex)?Colors.white:AppColors.defaultColor,
                fontSize: 17,
                fontWeight: FontWeight.w500,
              ),
            ),
            onPressed: () => {

              _selectedIndex =index,
              if(_selectedIndex==0) onCashPressed
              else if(_selectedIndex==1)onInvoicePressed
              else if(_selectedIndex==2)onBillPressed,

            setState(() {
            })
            });
      },
      separatorBuilder: ((_, __) => SizedBox(width: 16)),
      itemCount: 3,
    ));
  }

  String gettabTittle(int index) {
    if(index==0) return "Cash";
    if(index==1) return "Invoices";
    if(index==2) return "Bills";
    return "";
  }
}