import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:smart_gpt_ai/constants/constants.dart';

class UserNoticeMD extends StatelessWidget {
  final String noticeLocation;

  UserNoticeMD({super.key, required this.noticeLocation});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorPallate.cardColor,
        body: FutureBuilder(
          future: rootBundle.loadString(noticeLocation),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error loading Markdown file'));
            } else {
              return Column(
                children: [
                  SizedBox(height: 24),
                  // Text('Terms and Conditions'),
                  Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: Icon(
                            Icons.cancel_outlined,
                            color: Colors.white,
                          )),
                    ],
                  ),
                  Flexible(child: Markdown(data: snapshot.data ?? '')),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
