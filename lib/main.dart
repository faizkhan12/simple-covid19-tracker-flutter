import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:covid_app/utilities/constants.dart';
import 'package:covid_app/screens/stats_screen.dart';

void main() => runApp(CoronavirusTracker());

class CoronavirusTracker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kColourPrimary,
        scaffoldBackgroundColor: kColourBackground,
      ),
      home: StatsScreen(),
    );
  }
}