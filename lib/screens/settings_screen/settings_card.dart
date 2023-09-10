// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import '../../constants/constants.dart';
import '../../widgets/text_widget.dart';

class SettingsCard extends StatelessWidget {
  VoidCallback? onTap;
  final String title;
  String? trailing;
  IconData? icon;

  SettingsCard(
      {super.key, required this.title, this.trailing, this.onTap, this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: ColorPallate.cardColor,
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: ListTile(
          title: SettingText(text: title),
          leading: Icon(
            icon,
            color: Colors.greenAccent,
          ),
          trailing: SettingText(text: trailing ?? ''),
          onTap: onTap,
        ),
      ),
    );
  }

  TextWidget SettingText({required String text}) => TextWidget(
        label: text,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      );
}
