import 'package:flutter/material.dart';
import 'package:tracker_app/components/color_box.dart';
import 'package:tracker_app/utilities/constants.dart';

class StatsRow extends StatelessWidget {
  final Color colour;
  final String label;
  final int number;
  final double percentage;

  StatsRow({
    @required this.colour,
    @required this.label,
    @required this.number,
    @required this.percentage,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        ColourBox(colour: colour),
        Text('$label:', style: kTextStyleStats),
        Text('${kNumberFormat.format(number)}', style: kTextStyleStats),
        Text('(${percentage.toStringAsFixed(2)}%)', style: kTextStyleStats),
      ],
    );
  }
}