import 'package:flutter/cupertino.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/views/loader/item_sales_loader_container.dart';

class ItemWiseLoader extends StatelessWidget {
  const ItemWiseLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ItemSalesContainerLoader(
          height: 60,
          topRadius: 16,
          width: double.infinity,
        ),
        SizedBox(height: 4),
        ItemSalesContainerLoader(
          height: 60,
          width: double.infinity,
        ),
        SizedBox(height: 4),
        ItemSalesContainerLoader(
          height: 60,
          width: double.infinity,
        ),
        SizedBox(height: 4),
        ItemSalesContainerLoader(
          height: 60,
          width: double.infinity,
        ),
        SizedBox(height: 4),
        ItemSalesContainerLoader(
          height: 60,
          bottomRadius: 16,
          width: double.infinity,
          onBottom: true,
        ),
      ],
    );
  }
}
