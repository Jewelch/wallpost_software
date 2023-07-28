import 'package:blur/blur.dart';
import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/screen_presenter/screen_presenter.dart';
import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenters/dashboard_presenter.dart';
import '../screens/select_report_screen.dart';

class ReportsFloatingActionButton extends StatelessWidget {
  final DashboardPresenter presenter;

  const ReportsFloatingActionButton({Key? key, required this.presenter}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: GestureDetector(
        onTap: () {
          ScreenPresenter.present(
              SelectReportScreen(
                presenter: presenter,
              ),
              context,
              slideDirection: SlideDirection.fromBottom);
        },
        child: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(.1), spreadRadius: 1, blurRadius: 15)]),
              child: Blur(
                borderRadius: BorderRadius.circular(16),
                child: Opacity(
                  opacity: .7,
                  child: Container(
                    height: 64,
                    width: MediaQuery.of(context).size.width * .8,
                    decoration: BoxDecoration(
                      color: AppColors.screenBackgroundColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 24,
              child: Center(
                child: Text(
                  "Reports",
                  style: TextStyles.largeTitleTextStyleBold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
