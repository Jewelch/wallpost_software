import 'dart:async';

import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/app_bar_with_back_button.dart';
import 'package:wallpost/_common_widgets/custom_cards/header_card.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance/ui/presenters/attendance_presenter.dart';
import 'package:wallpost/attendance/ui/view_contracts/attendance_view.dart';
import 'package:wallpost/attendance/ui/views/attendance_rounded_action_button.dart';
import 'package:wallpost/company_list/views/companies_list_screen.dart';

class AttendanceButtonDetailsScreen extends StatefulWidget {
  const AttendanceButtonDetailsScreen({Key? key}) : super(key: key);

  @override
  _AttendanceButtonDetailsScreenState createState() =>
      _AttendanceButtonDetailsScreenState();
}

class _AttendanceButtonDetailsScreenState
    extends State<AttendanceButtonDetailsScreen> implements AttendanceView {
  late final AttendancePresenter presenter;
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  late BitmapDescriptor customIcon;

  final ItemNotifier<int> _buttonTypeNotifier = ItemNotifier();
  final ItemNotifier<int> _typeNotifier = ItemNotifier();
  static const PUNCH_IN_BUTTON_VIEW = 1;
  static const PUNCH_OUT_BUTTON_VIEW = 2;
  static const LOADER_VIEW = 3;

  static const SHOW_BREAK_BUTTON_VIEW = 4;
  static const HIDE_BREAK_BUTTON_VIEW = 5;
  static const RESUME_BUTTON_VIEW = 6;

  @override
  void initState() {
    presenter = AttendancePresenter(this);
    presenter.loadAttendanceDetails();
    // _timeString = _formatDateTime(DateTime.now());
    // Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
        leadingButton: SvgPicture.asset(
          'assets/icons/back_icon.svg',
          color: Colors.white,
          width: 18,
          height: 18,
        ),
        onLeadingButtonPressed: () =>
            ScreenPresenter.presentAndRemoveAllPreviousScreens(
                CompanyListScreen(), context),
        textButton1: TextButton(
          onPressed: () {},
          child: Text(
            "Punch out screen",
            style: TextStyle(
                color: Color(0xff0096E3),
                fontSize: 18,
                fontWeight: FontWeight.w700),
          ),
        ),
      ),
      body: SafeArea(
          child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: <Widget>[
              Container(
                height: 350,
                child: _mapView(),
              ),
              Positioned(
                child: _buildAttendanceButton(),
                right: 0,
                left: 0,
                bottom: -60,
              ),
            ],
          ),
          SizedBox(
            height: 88,
          ),
          _buildBreakResumeButton(),
          SizedBox(
            height: 16,
          ),
          _buildAttendanceDetails()
        ],
      )),
    );
  }

  Widget _mapView() {
    return Container(
      margin: EdgeInsets.only(
        right: 10,
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          child: GoogleMap(
            zoomControlsEnabled: false,
            compassEnabled: false,
            zoomGesturesEnabled: false,
            scrollGesturesEnabled: false,
            tiltGesturesEnabled: false,
            rotateGesturesEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(0, 0),
              zoom: 14.0,
            ),
            onMapCreated: (GoogleMapController controller) {
              _controller = controller;
            },
            markers: _markers,
          )),
    );
  }

  Widget _buildAttendanceButton() {
    return ItemNotifiable<int>(
      notifier: _buttonTypeNotifier,
      builder: (context, value) {
        if (value == LOADER_VIEW) {
          return _buildLoader();
        } else if (value == PUNCH_IN_BUTTON_VIEW) {
          return _buildPunchInButton();
        } else if (value == PUNCH_OUT_BUTTON_VIEW) {
          return _buildPunchOutButton();
        }
        return Container();
      },
    );
  }

  Widget _buildLoader() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.grey,
        shape: BoxShape.circle,
      ),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          "Loading....",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildPunchInButton() {
    return AttendanceRoundedActionButton(
        title: "Punch In",
        time: "10:10 AM",
        buttonColor: AppColors.punchInButtonColor,
        onButtonPressed: () {
          print("punch in");
        });
  }

  Widget _buildPunchOutButton() {
    return AttendanceRoundedActionButton(
        title: "Punch Out",
        time: "10:10 PM",
        buttonColor: AppColors.punchOutButtonColor,
        onButtonPressed: () {
          print("punch out");
        });
  }

  Widget _buildBreakResumeButton() {
    return ItemNotifiable<int>(
      notifier: _typeNotifier,
      builder: (context, value) {
        if (value == SHOW_BREAK_BUTTON_VIEW) {
          return _buildBreakButton();
        } else if (value == RESUME_BUTTON_VIEW) {
          return _buildResumeButton();
        }
        return Container();
      },
    );
  }

  Widget _buildBreakButton() {
    return ElevatedButton.icon(
      onPressed: () {
        presenter.startBreak();
      },
      icon: SvgPicture.asset(
        // <-- Icon
        "assets/icons/overtime_icon.svg",
        height: 16,
        color: Color(0xff003C81),
      ),
      label: Text(
        'Start break',
        style: TextStyle(fontSize: 16, color: Color(0xff003C81)),
      ),
      style: ElevatedButton.styleFrom(
        primary: AppColors.breakButton,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(14.0),
        ),
        elevation: 0,
        padding: EdgeInsets.only(left: 20, right: 20),
      ), // <-- Text
    );
  }

  Widget _buildResumeButton() {
    return ElevatedButton.icon(
      onPressed: () {
        presenter.endBreak();
      },
      icon: SvgPicture.asset(
        // <-- Icon
        "assets/icons/overtime_icon.svg",
        height: 16,
        color: Color(0xff003C81),
      ),
      label: Text(
        'Resume',
        style: TextStyle(fontSize: 16, color: Color(0xff003C81)),
      ),
      style: ElevatedButton.styleFrom(
        primary: AppColors.breakButton,
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(14.0),
        ),
        elevation: 0,
        padding: EdgeInsets.only(left: 20, right: 20),
      ), // <-- Text
    );
  }

  Widget _buildAttendanceDetails() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Text("1 Day",
                  style: TextStyle(
                      color: Color(0xfff8a632), fontWeight: FontWeight.bold)),
              SizedBox(
                height: 16,
              ),
              Text("Late Punch In")
            ],
          ),
          Column(
            children: [
              Text(
                "1 Day",
                style: TextStyle(
                    color: Color(0xff222222), fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16,
              ),
              Text("Late Punch In")
            ],
          ),
          Column(
            children: [
              Text(
                "1 Day",
                style: TextStyle(
                    color: Color(0xfff8524a), fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 16,
              ),
              Text("Late Punch In")
            ],
          )
        ],
      ),
    );
  }

  // void setCustomMarker() async {
  //   customIcon = await BitmapDescriptor.fromAssetImage(
  //       ImageConfiguration(devicePixelRatio: 2.5), 'assets/icons/overtime_icon.svg');
  // }

  @override
  void hideBreakButton() {
    _typeNotifier.notify(HIDE_BREAK_BUTTON_VIEW);
  }

  @override
  void hideLoader() {
    // TODO: implement hideLoader
  }

  @override
  void openAppSettings() {
    // TODO: implement openAppSettings
  }

  @override
  void showAlertToDeniedLocationPermission(String title, String message) {
    // TODO: implement showAlertToDeniedLocationPermission
  }

  @override
  void showAlertToTurnOnDeviceLocation(String title, String message) {
    // TODO: implement showAlertToTurnOnDeviceLocation
  }

  @override
  void showAlertToVerifyLocation(String message) {
    // TODO: implement showAlertToVerifyLocation
  }

  @override
  void showBreakButton() {
    _typeNotifier.notify(SHOW_BREAK_BUTTON_VIEW);
  }

  @override
  void showDisabledButton() {
    // TODO: implement showDisabledButton
  }

  @override
  void showError(String title, String message) {
    // TODO: implement showError
  }

  @override
  void showErrorMessage(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void showFailedToGetLocation(String title, String message) {
    // TODO: implement showFailedToGetLocation
  }

  @override
  void showLoader() {
    _buttonTypeNotifier.notify(LOADER_VIEW);
  }

  @override
  void showLocationAddress(String address) {
    // TODO: implement showLocationAddress
  }

  @override
  void showMessageToAllowPunchInFromAppPermission(String message) {
    // TODO: implement showMessageToAllowPunchInFromAppPermission
  }

  @override
  void showPunchInButton() {
    _buttonTypeNotifier.notify(PUNCH_IN_BUTTON_VIEW);
  }

  @override
  void showPunchInTime(String time) {
    // TODO: implement showPunchInTime
  }

  @override
  void showPunchOutButton() {
    _buttonTypeNotifier.notify(PUNCH_OUT_BUTTON_VIEW);
  }

  @override
  void showPunchOutTime(String time) {
    // TODO: implement showPunchOutTime
  }

  @override
  void showResumeButton() {
    _typeNotifier.notify(RESUME_BUTTON_VIEW);
  }

  @override
  void showTimeTillPunchIn(num seconds) {
    // TODO: implement showTimeTillPunchIn
  }

  @override
  void showLocationPositions(num lat, num long) {
    // setCustomMarker();
    _controller
        ?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
      target: LatLng(lat.toDouble(), long.toDouble()),
      zoom: 14.0,
    )));
    setState(() {
      _markers.add(Marker(
          //  icon: customIcon,
          markerId: MarkerId('Home'),
          position: LatLng(lat.toDouble(), long.toDouble())));
    });
  }
}
