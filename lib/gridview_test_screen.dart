// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class GridViewTestScreen extends StatelessWidget {
  const GridViewTestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Flexible(
          child: GridView.builder(
              itemCount: 20,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, childAspectRatio: 2),
              itemBuilder: (context, index) {
                return Container(
                  padding: EdgeInsets.all(5),
                  margin: EdgeInsets.all(5),
                  color: Colors.grey,
                  child: Text(
                    '$index',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }),
        ),
      ],
    );
  }
}
