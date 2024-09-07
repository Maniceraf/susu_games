class NumberHuntModel {
  final String level;
  final int value;
  NumberHuntModel({required this.level, required this.value});
}

class NumberModel {
  final int value;
  bool isCompleted = false;
  NumberModel({required this.value});
}
