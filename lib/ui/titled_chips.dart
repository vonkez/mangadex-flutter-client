import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TitledChips extends StatelessWidget {
  String title;
  List<String> chipContent;

  TitledChips({required this.title, required this.chipContent}) : super();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 19),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Wrap(
            spacing: 8,
            runSpacing: 4,
            children: chipContent.map((e) {
              return Chip(
                visualDensity: const VisualDensity(horizontal: 0.0, vertical: -2),
                label: Text(e),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
