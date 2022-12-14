import 'package:flutter/material.dart';
import 'package:wallpost/finance/ui/presenters/finance_dashboard_presenter.dart';

import '../../_common_widgets/filter_views/custom_filter_chip.dart';
import '../../_shared/constants/app_colors.dart';

class FinanceHorizontalTab extends StatefulWidget{
  final VoidCallback onPressed;
  final FinanceDasBoardPresenter _presenter;

  //FinanceHorizontalTab(this._presenter);
  FinanceHorizontalTab( this._presenter, this.onPressed );




  @override
  State<StatefulWidget> createState() {
    return _FinanceHorizontalTabState( );
  }}

class _FinanceHorizontalTabState extends State<FinanceHorizontalTab> {



  int _selectedIndex =0;

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
              widget._presenter.selectModuleAtIndex(index),
              widget.onPressed.call(),
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