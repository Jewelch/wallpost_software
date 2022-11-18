import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import '../_wp_core/company_management/services/selected_company_provider.dart';
import 'lix_detail_app_bar.dart';
import 'lix_slider_one.dart';
import 'lix_slider_two.dart';

class LixInnerPage extends StatefulWidget {
  const LixInnerPage({Key? key}) : super(key: key);

  @override
  State<LixInnerPage> createState() => _LixInnerPageState();
}

class _LixInnerPageState extends State<LixInnerPage> {
  final Uri _url = Uri.parse('https://home.libraincentix.com/');
  int pageIndex = 0;
  List<Widget> _demo = [LixSliderOne(), LixDetailsSliderTwo()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          _AppBar(),
          Expanded(
            child: PageView(
              children: _demo,
              onPageChanged: (index) {
                setState(() {
                  pageIndex = index;
                });
              },
            ),
          ),
          SizedBox(
            height: 36,
          ),
          CarouselIndicator(
            color: AppColors.rose,
            activeColor: AppColors.yellow,
            count: _demo.length,
            index: pageIndex,
          ),
          SizedBox(height: 24),
          _checkItNowButton(),
          SizedBox(
            height: 16,
          )
        ],
      ),
    );
  }

  Widget _checkItNowButton() {
    return GestureDetector(
      onTap: _launchUrl,
      child: Container(
        margin: EdgeInsets.only(left: 32, right: 32),
        height: 50,
        decoration: BoxDecoration(
            color: AppColors.rose,
            borderRadius: const BorderRadius.all(
              Radius.circular(15.0),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.textColorDarkGray.withOpacity(.4),
                spreadRadius: 1,
                blurRadius: 6,
                offset: Offset(0, 8),
              )
            ]),
        child: Center(
          child: Text(
            'Check it Out',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontSize: 16,
              color: AppColors.textColorBlack,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url)) {
      throw 'Could not launch $_url';
    }
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LixDetailAppBar(
      companyName: SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name,
      onLeftMenuButtonPress: () => {},
      onAddButtonPress: () {},
      leadingButton: RoundedBackButton(backgroundColor:Colors.white,iconColor:AppColors.defaultColor,onPressed: () => Navigator.pop(context)),
      onTitlePress: () => Navigator.pop(context),
    );
  }
}
