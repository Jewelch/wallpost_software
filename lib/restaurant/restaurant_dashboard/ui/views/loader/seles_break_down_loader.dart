import 'package:flutter/cupertino.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/loader/restaurant_dashboard_loader_container.dart';

class SalesBreakDownLoader extends StatelessWidget {
  const SalesBreakDownLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RestaurantContainerLoader(
          height: 60,
          cornerRadius: 16,
          width: double.infinity,
        ),
        SizedBox(height: 4),
        RestaurantContainerLoader(
          height: 60,
          cornerRadius: 16,
          width: double.infinity,
        ),
        SizedBox(height: 4),
        RestaurantContainerLoader(
          height: 60,
          cornerRadius: 16,
          width: double.infinity,
        ),
        SizedBox(height: 4),
        RestaurantContainerLoader(
          height: 60,
          cornerRadius: 16,
          width: double.infinity,
        ),
        SizedBox(height: 4),
        RestaurantContainerLoader(
          height: 60,
          cornerRadius: 16,
          width: double.infinity,
        ),
        SizedBox(height: 4),
        RestaurantContainerLoader(
          height: 40,
          width: double.infinity,
        ),
        SizedBox(height: 4),
        RestaurantContainerLoader(
          height: 40,
          width: double.infinity,
        ),
        SizedBox(height: 4),
        RestaurantContainerLoader(
          height: 40,
          width: double.infinity,
        ),
      ],
    );
  }
}
