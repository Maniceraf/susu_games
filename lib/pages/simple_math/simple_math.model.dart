class Question {
  final int id;
  final String question; // Câu hỏi
  String yourAnswer = ""; // Câu hỏi
  final List<String> options; // Các tùy chọn
  final String answer; // Câu trả lời đúng
  bool isCompleted = false;
  bool isCorrect = false;

  Question(
      {required this.id,
      required this.question,
      required this.options,
      required this.answer});
}
