import 'package:flutter/cupertino.dart';

import 'profit_loss_loader_container.dart';

class ProfitLossLoaderWidget extends StatelessWidget {
  const ProfitLossLoaderWidget({
    Key? key,
    this.count = 5,
  }) : super(key: key);

  final int count;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ProfitsLossesContainerLoader(
        height: 60,
        topRadius: 16,
        width: double.infinity,
      ),
      SizedBox(height: 1),
      ...List.generate(
        count,
        (_) => Padding(
          padding: const EdgeInsets.only(bottom: 1),
          child: ProfitsLossesContainerLoader(
            height: 60,
            width: double.infinity,
          ),
        ),
      ),
      ProfitsLossesContainerLoader(
        height: 60,
        bottomRadius: 16,
        width: double.infinity,
        onBottom: true,
      ),
    ]);
  }
}
