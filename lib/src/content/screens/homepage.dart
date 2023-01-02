import 'package:capstone_proj/src/const/const.dart';
import 'package:capstone_proj/src/content/screens/globalLoading.dart';
import 'package:capstone_proj/src/content/screens/countryStatistics.dart';
import 'package:capstone_proj/src/content/screens/globalStatistics.dart';
import 'package:flutter/material.dart';
import '../models/country_summary.dart';
import '../models/global_summary.dart';
import '../services/covid_services.dart';

// create global instance of covid services class
CovidService covidService = CovidService();

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // create instace of country summary model obj
  late Future<GlobalSummaryModel> summary;

  // init state
  @override
  void initState() {
    super.initState();
    summary = covidService.getGlobalSummary();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          // anuna
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                // header
                const Text(
                  "Global Summary of COVID-19",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),

                // refresh button
                GestureDetector(
                  onTap: () {
                    setState(() {
                      summary = covidService.getGlobalSummary();
                    });
                  },
                  child: const Icon(
                    Icons.refresh,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),

          // main contents
          FutureBuilder(
              future: summary,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return const Center(child: Text("Error"));
                }
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return GlobalLoading();
                  default:
                    return !snapshot.hasData
                        ? const Center(
                            child: Text("Empty"),
                          )
                        : GlobalStatistics(summary: snapshot.data);
                }
              }),
        ],
      ),
    );
  }
}
