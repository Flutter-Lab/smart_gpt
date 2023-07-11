// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:smart_gpt_ai/data/smart_task_section_List.dart';
import 'package:smart_gpt_ai/models/half_width_task_card_model.dart';
import 'package:smart_gpt_ai/widgets/task_card_widget_half_width.dart';
import 'package:smart_gpt_ai/widgets/text_widget.dart';

class TaskCardHalfWidthGridListWidget extends StatelessWidget {
  const TaskCardHalfWidthGridListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: ListView.builder(
            itemCount: halfWidthTaskCardSectionList.length,
            itemBuilder: (context, index) {
              var currentSection = halfWidthTaskCardSectionList[index];
              var currentSectionGridList =
                  halfWidthTaskCardSectionList[index].taskCardModelList;
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(label: currentSection.sectionTitle),
                  GridView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: currentSectionGridList.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        var currentTaskCard = currentSectionGridList[index];

                        HalfWidthTaskCardModel taskModel =
                            HalfWidthTaskCardModel(
                                title: currentTaskCard.title,
                                subtitle: currentTaskCard.subtitle,
                                icon: currentTaskCard.icon,
                                msg: currentTaskCard.msg);

                        return IntrinsicHeight(
                          child: Container(
                            height: 50,
                            child: TaskCardHalfWidth(
                              taskModel: taskModel,
                              onPressed: () {},
                            ),
                          ),
                        );
                      })
                ],
              );
            }));
  }
}
