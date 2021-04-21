import 'package:flutter/material.dart';
import 'package:covid_app/utilities/constants.dart';
import 'package:geolocator/geolocator.dart';
import 'package:covid_app/services/location_service.dart';
import 'package:covid_app/services/coronavirus_service.dart';
import 'package:covid_app/models/covid_data.dart';
import 'package:covid_app/components/stack_pie.dart';
import 'package:covid_app/components/stats.dart';
import 'package:covid_app/components/action_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:covid_app/screens/search_screen.dart';
import 'package:covid_app/components/error_alert.dart';
import 'package:covid_app/screens/state_screen.dart';

enum LocationSource { Global, Local, Search }

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  Future<CovidData> futureCoronavirusData;
  LocationSource locationSource = LocationSource.Global;

  @override
  void initState() {
    super.initState();
   futureCoronavirusData= CovidService().getLatestData();
  }

  void getData({String countryCode}) async {
    switch (locationSource) {
      case LocationSource.Global:
        futureCoronavirusData = CovidService().getLatestData();
        break;
      case LocationSource.Local:
        Placemark placemark = await LocationService().getPlacemark();
        setState(() {
          futureCoronavirusData =
              CovidService().getLocationDataFromPlacemark(placemark);
        });
        break;
      case LocationSource.Search:
        if (countryCode != null) {
          futureCoronavirusData =
              CovidService().getLocationDataFromCountryCode(countryCode);
        }
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: FutureBuilder<CovidData>(
            future: futureCoronavirusData,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                case ConnectionState.waiting:
                  return SpinKitPulse(color: kColourPrimary, size: 80);
                case ConnectionState.active:
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    return dataColumn(coronavirusData: snapshot.data);
                  } else if (snapshot.hasError) {
                    return ErrorAlert(
                      errorMessage: snapshot.error.toString(),
                      onRetryButtonPressed: () {
                        setState(() {
                          getData();
                        });
                      },
                    );
                  }
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Column dataColumn({CovidData coronavirusData}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          coronavirusData.date,
          style: kTextStyleDate,
          textAlign: TextAlign.center,
        ),
        Text(
          coronavirusData.locationLabel,
          style: kTextStyleLocationLabel,
          textAlign: TextAlign.center,
        ),
        StackPie(
          totalNumber: coronavirusData.totalNumber,
          sickNumber: coronavirusData.sickNumber,
          recoveredNumber: coronavirusData.recoveredNumber,
          deadNumber: coronavirusData.deadNumber,
        ),
        Stats(
          sickNumber: coronavirusData.sickNumber,
          recoveredNumber: coronavirusData.recoveredNumber,
          deadNumber: coronavirusData.deadNumber,
          sickPercentage: coronavirusData.sickPercentage,
          recoveredPercentage: coronavirusData.recoveredPercentage,
          deadPercentage: coronavirusData.deadPercentage,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[

           //
           // ActionButton(
           //   icon: Icons.near_me,
           //   onPressed: () {
           //     setState(() {
           //       locationSource = LocationSource.Local;
           //       getData();
           //     });
           //   },
           // ),
            ActionButton(
              icon: Icons.language,
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => StateScreen()));
              },
            ),
          ],
        ),
      ],
    );
  }
}