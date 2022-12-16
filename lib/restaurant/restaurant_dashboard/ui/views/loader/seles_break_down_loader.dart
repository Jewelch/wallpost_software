import 'package:flutter/cupertino.dart';

import 'restaurant_dashboard_loader_container.dart';

class SalesBreakDownLoader extends StatelessWidget {
  const SalesBreakDownLoader({
    Key? key,
    this.count = 5,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RestaurantContainerLoader(
        height: 60,
        topRadius: 16,
        width: double.infinity,
      ),
      SizedBox(height: 1),
      ...List.generate(
        count,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 1),
          child: RestaurantContainerLoader(
            height: 60,
            width: double.infinity,
          ),
        ),
      ),
      RestaurantContainerLoader(
        height: 60,
        bottomRadius: 16,
        width: double.infinity,
        onBottom: true,
      ),
    ]);
  }
}
