import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_check_mark_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_close_button.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filter_chips.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_date_picker.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/leave/entities/leave_airport.dart';
import 'package:wallpost/leave/ui/presenters/leave_types_presenter.dart';
import 'package:wallpost/leave/ui/views/leave_airport_list/leave_airport_list_screen.dart';

class CreateLeaveScreen extends StatefulWidget {
  @override
  _CreateLeaveScreenState createState() => _CreateLeaveScreenState();
}

class _CreateLeaveScreenState extends State<CreateLeaveScreen>
    implements LeaveTypeView {
  LeaveTypesPresenter _presenter;
  bool isFilteredLeaveType = false;
  List<LeaveAirport> filteredLeaveAirport;
  var _startDateTextController = TextEditingController();
  var _endDateTextController = TextEditingController();
  var _departureListController = TextEditingController();
  var _arrivalListController = TextEditingController();
  DateTime selectedDate = DateTime.now();
  var myFormat = DateFormat('d-MM-yyyy');

  bool isTicketRequired = false;
  @override
  void initState() {
    super.initState();
    _presenter = LeaveTypesPresenter(this);
    _presenter.loadNextListOfLeaveTypes();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WPAppBar(
        title:
            SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name,
        leading: CircularCloseButton(
          iconColor: Colors.white,
          onPressed: () => Navigator.pop(context),
        ),
        trailing: CircularCheckMarkButton(
            iconColor: Colors.white, onPressed: () => {}),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Apply Leave', style: TextStyles.titleTextStyle),
                SizedBox(height: 4),
                Divider(),
                SizedBox(height: 4),
                _buildLeaveTypeList(),
                SizedBox(height: 4),
                _buildReasonView(),
                SizedBox(height: 8),
                _buildDateView(),
                SizedBox(height: 8),
                _buildPhoneTextField(),
                SizedBox(height: 8),
                _buildEmailTextField(),
                SizedBox(height: 8),
                _buildAttachmentsTextField(),
                _buildTicketCheckBox(),
                if (isTicketRequired) _buildDepartureAirportView(),
                if (isTicketRequired) _buildArrivalAirportView(),
                SizedBox(height: 8),
                if (isTicketRequired) _buildNoOfTravellersView(),
                SizedBox(height: 16),
                if (isTicketRequired) _buildAirClassView(),
                SizedBox(height: 16),
                if (isTicketRequired) _buildWayTypeView()
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveTypeList() {
    var leaveTypeTitles = _presenter.leaveTypes
        .map((e) => e.name.replaceAll("Leave", ''))
        .toList();
    if (leaveTypeTitles.isNotEmpty) {
      leaveTypeTitles = leaveTypeTitles.sublist(
          0, leaveTypeTitles.length > 2 ? 2 : leaveTypeTitles.length);
    }
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Leave Type',
          style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
        ),
        SizedBox(width: 8),
        _presenter.isLoadingLeaveTypes()
            ? Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              )
            : MultiSelectFilterChips(
                titles: leaveTypeTitles,
                selectedIndices: [],
                allowMultipleSelection: false,
                onItemSelected: (index) {
                  //select item
                },
              ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildReasonView() {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      minLines: null,
      maxLines: null,
      enableInteractiveSelection: false,
      style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.symmetric(vertical: 6),
        isDense: true,
        labelStyle:
            TextStyles.largeTitleTextStyle.copyWith(color: Colors.black),
        labelText: 'Reason',
        hintText:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry.',
        hintMaxLines: 2,
        hintStyle: TextStyles.subTitleTextStyle,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      onChanged: (String text) => {},
    );
  }

  Widget _buildDateView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.baseline,
      children: [
        Expanded(
          child: Row(children: [
            Text(
              'Start Date :',
              textAlign: TextAlign.center,
              style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
            ),
            SizedBox(width: 4),
            Expanded(
              flex: 1,
              child: TextFormField(
                controller: _startDateTextController,
                style:
                    TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 6),
                  isDense: true,
                  hintText: "01.02.2019",
                  hintStyle: TextStyles.subTitleTextStyle,
                  suffixIcon: Icon(Icons.calendar_today_outlined, size: 14),
                  suffixIconConstraints: BoxConstraints(minWidth: 20),
                ),
                onTap: () {
                  // Below line stops keyboard from appearing
                  FocusScope.of(context).requestFocus(new FocusNode());
                  _selectDate(context);
                  // Show Date Picker Here
                },
              ),
            ),
          ]),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Row(children: [
            Text(
              'End Date :',
              textAlign: TextAlign.center,
              style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
            ),
            SizedBox(width: 8),
            Expanded(
              child: TextFormField(
                controller: _endDateTextController,
                style:
                    TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 6),
                  isDense: true,
                  hintText: "01.02.2012",
                  hintStyle: TextStyles.subTitleTextStyle,
                  suffixIcon: Icon(Icons.calendar_today_outlined, size: 14),
                  suffixIconConstraints: BoxConstraints(minWidth: 20),
                ),
              ),
            ),
          ]),
        )
      ],
    );
  }

  Widget _buildPhoneTextField() {
    return Row(children: [
      Text('Phone :',
          style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
      SizedBox(width: 8),
      Expanded(
        child: TextFormField(
          style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 6),
            isDense: true,
            hintText: "+91 9745909644",
            hintStyle: TextStyles.subTitleTextStyle,
          ),
        ),
      ),
    ]);
  }

  Widget _buildEmailTextField() {
    return Row(children: [
      Text(
        'Email :',
        style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
      ),
      SizedBox(width: 8),
      Expanded(
        child: TextFormField(
          style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 6),
            isDense: true,
            hintText: "abc@gmail.com",
            hintStyle: TextStyles.subTitleTextStyle,
          ),
        ),
      ),
    ]);
  }

  Widget _buildAttachmentsTextField() {
    return Row(children: [
      Text(
        'Attachments :',
        style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
      ),
      SizedBox(width: 8),
      Expanded(
        child: TextFormField(
          style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
          decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 6),
            isDense: true,
            hintText: "jaseel_medical.jpeg",
            hintStyle: TextStyles.subTitleTextStyle,
          ),
        ),
      ),
    ]);
  }

  Widget _buildTicketCheckBox() {
    return Row(children: [
      Checkbox(
        value: this.isTicketRequired,
        onChanged: (bool value) {
          setState(() {
            this.isTicketRequired = value;
          });
        },
      ),
      SizedBox(width: 8),
      Text(
        'Ticket required ',
        style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
      ),
    ]);
  }

  Widget _buildDepartureAirportView() {
    return TextFormField(
        controller: _departureListController,
        style: TextStyles.subTitleTextStyle,
        decoration: InputDecoration(
          labelStyle:
              TextStyles.largeTitleTextStyle.copyWith(color: Colors.black),
          labelText: 'Departure Airport',
          hintText: ' Doha DOH',
          hintStyle: TextStyles.subTitleTextStyle,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          getDepartureAirports();
        });
  }

  Widget _buildArrivalAirportView() {
    return TextFormField(
        controller: _arrivalListController,
        style: TextStyles.subTitleTextStyle,
        decoration: InputDecoration(
          labelStyle:
              TextStyles.largeTitleTextStyle.copyWith(color: Colors.black),
          labelText: 'Arrival Airport',
          hintText: ' Kozhikkode CCJ',
          hintStyle: TextStyles.subTitleTextStyle,
          floatingLabelBehavior: FloatingLabelBehavior.always,
        ),
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          getArrivalAirports();
        });
  }

  Widget _buildNoOfTravellersView() {
    return Row(
      children: [
        Expanded(
          child: Row(children: [
            Text(
              'Adults :',
              textAlign: TextAlign.center,
              style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                style:
                    TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 6),
                  isDense: true,
                  hintText: "2",
                  hintStyle: TextStyles.subTitleTextStyle,
                ),
              ),
            ),
          ]),
        ),
        SizedBox(width: 20),
        Expanded(
          child: Row(children: [
            Text(
              'Children :',
              textAlign: TextAlign.center,
              style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
            ),
            SizedBox(width: 12),
            Expanded(
              child: TextFormField(
                keyboardType: TextInputType.number,
                style:
                    TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.symmetric(vertical: 6),
                  isDense: true,
                  hintText: "4",
                  hintStyle: TextStyles.subTitleTextStyle,
                ),
              ),
            ),
          ]),
        )
      ],
    );
  }

  Widget _buildAirClassView() {
    var _airClassList = ["Buisness", "Economy"];
    var selectedAirClassIndex = 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Air class',
            style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
        SizedBox(width: 8),
        MultiSelectFilterChips(
          titles: _airClassList,
          selectedIndices: [selectedAirClassIndex],
          allowMultipleSelection: false,
          onItemSelected: (selectedIndex) => {_airClassList[selectedIndex]},
          onItemDeselected: (selectedIndex) {
            setState(() => {});
          },
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildWayTypeView() {
    var _airWayList = ["One way", "Two way"];
    var selectedAirWayndex = 0;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text('Way type',
            style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
        SizedBox(width: 8),
        MultiSelectFilterChips(
          titles: _airWayList,
          selectedIndices: [selectedAirWayndex],
          allowMultipleSelection: false,
          onItemSelected: (selectedIndex) => {_airWayList[selectedIndex]},
          onItemDeselected: (selectedIndex) {
            setState(() => {});
          },
        ),
        SizedBox(height: 12),
      ],
    );
  }

  void getDepartureAirports() async {
    final selectedAirport =
        await ScreenPresenter.present(LeaveAirportListScreen(), context);
    if (selectedAirport != null) filteredLeaveAirport = selectedAirport;
    _departureListController.text =
        filteredLeaveAirport.map((e) => e.name).toString();
  }

  void getArrivalAirports() async {
    final selectedAirport =
        await ScreenPresenter.present(LeaveAirportListScreen(), context);
    if (selectedAirport != null) filteredLeaveAirport = selectedAirport;
    _arrivalListController.text =
        filteredLeaveAirport.map((e) => e.name).toString();
  }

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
        print("selecte date>>>>>" + selectedDate.toString());
        _startDateTextController.text = myFormat.format(selectedDate);
      });
  }
}
