import 'package:flutter/material.dart';

import '../../../../../_common_widgets/shimmer/shimmer_effect.dart';

class CrmDashboardLoader extends StatelessWidget {
  const CrmDashboardLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        children: [
          SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          _tile(context),
          _customChips(),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(children: [
              _container(
                height: 60,
                topRadius: 16,
                width: double.infinity,
              ),
              SizedBox(height: 1),
              ...List.generate(
                8,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 1),
                  child: _container(
                    height: 60,
                    width: double.infinity,
                  ),
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }

  Widget _tile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _container(
            height: 40,
            width: 120,
            topRadius: 6,
            bottomRadius: 6,
          ),
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
          Expanded(
              child: _container(
            height: 80,
            topRadius: 20,
            bottomRadius: 20,
          )),
          SizedBox(width: 16),
          Expanded(
              child: _container(
            height: 80,
            topRadius: 20,
            bottomRadius: 20,
          )),
        ],
      ),
    );
  }

  Widget _customChips() {
    return Row(
      children: [
        SizedBox(width: 24),
        Expanded(
          child: _container(
            height: 32,
            width: 120,
            topRadius: 12,
            bottomRadius: 12,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: _container(
            height: 32,
            width: 120,
            topRadius: 12,
            bottomRadius: 12,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: _container(
            height: 32,
            width: 120,
            topRadius: 12,
            bottomRadius: 12,
          ),
        ),
      ],
    );
  }

  Widget _container({
    double? width,
    double? height,
    double? topRadius,
    double? bottomRadius,
    double? padding,
  }) {
    return ShimmerEffect(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding ?? 0.0),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topRadius ?? 0),
              topRight: Radius.circular(topRadius ?? 0),
              bottomLeft: Radius.circular(bottomRadius ?? 0),
              bottomRight: Radius.circular(bottomRadius ?? 0),
            ),
          ),
        ),
      ),
    );
  }
}
