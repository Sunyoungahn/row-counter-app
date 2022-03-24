import 'dart:math';

import 'package:flutter/material.dart';
import 'package:row_counter_app/constant.dart';

class ProjectCard extends StatelessWidget {
  ProjectCard({
    Key? key,
    required this.projectTitle,
    required this.numOfRow,
  }) : super(key: key);

  final String projectTitle;
  final int numOfRow;
  int i = Random().nextInt(colors.length);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24.0),
        color: Colors.white,
        //color: colors[i],
        border: Border.all(
          width: 2.0,
          //color: kTileBorderColor,
          color: colors[i],
        ),
      ),
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          //ProjectTitle
          Text(
            projectTitle,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

          //NumOfRow
          Text(
            numOfRow.toString(),
            style: const TextStyle(
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }
}
