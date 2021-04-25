import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tracker_app/models/covid_data.dart';
import 'package:geolocator/geolocator.dart';
import 'package:alpha2_countries/alpha2_countries.dart';
import 'package:intl/intl.dart';
import 'package:tracker_app/models/Districts.dart';

class CovidService {
  final baseUrl = 'https://api.covid19api.com/';

  Future<CovidData> getLatestData() async {
    final response = await http.get(baseUrl + 'summary');

    if (response.statusCode == 200) {
      return CovidData.formatted(
        json: jsonDecode(response.body),
        country: 'Global',
      );
    } else {
      throw Exception('Failed to load latest coronavirus data.');
    }
  }

  Future<CovidData> getLocationDataFromPlacemark(Placemark placemark) async {
    final response = await http
        .get(baseUrl + 'country/${placemark.isoCountryCode}');

    if (response.statusCode == 200) {
      return CovidData.formatted(
        json: jsonDecode(response.body),
        country: placemark.country,
      );
    } else {
      throw Exception('Failed to load local coronavirus data.');
    }
  }

  Future<CovidData> getLocationDataFromCountryCode(String countryCode) async {
    var date = new DateTime.now().toString();
    var time = DateFormat("H:m:s").format(DateTime.now());
    var formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());

    print('live/country/${(Countries()
        .resolveName(countryCode)
        .toLowerCase())}/status/confirmed/date/${(formattedDate
        .toString())}T${(time.toString())}');

    final response =
    await http.get(baseUrl + 'live/country/${(Countries()
        .resolveName(countryCode)
        .toLowerCase())}/status/confirmed/date/${(formattedDate
        .toString())}T${(time.toString())}Z');

    if (response.statusCode == 200) {
      return CovidData.byCountryFormatted(
        json: jsonDecode(response.body),
        country: Countries().resolveName(countryCode),
      );
    } else {
      throw Exception('Failed to load coronavirus data from search.');
    }
  }

}