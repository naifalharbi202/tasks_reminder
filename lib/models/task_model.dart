class TaskModel {
  String? taskTitle;
  String? taskDate;
  String? taskTime;
  String? taskId;
  String? name;
  String? uid;
  DateTime? lastUpdated;
  bool isDone = false;
  int? notificationId;
  String type = 'default';

  //Constructor to create instance from this class
  TaskModel({
    required this.taskTitle,
    required this.taskDate,
    required this.taskTime,
    required this.name,
    required this.uid,
    required this.lastUpdated,
    required this.isDone,
    required this.notificationId,
    required this.type,
    this.taskId,
  });

  //Named constructor to get task data from firestore
  TaskModel.fromJson(Map<String, dynamic> json) {
    taskTitle = json['taskTitle'];
    taskDate = json['taskDate'];
    taskTime = json['taskTime'];
    name = json['name'];
    uid = json['uid'];
    taskId = json['taskId'];
    lastUpdated = json['lastUpdated'];
    isDone = json['isDone'];
    notificationId = json['notificationId'];
    type = json['type'];
  }

  //Send data as a map to 'tasks' collection in firestor

  Map<String, dynamic> toJson() {
    return {
      'taskTitle': taskTitle,
      'taskDate': taskDate,
      'taskTime': taskTime,
      'name': name,
      'uid': uid,
      'lastUpdated': lastUpdated,
      'isDone': isDone,
      'notificationId': notificationId,
      'type': type
    };
  }
}
