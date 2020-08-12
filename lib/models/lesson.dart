class Lesson {
  final int _lessonType;
  final String _title;
  final String _roomName;
  Lesson _childLesson;

  Lesson.fromJson(Map<String, dynamic> json)
      : _lessonType = json['timetableEntryTypeId'],
        _title = json['title'],
        _roomName = json['roomName'];

  void addChildLesson(Lesson childLesson) {
    _childLesson = childLesson;
  }

  String displayString() {
    String displayString = _title + "  " + _roomName;
    if (_childLesson != null) {
      displayString += "\n" + _childLesson.displayString();
    }
    return displayString;
  }
}
