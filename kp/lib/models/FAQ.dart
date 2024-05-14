class FAQ {
  final String columnID = 'FAQID';
  final String columnQuestion = 'QUESTION';
  final String columnAnswer = 'ANSWER';

  int id = 0;
  late String question;
  late String answer;

  FAQ(
      this.question,
      this.answer,
      );

  Map<String, Object?> toMap() {
    var map = <String, Object?>{
      columnQuestion: question,
      columnAnswer: answer,
    };
    if (id != 0) {
      map[columnID] = id;
    }
    return map;
  }

  FAQ.fromMap(Map<dynamic, dynamic> map) {
    id = map[columnID] ?? 0;
    question = map[columnQuestion];
    answer = map[columnAnswer];
  }
}

