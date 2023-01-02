import 'dart:convert';
import 'package:capstone_proj/src/content/models/country_summary.dart';
import 'package:capstone_proj/src/content/models/country.dart';
import 'package:capstone_proj/src/content/models/global_summary.dart';
import 'package:http/http.dart' as http;

class CovidService {
  // get info of the summaries nationwide
  Future<GlobalSummaryModel> getGlobalSummary() async {
    final data = await http.Client()
        .get(Uri.parse("https://api.covid19api.com/summary"));

    // error catch
    if (data.statusCode != 200) {
      throw Exception();
    }

    // create new summary instance

    GlobalSummaryModel summary =
        GlobalSummaryModel.fromJson(json.decode(data.body));

    // return the instance
    return summary;
  }

  // get the info of each region
  Future<List<CountrySummaryModel>> getCountrySummary(String slug) async {
    final data = await http.Client().get(
        Uri.parse("https://api.covid19api.com/total/dayone/country/$slug"));

    // error catch
    if (data.statusCode != 200) {
      throw Exception();
    }

    List<CountrySummaryModel> summaryList = (json.decode(data.body) as List)
        .map((item) => new CountrySummaryModel.fromJson(item))
        .toList();

    // return summary list
    return summaryList;
  }

  // get each region
  Future<List<CountryModel>> getCountryList() async {
    final data = await http.Client()
        .get(Uri.parse("https://api.covid19api.com/countries"));

    // error catch
    if (data.statusCode != 200) {
      throw Exception();
    }

    List<CountryModel> regions = (json.decode(data.body) as List)
        .map((item) => CountryModel.fromJson(item))
        .toList();

    // return summary list
    return regions;
  }
}
