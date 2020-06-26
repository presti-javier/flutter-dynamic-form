import 'package:flutterapp/domain/question.dart';

class FormBlocState {
  static const String QUESTIONS = 'questions';
  static const CURRENT_STEP = 'current_step';

  final List<Question> questions;
  final int currentStep;
  final int maxStep = 1; //DONOW

  const FormBlocState(this.questions, [this.currentStep = 0]);

  static FormBlocState fromJson(Map<String, dynamic> json) {
    List<Question> questions = List();
    (json[QUESTIONS] as List).forEach((e) {
      Question question = Question.fromJsonStatic(Map<String, dynamic>.from(e));
      questions.add(question);
    });
    return FormBlocState(questions, json[CURRENT_STEP]);
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> questionsList = List();
    questions.forEach((e) => questionsList.add(e.toJson()));
    return {QUESTIONS: questionsList, CURRENT_STEP: currentStep};
  }
}
