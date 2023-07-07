class TaskCardModel {
  String title;
  String icon;
  String msg;
  TaskCardModel({
    required this.title,
    required this.icon,
    required this.msg,
  });
}

class TaskCardSectionModel {
  String sectionTitle;
  List<TaskCardModel> taskCardModelList;

  TaskCardSectionModel({
    required this.sectionTitle,
    required this.taskCardModelList,
  });
}
