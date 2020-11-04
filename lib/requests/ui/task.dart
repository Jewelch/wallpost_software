import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/wp_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/company_management/ui/companies_list_screen.dart';
import 'package:wallpost/requests/ui/task_list_card.dart';

class TaskScreen extends StatefulWidget {
  @override
  _TaskScreen createState() => _TaskScreen();
}

class _TaskScreen extends State<TaskScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController _listFilterTextFieldController =
      new TextEditingController();
  bool _listFilterVisible = false;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 7, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: WPAppBar(
        title:
            SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name,
        leading: RoundedIconButton(
            iconName: 'assets/icons/back.svg',
            iconSize: 12,
            onPressed: () => Navigator.pop(context)),
        trailing: RoundedIconButton(
          iconName: 'assets/icons/filters_icon.svg',
          onPressed: () => {
            //todo
            // Navigator.pushNamed(context, RouteNames.filters)
          },
        ),
        showCompanySwitchButton: true,
        companySwitchBadgeCount: 10,
        onCompanySwitchButtonPressed: () {
          ScreenPresenter.present(CompaniesListScreen(), context,
              slideDirection: SlideDirection.fromLeft);
        },
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerFilterTextFieldWidget(),
              Divider(
                height: 4,
              ),
              _tabBarWidget(),
              // ),
              _filterListWidget(),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _headerFilterTextFieldWidget() {
    return SizedBox(
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _listFilterVisible
              ? Expanded(
                  child: TextField(
                    controller: _listFilterTextFieldController,
                    onSubmitted: (text) =>
                        print(_listFilterTextFieldController.text),
                    style: TextStyle(color: Colors.black, fontSize: 20.0),
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Enter a search term'),
                  ),
                )
              : Text('Task Requests',
                  style: TextStyle(color: Colors.black, fontSize: 20)),
          IconButton(
              icon: _listFilterVisible
                  ? Image.asset('assets/icons/delete_icon.png')
                  : Image.asset('assets/icons/search_icon.png'),
              onPressed: () {
                setState(() {
                  _listFilterVisible
                      ? _listFilterVisible = false
                      : _listFilterVisible = true;
                });
              }),
        ],
      ),
    );
  }

  SizedBox _tabBarWidget() {
    return SizedBox(
      height: 50,
      child: TabBar(
        isScrollable: true,
        controller: _tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        indicatorColor: AppColors.defaultColor,
        indicatorWeight: 3,
        tabs: [
          TabWidget(
            tabCount: 5,
            tabName: 'Overdue',
          ),
          TabWidget(
            tabCount: 5,
            tabName: 'Due Today ',
          ),
          TabWidget(
            tabCount: 5,
            tabName: 'Due in a week',
          ),
          TabWidget(
            tabCount: 5,
            tabName: 'Extension',
          ),
          TabWidget(
            tabCount: 5,
            tabName: 'Cancellation',
          ),
          TabWidget(
            tabCount: 5,
            tabName: 'On Hold',
          ),
          TabWidget(
            tabCount: 5,
            tabName: 'Reassign',
          ),
        ],
      ),
    );
  }

  Container _filterListWidget() {
    return Container(
      child: Expanded(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            _createListWidgetWithFilter(1),
            _createListWidgetWithFilter(2),
            _createListWidgetWithFilter(3),
            _createListWidgetWithFilter(4),
            _createListWidgetWithFilter(5),
            _createListWidgetWithFilter(6),
            _createListWidgetWithFilter(7)
          ],
        ),
      ),
    );
  }

  Widget _getTaskCard(int index) {
    return TaskListCard(
      onPressed: () => {},
    );
  }

  Widget _createListWidgetWithFilter(int listFilter) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 19, //_filterList.length,
            itemBuilder: (context, index) {
              return _getTaskCard(index);
            },
          ),
        ),
      ],
    );
  }
}

class TabWidget extends StatelessWidget {
  const TabWidget({
    Key key,
    @required String tabName,
    @required num tabCount,
  })  : _totalCount = tabCount,
        _tabName = tabName,
        super(key: key);

  final num _totalCount;
  final String _tabName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Tab(
        child: Column(
          children: <Widget>[
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: '$_totalCount',
                      style: TextStyle(
                          color: AppColors.defaultColor, fontSize: 22))
                ],
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                      text: _tabName,
                      style: TextStyle(color: Colors.black, fontSize: 12)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
