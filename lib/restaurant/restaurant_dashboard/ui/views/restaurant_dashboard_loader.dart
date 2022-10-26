import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

class RestaurantDashboardLoader extends StatelessWidget {
  const RestaurantDashboardLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        children: [
          _appBar(context),
          _tile(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
          ),
          _tile(context),
          SizedBox(
            height: 16,
          ),
          cards(context),
          SizedBox(
            height: 16,
          ),
          cards(context),
          SizedBox(
            height: 16,
          ),
          cards(context),
          SizedBox(
            height: 16,
          ),
          cards(context),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _emptyContainer(height: 18, cornerRadius: 6),
          _emptyContainer(height: 18, cornerRadius: 6),
        ],
      ),
    );
  }

  Widget cards(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * .1,
            width: MediaQuery.of(context).size.width * .4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * .1,
            width: MediaQuery.of(context).size.width * .4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          _emptyContainer(height: 40, width: 40, cornerRadius: 10),
          SizedBox(width: 40),
          Expanded(child: _emptyContainer(height: 26, cornerRadius: 6)),
          SizedBox(width: 40),
          _emptyContainer(height: 40, width: 40, cornerRadius: 10),
        ],
      ),
    );
  }

  _emptyContainer({required double height, double width = 80, required double cornerRadius}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
    );
  }
}
