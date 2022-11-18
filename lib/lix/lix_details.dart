import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

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
      appBar: SimpleAppBar(
        title: "Lix Details",
        leadingButton: RoundedBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: Column(
        children: [
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
          SizedBox(height: 16,)
        ],
      ),
    );
  }

  Widget _checkItNowButton(){
    return GestureDetector(
      onTap: _launchUrl,
      child: Container(
        margin: EdgeInsets.only(left: 16, right: 16),

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
            ]
        ),
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