import '../models/full_width_task_card_model.dart';

List<TaskCardSectionModel> fullWidthTaskCardSectionList = [
  TaskCardSectionModel(
    sectionTitle: 'Ask for Advice',
    taskCardModelList: [
      TaskCardModelFullWidth(
          title: 'Give me step-by-step plan to get rich',
          icon: '🤑',
          msg: "Give me some unique idea to get rich step by step"),
      TaskCardModelFullWidth(
          title: 'What are some good Christmas gifts?',
          icon: '🎁',
          msg: "What are some good Christmas gifts?"),
      TaskCardModelFullWidth(
          title: 'How can I get a promotion?',
          icon: '🪜',
          msg: "How can I get a promotion?"),
    ],
  ),
  TaskCardSectionModel(
    sectionTitle: 'Have Fun',
    taskCardModelList: [
      TaskCardModelFullWidth(
          title: 'Tell me a joke', icon: '😊', msg: "Tell me a joke"),
    ],
  ),
  TaskCardSectionModel(
    sectionTitle: 'Write and Edit',
    taskCardModelList: [
      TaskCardModelFullWidth(
          title: 'Create a one-page essay on The Great Gatsby',
          icon: '📝',
          msg: "Create a one-page essay on The Great Gatsby"),
    ],
  ),
  TaskCardSectionModel(
    sectionTitle: 'Health and Fitness',
    taskCardModelList: [
      TaskCardModelFullWidth(
        title: 'Feeling tired and sluggish',
        icon: '😴',
        msg:
            "I've been feeling tired and sluggish lately. What can I do to improve my overall health and energy levels?",
      ),
      TaskCardModelFullWidth(
        title: 'I want to start a fitness routine',
        icon: '👟',
        msg:
            "I want to start a fitness routine but don't know where to begin. Any tips on getting started?",
      ),
    ],
  ),
];
