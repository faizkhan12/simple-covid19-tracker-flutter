import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';

class CovidData {
  final String date;
  final String locationLabel;
  final int totalNumber;
  final int recoveredNumber;
  final int deadNumber;
  final int sickNumber;
  final double sickPercentage;
  final double recoveredPercentage;
  final double deadPercentage;

  CovidData({@required this.date,
    @required this.locationLabel,
    @required this.totalNumber,
    @required this.recoveredNumber,
    @required this.deadNumber,
    @required this.sickNumber,
    @required this.sickPercentage,
    @required this.recoveredPercentage,
    @required this.deadPercentage});

  factory CovidData.formatted({
    Map<String, dynamic> json,
    List<dynamic> jsonLocation,
    String country,
    String province
  }) {
    int totalNumber = json['Global']['TotalConfirmed'];
    int deadNumber = json['Global']['TotalDeaths'];
    int recoveredNumber = json['Global']['TotalRecovered'];
    if (totalNumber == 0) {
      throw Exception('No confirmed cases in your area.');
    }
    int sickNumber = totalNumber - recoveredNumber - deadNumber;

    return CovidData(
      date: DateFormat('EEEE d MMMM y').format(DateTime.now()),
      locationLabel: province == null ? country : '$country, $province',
      totalNumber: totalNumber,
      recoveredNumber: recoveredNumber,
      deadNumber: deadNumber,
      sickNumber: sickNumber,
      sickPercentage: sickNumber * 100.0 / totalNumber,
      recoveredPercentage: recoveredNumber * 100.0 / totalNumber,
      deadPercentage: deadNumber * 100.0 / totalNumber,
    );
  }


  factory CovidData.byCountryFormatted({
    List<dynamic> json,
    String country,
    String province,
  }) {
    int totalNumber = json[4];
    int deadNumber = json[5];
    int recoveredNumber = json[6];
    if (totalNumber == 0) {
      throw Exception('No confirmed cases in your country.');
    }
    int sickNumber = totalNumber - recoveredNumber - deadNumber;


    return CovidData(
      date: DateFormat('EEEE d MMMM y').format(DateTime.now()),
      locationLabel: province == null ? country : '$country, $province',
      totalNumber: totalNumber,
      recoveredNumber: recoveredNumber,
      deadNumber: deadNumber,
      sickNumber: sickNumber,
      sickPercentage: sickNumber * 100.0 / totalNumber,
      recoveredPercentage: recoveredNumber * 100.0 / totalNumber,
      deadPercentage: deadNumber * 100.0 / totalNumber,
    );
  }

}