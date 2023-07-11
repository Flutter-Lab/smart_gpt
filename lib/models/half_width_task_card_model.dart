class HalfWidthTaskCardModel {
  String title;
  final String subtitle;
  String icon;
  String msg;
  HalfWidthTaskCardModel({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.msg,
  });
}

class SmartTaskSectionModel {
  String sectionTitle;
  List<HalfWidthTaskCardModel> taskCardModelList;
  SmartTaskSectionModel({
    required this.sectionTitle,
    required this.taskCardModelList,
  });
}
