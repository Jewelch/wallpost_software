import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/task/ui/views/task_details/task_comment_tile.dart';

class TaskDetailsScreen extends StatefulWidget {
  @override
  _TaskDetailsScreen createState() => _TaskDetailsScreen();
}

class _TaskDetailsScreen extends State<TaskDetailsScreen>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: 0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0.0,
        // Don't show the leading button
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 12.0, right: 12.0, bottom: 10.0),
              child: Row(
                children: [
                  SizedBox(
                    child: RoundedIconButton(
                        iconName: 'assets/icons/back.svg',
                        iconSize: 12,
                        onPressed: () => Navigator.pop(context)),
                  ),
                  Expanded(
                    child: Container(
                      height: 32,
                      width: double.infinity,
                      child: Row(
                        children: [
                          SizedBox(width: 8),
                          Expanded(
                            child: Container(
                              child: Text('Task Details',
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    child: RoundedIconButton(
                        iconName: 'assets/icons/check.svg',
                        iconSize: 12,
                        onPressed: () => Navigator.pop(context)),
                  ),
                ],
              ),
            ),
            Divider(
              height: 4,
              color: AppColors.blackColor,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: SizedBox(
                      width: 50,
                      height: 80,
                      child: Column(children: [
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: AppColors.defaultColor, width: 0),
                            borderRadius: BorderRadius.circular(50),
                            image: DecorationImage(
                                image: AssetImage(
                                    'assets/icons/user_image_placeholder.png'),
                                fit: BoxFit.fill),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 7.0),
                          child: Text('33%', style: TextStyle(fontSize: 12)),
                        ),
                      ]),
                    ),
                  ),
                  Expanded(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                top: 11.0, left: 10.0, right: 10.0),
                            child: Text(
                              'WallPost App Android and IOS Main Navigation Structure',
                              style: TextStyle(
                                  color: AppColors.defaultColor, fontSize: 16),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              softWrap: false,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 3.0, left: 10.0, right: 10.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text('Assigned to :',
                                      style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 14)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text('Jaseel Kiliyanthodi',
                                        style: TextStyle(
                                            color: AppColors.labelColor,
                                            fontSize: 14)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 3.0, left: 10.0, right: 10.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text('Status :',
                                      style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 14)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text('In Progress',
                                        style: TextStyle(
                                            color: AppColors.statusRedColor,
                                            fontSize: 14)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 3.0, left: 8.0, right: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  child: Expanded(
                                    child: Row(
                                      children: [
                                        Text('Created By : ',
                                            style: TextStyle(
                                                color: AppColors.blackColor,
                                                fontSize: 14)),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Text('Muhammed Nadeem',
                                              style: TextStyle(
                                                  color: AppColors.labelColor,
                                                  fontSize: 14)),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  child: Row(
                                    children: [
                                      Text('On :',
                                          style: TextStyle(
                                              color: AppColors.blackColor,
                                              fontSize: 14)),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text('21.02.2018',
                                            style: TextStyle(
                                                color: AppColors.labelColor,
                                                fontSize: 14)),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 3.0, left: 10.0, right: 10.0),
                            child: Container(
                              alignment: Alignment.centerLeft,
                              child: Row(
                                children: [
                                  Text('Code :',
                                      style: TextStyle(
                                          color: AppColors.blackColor,
                                          fontSize: 14)),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 8.0),
                                    child: Text('CCO',
                                        style: TextStyle(
                                            color: AppColors.labelColor,
                                            fontSize: 14)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
              Divider(
                height: 4,
              ),
              _tabBarWidget(),
              // ),
              _tabBarViewWidget(),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _tabBarWidget() {
    return SizedBox(
      height: 50,
      child: TabBar(
        controller: _tabController,
        labelColor: Colors.black,
        unselectedLabelColor: Colors.black,
        indicatorColor: AppColors.defaultColor,
        indicatorWeight: 3,
        tabs: [
          TabWidget(
            tabName: 'Details',
          ),
          TabWidget(
            tabName: 'Comments',
          ),
          TabWidget(
            tabName: 'Attachments',
          ),
        ],
      ),
    );
  }

  Container _tabBarViewWidget() {
    return Container(
      child: Expanded(
        child: TabBarView(
          controller: _tabController,
          children: <Widget>[
            _createDetailsWidget(),
            _createCommentsWidget(),
            _createCommentsWidget()
          ],
        ),
      ),
    );
  }

  Widget _getCommentsCard(int index) {
    return TaskCommentTile(
      onPressed: () => {},
    );
  }

  Widget _createCommentsWidget() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: 19,
            itemBuilder: (context, index) {
              return _getCommentsCard(index);
            },
          ),
        ),
        SizedBox(
          height: 120.0,
          child: Column(children: [
            Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: RaisedButton.icon(
                        onPressed: () {
                          print('Button Clicked.');
                        },
                        label: Text(
                          'Add comment',
                          style: TextStyle(color: AppColors.defaultColor),
                        ),
                        icon: Icon(
                          Icons.add,
                          color: AppColors.defaultColor,
                        ),
                        textColor: Colors.white,
                        color: Colors.white,
                        elevation: 0.0,
                      ),
                    ),
                    Container(
                      child: RaisedButton.icon(
                        onPressed: () {
                          print('Button Clicked.');
                        },
                        label: Text(
                          'Send',
                          style: TextStyle(color: AppColors.defaultColor),
                        ),
                        icon: ImageIcon(
                          AssetImage('assets/icons/send_icon.svg'),
                          size: 30,
                          color: AppColors.defaultColor,
                        ),
                        textColor: Colors.white,
                        color: Colors.white,
                        elevation: 0.0,
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: 53.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.transparent,
                ),
                child: TextFormField(
                  textAlign: TextAlign.start,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    helperMaxLines: 5,
                    hintText: 'Enter Comment',
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0)),
                      borderSide: BorderSide(
                        color: AppColors.filtersTextGreyColor,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            )
          ]),
        ),
      ],
    );
  }

  Widget _createDetailsWidget() {
    return Column(
      children: [
        Expanded(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            DetailsRowWidget('Start :', '21.02.2018'),
            DetailsRowWidget('End :', '21.02.2018'),
            DetailsRowWidget('Category :', 'Business Development'),
            DetailsRowWidget('Task Duration :', '1'),
            DetailsRowWidget('Duration In :', 'Working Days'),
            DetailsRowWidget('Task Owner :', 'Muhammad Nadeem'),
            DetailsRowWidget('Description :', 'Lorem ipsum'),
          ]),
        ),
      ],
    );
  }
}

class DetailsRowWidget extends StatelessWidget {
  const DetailsRowWidget(
    String _rowTitle,
    String _rowValue, {
    Key key,
  })  : _rowTitle = _rowTitle,
        _rowValue = _rowValue,
        super(key: key);
  final String _rowTitle;
  final String _rowValue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 13.0, left: 10.0, right: 10.0),
      child: Container(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Expanded(
                child: Text(_rowTitle,
                    style:
                        TextStyle(color: AppColors.blackColor, fontSize: 14))),
            Expanded(
              flex: 2,
              child: Text(_rowValue,
                  style: TextStyle(color: AppColors.labelColor, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }
}

class TabWidget extends StatelessWidget {
  const TabWidget({
    Key key,
    @required String tabName,
  })  : _tabName = tabName,
        super(key: key);
  final String _tabName;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 46,
      child: Tab(
        child: RichText(
          text: TextSpan(
            children: [
              TextSpan(
                  text: _tabName,
                  style: TextStyle(color: Colors.black, fontSize: 12)),
            ],
          ),
        ),
      ),
    );
  }
}
