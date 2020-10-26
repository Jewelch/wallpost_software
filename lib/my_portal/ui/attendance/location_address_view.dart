import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/my_portal/ui/attendance/utils/location_provider_util.dart';
class LocationAddressView extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _LocationAddressViewState ();
  }

}

class _LocationAddressViewState extends State<LocationAddressView> {
  String address ;
  @override
  void initState() {
    super.initState();
    _getLocation();
  }
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: SvgPicture.asset(
            'assets/icons/location.svg',
            width: 14,
            height: 18,
          ),
        ),
        Text(
          address==null?'Acquiring your location...':address,
          style: TextStyle(color: AppColors.attendanceLocationTextColor),
        ),
      ],
    );

  }

  _getLocation() async {
    Position position = await LocationProvider().getLocation();
     address = await LocationProvider().getLocationAddress(position);
    setState(() {

    });
  }
}