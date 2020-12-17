import 'lesson.dart';

class Day {
  final Map<String, List<Lesson>> lessonSlots = new Map<String, List<Lesson>>();

  void add(Map<String, dynamic> jsonLesson) {
    String time = jsonLesson['lessonStart'].substring(0, 5);
    lessonSlots
        .putIfAbsent(time, () => new List<Lesson>())
        .add(new Lesson.fromJson(jsonLesson));
  }
}
