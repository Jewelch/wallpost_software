import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_check_mark_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_close_button.dart';
import 'package:wallpost/_common_widgets/form_widgets/multi_select_filter_chips.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/leave/ui/presenters/leave_types_presenter.dart';

class CreateLeaveScreen extends StatefulWidget {
  @override
  _CreateLeaveScreenState createState() => _CreateLeaveScreenState();
}

class _CreateLeaveScreenState extends State<CreateLeaveScreen>
    implements LeaveTypeView {
  LeaveTypesPresenter _presenter;
  bool isFilteredLeaveType = false;
  var _leaveTypeFilterController = MultiSelectFilterChipsController();

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
          iconColor: Colors.white,
          onPressed: () =>
              Navigator.pushNamed(context, RouteNames.leaveListFilter),
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Apply Leave', style: TextStyles.titleTextStyle),
              SizedBox(height: 4),
              Divider(),
              SizedBox(height: 4),
              _buildLeaveTypeList(),
              SizedBox(height: 4),
              _buildReasonView()
            ],
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
                allIndexesSelected: isFilteredLeaveType,
                controller: _leaveTypeFilterController,
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
      minLines: 2,
      maxLines: null,
      enableInteractiveSelection: false,
      decoration: InputDecoration(
        labelStyle: TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
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

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }
}
