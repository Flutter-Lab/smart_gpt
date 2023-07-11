// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/constants.dart';
import 'package:smart_gpt_ai/widgets/task_card_half_width_list_widget.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

class SmartTask extends StatelessWidget {
  const SmartTask({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: ColorPallate.cardColor,
        title: const Center(
          child: TextWidget(label: 'Smart Task', fontSize: 20),
        ),
      ),
      body: Column(
        children: [
          TaskCardHalfWidthGridListWidget(),
        ],
      ),
    );
  }
}
