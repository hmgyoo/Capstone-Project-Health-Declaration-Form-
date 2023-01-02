import 'package:flutter/material.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../screens/chart.dart';

import 'package:charts_flutter/flutter.dart' as charts;

import '../../const/const.dart';
import '../models/country_summary.dart';
import '../models/time_series_cases.dart';

class CountryStatistics extends StatelessWidget {
  // list of countries
  List<CountrySummaryModel>? summaryList;

  CountryStatistics({required this.summaryList});

  @override
  Widget build(BuildContext context) {
    // initialize the length of the array
    int length = summaryList!.length - 1;

    // bod of container
    return Column(
      children: <Widget>[
        // cards containing information
        buildCard(
          "CONFIRMED",
          summaryList![length].confirmed,
          kRecoveredColor,
          "ACTIVE",
          summaryList![length].active,
          kActiveColor,
        ),
        buildCard(
          "RECOVERED",
          summaryList![length].recovered,
          kRecoveredColor,
          "DEATH",
          summaryList![length].death,
          kActiveColor,
        ),
        buildCardChart(
          summaryList!,
        ),
      ],
    );
  }

  // buildcard widget
  Widget buildCard(String leftTitle, int leftValue, Color leftColor,
      String rightTitle, int rightValue, Color rightColor) {
    return Card(
      elevation: 1,
      child: Container(
        height: 100,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            // decorate the cards

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // left title
                Text(
                  leftTitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                //separator
                Expanded(
                  child: Container(),
                ),

                // left label for current number
                Text(
                  "Total",
                  style: TextStyle(
                    color: leftColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                // current number taken from API
                Text(
                  leftValue
                      .toString()
                      .replaceAllMapped(reg, (Match match) => '${match[1]}.'),
                  style: TextStyle(
                    color: leftColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ],
            ),

            // right titles
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                //right title
                Text(
                  rightTitle,
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                //separator
                Expanded(
                  child: Container(),
                ),

                // right label for current number
                Text(
                  "Total",
                  style: TextStyle(
                    color: rightColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),

                // current number taken from API
                Text(
                  rightValue
                      .toString()
                      .replaceAllMapped(reg, (Match match) => '${match[1]}.'),
                  style: TextStyle(
                    color: leftColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 28,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCardChart(List<CountrySummaryModel> summaryList) {
    return Card(
      elevation: 1,
      child: Container(
        height: 190,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Chart(
          _createData(summaryList),
          animate: false,
        ),
      ),
    );
  }

  List<charts.Series<TimeSeriesCases, DateTime>> _createData(
      List<CountrySummaryModel> summaryList) {
    List<TimeSeriesCases> confirmedData = [];
    List<TimeSeriesCases> activeData = [];
    List<TimeSeriesCases> recoveredData = [];
    List<TimeSeriesCases> deathData = [];

    for (var item in summaryList) {
      confirmedData.add(TimeSeriesCases(item.date, item.confirmed));
      activeData.add(TimeSeriesCases(item.date, item.active));
      recoveredData.add(TimeSeriesCases(item.date, item.recovered));
      deathData.add(TimeSeriesCases(item.date, item.death));
    }

    return [
      charts.Series<TimeSeriesCases, DateTime>(
        id: 'Confirmed',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(kConfirmedColor),
        domainFn: (TimeSeriesCases cases, _) => cases.time,
        measureFn: (TimeSeriesCases cases, _) => cases.cases,
        data: confirmedData,
      ),
      charts.Series<TimeSeriesCases, DateTime>(
        id: 'Active',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(kActiveColor),
        domainFn: (TimeSeriesCases cases, _) => cases.time,
        measureFn: (TimeSeriesCases cases, _) => cases.cases,
        data: activeData,
      ),
      charts.Series<TimeSeriesCases, DateTime>(
        id: 'Recovered',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(kRecoveredColor),
        domainFn: (TimeSeriesCases cases, _) => cases.time,
        measureFn: (TimeSeriesCases cases, _) => cases.cases,
        data: recoveredData,
      ),
      charts.Series<TimeSeriesCases, DateTime>(
        id: 'Death',
        colorFn: (_, __) => charts.ColorUtil.fromDartColor(kDeathColor),
        domainFn: (TimeSeriesCases cases, _) => cases.time,
        measureFn: (TimeSeriesCases cases, _) => cases.cases,
        data: deathData,
      ),
    ];
  }
}
