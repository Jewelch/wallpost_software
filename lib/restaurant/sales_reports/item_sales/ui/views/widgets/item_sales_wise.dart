import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenter/item_sales_presenter.dart';
import 'item_sales_card.dart';

class ItemSalesWise extends StatefulWidget {
  ItemSalesWise(this._presenter);
  final ItemSalesPresenter _presenter;

  @override
  State<ItemSalesWise> createState() => _ItemSalesWiseState();
}

class _ItemSalesWiseState extends State<ItemSalesWise> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return ExpansionPanelList(
      elevation: 0,
      expansionCallback: (panelIndex, isExpanded) => setState(() => _isExpanded = !isExpanded),
      children: widget._presenter.itemSalesData.map((elemet) {
        return ExpansionPanel(
          backgroundColor: AppColors.screenBackgroundColor2,
          isExpanded: _isExpanded,
          canTapOnHeader: true,
          headerBuilder: ((context, isExpanded) => IntrinsicHeight(
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 24.0),
                      child: Text(
                        'Burgur',
                        //  _presenter.getCategoryName(1),
                        textAlign: TextAlign.right,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyles.largeTitleTextStyleBold
                            .copyWith(fontSize: 20.0, fontWeight: FontWeight.w500),
                      ),
                    ),
                    Spacer(),
                    Text(
                      widget._presenter.getSumRevenue(),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyles.largeTitleTextStyleBold.copyWith(fontSize: 20.0),
                    ),
                    Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "QAR",
                          style: TextStyles.headerCardSubLabelTextStyle
                              .copyWith(color: AppColors.textColorBlack),
                        )),
                  ],
                ),
              )),
          body: ItemSalesCard(widget._presenter),
        );
      }).tolist(),
    );
  }
}
