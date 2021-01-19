import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filters_list.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/leave/entities/leave_airport.dart';
import 'package:wallpost/leave/services/leave_airport_list_provider.dart';

class LeaveAirportListScreen extends StatefulWidget {
  @override
  _LeaveAirportListScreenState createState() => _LeaveAirportListScreenState();
}

class _LeaveAirportListScreenState extends State<LeaveAirportListScreen> {
  final List<LeaveAirport> _airports = [];
  final List<LeaveAirport> _selectedAirports = [];
  final LeaveAirportListProvider _provider = LeaveAirportListProvider();

  bool _showMessage;
  String _message;
  String _searchText;

  @override
  void initState() {
    _getAirports();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectFilterList(
      screenTitle: 'Select Airports',
      items: _airports.map((e) => e.name).toList(),
      selectedItems: [],
      searchBarHint: 'Search by airport or city name',
      showMessage: _showMessage,
      message: _message,
      showLoaderAtEnd: _provider.didReachListEnd ? false : true,
      onSearchTextChanged: (searchText) {
        _provider.reset();
        _airports.clear();
        _searchText = searchText;
        _getAirports();
      },
      onRefresh: () {
        setState(() => _airports.clear());
        _provider.reset();
        _getAirports();
      },
      onRetry: () {
        setState(() => _getAirports());
      },
      didReachEndOfList: () {
        _getAirports();
      },
      onFilterSelected: (title) {
        setState(() {
          _selectedAirports.add(_airports.firstWhere((e) => e.name == title));
        });
      },
      onFilterDeselected: (title) {
        setState(() {
          _selectedAirports.removeWhere((e) => e.name == title);
        });
      },
      onFilterSelectionComplete: () {
        Navigator.pop(context, _selectedAirports);
      },
    );
  }

  void _getAirports() async {
    if (_provider.isLoading) return;

    setState(() => _showMessage = false);
    try {
      var airportList = await _provider.getNext(searchText: _searchText);
      setState(() {
        _airports.addAll(airportList);
        if (_airports.length == 0) {
          _showMessage = true;
          _message = 'There are no airports to show.';
        }
      });
    } on WPException catch (error) {
      setState(() {
        _showMessage = true;
        _message = error.userReadableMessage;
      });
    }
  }
}
