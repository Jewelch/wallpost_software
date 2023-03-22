import 'package:flutter/cupertino.dart';

import 'restaurant_loader_container.dart';

class SalesBreakDownLoader extends StatelessWidget {
  const SalesBreakDownLoader({
    Key? key,
    this.count = 5,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      RestaurantLoaderContainer(
        height: 60,
        topRadius: 16,
        width: double.infinity,
      ),
      SizedBox(height: 1),
      ...List.generate(
        count,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 1),
          child: RestaurantLoaderContainer(
            height: 60,
            width: double.infinity,
          ),
        ),
      ),
      RestaurantLoaderContainer(
        height: 60,
        bottomRadius: 16,
        width: double.infinity,
        onBottom: true,
      ),
    ]);
  }
}
