class Lesson {
  final int lessonType;
  final String title;
  final String teacher;
  final String roomName;

  Lesson.fromJson(Map<String, dynamic> json)
      : lessonType = json['timetableEntryTypeId'],
        title = json['title'],
        teacher = json['teacher'],
        roomName = json['roomName'];
}
