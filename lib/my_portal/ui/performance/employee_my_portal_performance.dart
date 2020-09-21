import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class EmployeeMyPortalPerformance extends StatefulWidget {
  @override
  _EmployeeMyPortalPerformanceState createState() =>
      _EmployeeMyPortalPerformanceState();
}

class _EmployeeMyPortalPerformanceState
    extends State<EmployeeMyPortalPerformance> {
  double _performance = 0.75;
  double _currentScore = 0.90;
  double _bestScore = 0.98;
  double _leastScore = 0.45;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(5),
            child: CircularPercentIndicator(
              radius: 140.0,
              lineWidth: 5.0,
              animation: true,
              percent: _performance,
              circularStrokeCap: CircularStrokeCap.round,
              progressColor: currentProgressColor(_performance),
              center: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    "75%",
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 25.0,
                        color: currentProgressColor(_performance)),
                  ),
                  Text(
                    "YTD 2018",
                    style: TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 15.0),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            '90%',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: currentProgressColor(_currentScore),
                                fontSize: 16),
                          )),
                      LinearPercentIndicator(
                        animation: true,
                        lineHeight: 5.0,
                        animationDuration: 2500,
                        percent: _currentScore,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: currentProgressColor(_currentScore),
                      ),
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            'jan 2018 score',
                            textAlign: TextAlign.right,
                            style: TextStyle(
                                color: currentProgressColor(_currentScore),
                                fontSize: 12),
                          )),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            '98%',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: currentProgressColor(_bestScore),
                                fontSize: 16),
                          )),
                      LinearPercentIndicator(
                        animation: true,
                        lineHeight: 5.0,
                        animationDuration: 2500,
                        percent: _bestScore,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: currentProgressColor(_bestScore),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Best Score',
                                  style: TextStyle(fontSize: 12)),
                              Text(
                                'jan 2018',
                                style: TextStyle(
                                    color: currentProgressColor(_bestScore),
                                    fontSize: 12),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Text(
                            '45%',
                            textAlign: TextAlign.left,
                            style: TextStyle(
                                color: currentProgressColor(_leastScore),
                                fontSize: 16),
                          )),
                      LinearPercentIndicator(
                        animation: true,
                        lineHeight: 5.0,
                        animationDuration: 2500,
                        percent: _leastScore,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: currentProgressColor(_leastScore),
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 5, right: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('Least Score',
                                  style: TextStyle(fontSize: 12)),
                              Text(
                                'jan 2018',
                                style: TextStyle(
                                    color: currentProgressColor(_leastScore),
                                    fontSize: 12),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  currentProgressColor(progress) {
    if (progress >= 0.5 && progress < 0.8) {
      return Color(0xfff0ad4e);
    }
    if (progress < 0.5) {
      return Colors.red;
    } else {
      return Colors.green;
    }
  }
}
