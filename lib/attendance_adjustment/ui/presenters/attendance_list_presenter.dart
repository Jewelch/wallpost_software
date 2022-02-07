import 'package:intl/intl.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/services/attendance_list_provider.dart';
import 'package:wallpost/attendance_adjustment/ui/contracts/attendance_list_view.dart';

class AttendanceListPresenter {
  final AttendanceListView _view;
  final AttendanceListProvider _attendanceListProvider;
  List<AttendanceListItem> _attendanceList = [];

  AttendanceListPresenter(this._view)
      : _attendanceListProvider = AttendanceListProvider();

  AttendanceListPresenter.initWith(
    this._view,
    this._attendanceListProvider,
  );

  //MARK: Function to load the attendance list

  Future<void> loadAttendanceList(int month, int year) async {
    if (_attendanceListProvider.isLoading) return;
    _attendanceList.clear();
    _view.showLoader();
    try {
      var attendanceList = await _attendanceListProvider.get(month, year);
      _attendanceList.addAll(attendanceList);
      if (_attendanceList.isNotEmpty) {
        _view.showAttendanceList(_attendanceList);
      } else {
        _view.showNoListMessage(
            "There are no attendance list available.\n\nTap here to reload");
      }
      _view.hideLoader();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
      _view.hideLoader();
    }
  }

  //MARK: Function to refresh the attendance list

  refresh() {
    _attendanceListProvider.reset();
    loadAttendanceList(getCurrentMonth(), getCurrentYear());
  }

  //MARK: Getters

  int getCurrentYear() {
    var currentYear = DateTime.now().year;
    return currentYear;
  }

  int getCurrentMonth() {
    var currentMonth = DateTime.now().month;
    return currentMonth;
  }

  List<int> getYearsList() {
    List<int> years = [getCurrentYear(), getCurrentYear() - 1];
    return years;
  }

  List<String> getMonthsList(int selectedYear) {
    List<String> months = [];
    DateFormat formatter = DateFormat("MMM");

    if (selectedYear == getCurrentYear()) {
      for (int i = getCurrentMonth(); i > 0; i--) {
        DateTime month = DateTime(getCurrentYear(), i);
        months.add(formatter.format(month));
      }
    } else {
      for (int i = 12; i > 0; i--) {
        DateTime month = DateTime(selectedYear, i);
        months.add(formatter.format(month));
      }
    }
    return months;
  }
}
