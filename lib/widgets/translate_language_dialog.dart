import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../constants/constants.dart';
import 'text_widget.dart';

Future<dynamic> TransLangDialog(BuildContext context) {
  return showDialog(
    context: context,
    builder: (context) => SimpleDialog(
      backgroundColor: ColorPallate.cardColor,
      title: Center(
        child: TextWidget(label: 'Select Language'),
      ),
      children: [
        Container(
          height: 300,
          width: 100,
          padding: EdgeInsets.all(8),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: transLanguageList.length,
            itemBuilder: (context, index) => GestureDetector(
              onTap: () async {
                String transLanguageCode = transLanguageList[index]['code']!;

                SharedPreferences prefs = await SharedPreferences.getInstance();

                await prefs.setString('transLanguage', transLanguageCode);

                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(12),
                margin: EdgeInsets.all(1),
                color: ColorPallate.bgColor,
                child: Center(
                  child: TextWidget(
                    label: transLanguageList[index]['language']!,
                    fontSize: 16,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
