import 'package:capstone_proj/src/const/const.dart';
import 'package:capstone_proj/src/content/models/country.dart';
import 'package:capstone_proj/src/content/models/country_summary.dart';
import 'package:capstone_proj/src/content/screens/countryLoading.dart';
import 'package:capstone_proj/src/content/screens/countryStatistics.dart';
import 'package:capstone_proj/src/content/screens/homepage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class CountryPage extends StatefulWidget {
  const CountryPage({super.key});

  @override
  State<CountryPage> createState() => _CountryPageState();
}

class _CountryPageState extends State<CountryPage> {
  // text editing controller for searching
  final TextEditingController _typeAheadController = TextEditingController();

  // country list
  late Future<List<CountryModel>> countryList;

  // summary list of countries
  late Future<List<CountrySummaryModel>> summaryList;

  @override
  void initState() {
    super.initState();

    // initialize the country list
    countryList = covidService.getCountryList();

    // set default value for the text editing controller to Philippines\
    _typeAheadController.text = "Philippines";

    // initialize country summary list
    summaryList = covidService.getCountrySummary("philippines");
  }

  // get suggestions upon typing the country name
  List<String> _getSuggestions(List<CountryModel>? list, String query) {
    // create list obj
    List<String> matches = [];

    for (var item in list!) {
      matches.add(item.country);
    }

    // return the matches found
    matches.retainWhere((s) => s.toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

  @override
  Widget build(BuildContext context) {
    // create the content of future builder
    return SingleChildScrollView(
      child: FutureBuilder(
          future: countryList,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(child: Text("Error"));
            }
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return CountryLoading(inputTextLoading: true);
              default:
                return !snapshot.hasData
                    ? const Center(child: Text("Empty"))
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // search bar hint/heading
                          const Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 4, vertical: 6),
                            child: Text(
                              "Type the name of country",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ),

                          // search bar widget
                          TypeAheadFormField(
                            textFieldConfiguration: TextFieldConfiguration(
                              controller: _typeAheadController,
                              decoration: InputDecoration(
                                hintText: 'ex. Philippines',
                                hintStyle: const TextStyle(fontSize: 16),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15),
                                  borderSide: const BorderSide(
                                    width: 0,
                                    style: BorderStyle.none,
                                  ),
                                ),
                                filled: true,
                                fillColor: Colors.grey.shade200,
                                contentPadding: const EdgeInsets.all(20),
                                prefixIcon: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 24, right: 16),
                                  child: Icon(
                                    Icons.search,
                                    color: primaryColor,
                                    size: 28,
                                  ),
                                ),
                              ),
                            ),
                            suggestionsCallback: (pattern) {
                              return _getSuggestions(snapshot.data, pattern);
                            },
                            itemBuilder: (context, suggestions) {
                              return ListTile(
                                title: Text(suggestions),
                              );
                            },
                            onSuggestionSelected: (suggestion) {
                              _typeAheadController.text = suggestion;

                              // change state depending on searched country
                              setState(() {
                                summaryList = covidService.getCountrySummary(
                                    snapshot.data!
                                        .firstWhere((element) =>
                                            element.country == suggestion)
                                        .slug);
                              });
                            },
                          ),

                          // space widgets with sizedbox
                          const SizedBox(
                            height: 8,
                          ),

                          // summary list container of the info for each country
                          FutureBuilder(
                            future: summaryList,
                            builder: (context, snapshot) {
                              if (snapshot.hasError) {
                                return const Center(
                                  child: Text("Error"),
                                );
                              }
                              switch (snapshot.connectionState) {
                                case ConnectionState.waiting:
                                  return CountryLoading(
                                      inputTextLoading: false);
                                default:
                                  return !snapshot.hasData
                                      ? const Center(
                                          child: Text("Empty"),
                                        )
                                      : CountryStatistics(
                                          summaryList: snapshot.data);
                              }
                            },
                          ),
                        ],
                      );
            }
          }

          // return const Center(child: Text("Error"));
          ),
    );
  }
}
