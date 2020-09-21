import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class SalesMyPortalPerormance extends StatefulWidget {
  @override
  _SalesMyPortalPerormanceState createState() =>
      _SalesMyPortalPerormanceState();
}

class _SalesMyPortalPerormanceState extends State<SalesMyPortalPerormance> {
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
          Expanded(
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.all(5),
                  child: CircularPercentIndicator(
                    radius: 110.0,
                    lineWidth: 5.0,
                    animation: true,
                    percent: _performance,
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
                    circularStrokeCap: CircularStrokeCap.round,
                    progressColor: currentProgressColor(_performance),
                  ),
                ),
                Container(
                  child: Column(children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Budgeted',
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          'Actual',
                          style: TextStyle(fontSize: 12),
                        )
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          '186.00',
                          style: TextStyle(fontSize: 16),
                        ),
                        Text(
                          '1.49M',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ]),
                )
              ],
            ),
          ),
          SizedBox(width: 20),
          Expanded(
            child: Column(
              children: <Widget>[

                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Budgeted',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Actual',
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '186.00',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '1.49M',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ]),
                      ),
                      LinearPercentIndicator(
                        animation: true,
                        lineHeight: 5.0,
                        animationDuration: 2500,
                        percent: _currentScore,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: currentProgressColor(_currentScore),
                      ),
                      Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('2018',
                                  style: TextStyle(
                                      color: currentProgressColor(_bestScore),
                                      fontSize: 12)),
                              Text(
                                '98%',
                                style: TextStyle(
                                    color: currentProgressColor(_bestScore),
                                    fontSize: 12),
                              )
                            ],
                          ))
                    ],
                  ),
                ),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Budgeted',
                                style: TextStyle(fontSize: 12),
                              ),
                              Text(
                                'Actual',
                                style: TextStyle(fontSize: 12),
                              )
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                '3.85M',
                                style: TextStyle(fontSize: 16),
                              ),
                              Text(
                                '1.49M',
                                style: TextStyle(fontSize: 16),
                              )
                            ],
                          ),
                        ]),
                      ),
                      LinearPercentIndicator(
                        animation: true,
                        lineHeight: 5.0,
                        animationDuration: 2500,
                        percent: _leastScore,
                        linearStrokeCap: LinearStrokeCap.roundAll,
                        progressColor: currentProgressColor(_leastScore),
                      ),
                      Container(
                          padding: EdgeInsets.all(8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text('2017',
                                  style: TextStyle(
                                      color: currentProgressColor(_leastScore),
                                      fontSize: 12)),
                              Text(
                                '45%',
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
    print("progress.." + progress.toString());
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
