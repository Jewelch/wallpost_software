import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/shimmer/shimmer_effect.dart';
import '../../../../../../restaurant_and_retail/common_widgets/sales_break_down_loader.dart';
import 'profit_loss_loader_container.dart';

class ProfitsLossesLoader extends StatelessWidget {
  const ProfitsLossesLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          ListView(
            children: [
              _appBar(context),
              SizedBox(height: 2),
              _tile(context),
              _filters(context),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                  ),
                ),
              ),
              SizedBox(height: 45),
              _customChips(),
              SizedBox(height: 16),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SalesBreakDownLoader(count: 1),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 24,
              vertical: MediaQuery.of(context).viewPadding.bottom + 16,
            ),
            child: Container(
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
          ),
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
          ProfitsLossesContainerLoader(
            height: 35,
            width: 120,
            topRadius: 6,
            bottomRadius: 6,
          ),
        ],
      ),
    );
  }

  Widget _filters(BuildContext context) {
    final double height = 25;
    final double width = 80;
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 12, right: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ProfitsLossesContainerLoader(
            height: height,
            width: 50,
            topRadius: 6,
            bottomRadius: 6,
          ),
          ProfitsLossesContainerLoader(
            height: height,
            width: width,
            topRadius: 6,
            bottomRadius: 6,
          ),
          ProfitsLossesContainerLoader(
            height: height,
            width: width,
            topRadius: 6,
            bottomRadius: 6,
          ),
          ProfitsLossesContainerLoader(
            height: height,
            width: width,
            topRadius: 6,
            bottomRadius: 6,
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
          ProfitsLossesContainerLoader(
            height: 40,
            width: 40,
            topRadius: 10,
            bottomRadius: 10,
          ),
          SizedBox(width: 40),
          Expanded(
              child: ProfitsLossesContainerLoader(
            height: 26,
            topRadius: 6,
            bottomRadius: 6,
          )),
          SizedBox(width: 40),
          ProfitsLossesContainerLoader(
            height: 40,
            width: 40,
            topRadius: 10,
            bottomRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget _customChips() {
    return Row(
      children: [
        SizedBox(width: 24),
        Expanded(
          child: ProfitsLossesContainerLoader(
            height: 32,
            width: 120,
            topRadius: 12,
            bottomRadius: 12,
          ),
        ),
        Expanded(child: SizedBox(width: 15)),
        Expanded(
          child: ProfitsLossesContainerLoader(
            height: 32,
            width: 120,
            topRadius: 12,
            bottomRadius: 12,
          ),
        ),
        SizedBox(width: 24),
      ],
    );
  }
}
