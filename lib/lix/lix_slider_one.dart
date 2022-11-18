import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/dashboard/company_dashboard_owner_my_portal/ui/views/performance_view_holder.dart';

import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../_shared/constants/app_colors.dart';

class LixSliderOne extends StatefulWidget {
  LixSliderOne();

  @override
  State<LixSliderOne> createState() => _LixDetailScreenState();
}

class _LixDetailScreenState extends State<LixSliderOne> {
  @override
  Widget build(BuildContext context) {
    return _lixTile();
  }

  Widget _lixTile() {
    return
     Scaffold(
       backgroundColor: Colors.white,
       body: Container(
         margin: EdgeInsets.only(left: 16,right: 16),

         child: Column(
            children: [
              SizedBox(height: 50),

              Center(
                child: Container(
                    height: 50, width: 180, child: SvgPicture.asset('assets/logo/lix_logo.svg', width: 160, height: 40)),
              ),
              SizedBox(height: 60),
              Container(
                margin: EdgeInsets.only(left: 16,right: 16),
                child: Text(
                  "LIXX Is a blockchain-powered  reward system",
                  style: TextStyles.extraLargeTitleTextStyleBold,
                    textAlign: TextAlign.center
                ),
              ),
              SizedBox(
                height: 12,
              ),
              Container(
                margin: EdgeInsets.only(left: 20,right: 20),
                padding: EdgeInsets.only(left: 30,right: 30),

                child: Text(
                  "WallPost Software and other partners rewards high performing staff with  LIXX tokens",
                  style: TextStyles.titleTextStyle.copyWith(color: AppColors.textColorGray),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 50,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               buildLogo("assets/logo/com_ave.png"),
                SizedBox(width: 10,),
                buildLogo("assets/logo/itialus.png"),
              ],

            ),
              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  buildLogo("assets/logo/ushop.png"),
                  SizedBox(width: 10,),
                  buildLogo("assets/logo/tamias.png"),
                ],

              ),
              SizedBox(height: 10,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,

                children: [
                  buildLogo("assets/logo/wp_logo.png"),
                  SizedBox(width: 10,),
                  buildLogo("assets/logo/vensta.png"),
                ],

              ),
          ],
          ),
        ),
     );
  }

   Widget buildLogo(String path){
    return Container(
      height: 60,
      width: 150,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color:AppColors.lightGray)
      ),
      child: Image.asset(
        path,
        fit: BoxFit.contain,
      ),
    );
  }
}
