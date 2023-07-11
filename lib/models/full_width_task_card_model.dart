class TaskCardModelFullWidth {
  String title;
  String icon;
  String msg;
  TaskCardModelFullWidth({
    required this.title,
    required this.icon,
    required this.msg,
  });
}

class TaskCardSectionModel {
  String sectionTitle;
  List<TaskCardModelFullWidth> taskCardModelList;

  TaskCardSectionModel({
    required this.sectionTitle,
    required this.taskCardModelList,
  });
}
