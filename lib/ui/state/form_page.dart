import 'package:flutter/cupertino.dart';
import 'package:flutterapp/domain/question.dart';

class FormPage {
  static const String TITLE = 'title';
  static const String QUESTIONS = 'questions';
  static const String STATE = 'state';

  final String title;
  final List<Question> questions;
  final FormPageState state;

  const FormPage(
      {@required this.title, @required this.questions, this.state = FormPageState.init});

  static FormPage fromJson(Map<String, dynamic> json) {
    List<Question> questions = List();
    (json[QUESTIONS] as List).forEach((e) {
      Question question = Question.fromJsonStatic(Map<String, dynamic>.from(e));
      questions.add(question);
    });

    return FormPage(
      title: json[TITLE],
      questions: questions,
      state: json[STATE],
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> questionsList = List();
    questions.forEach((e) => questionsList.add(e.toJson())); //DONOW use map?
    return {
      TITLE: title,
      QUESTIONS: questionsList,
      STATE: state,
    };
  }
}

enum FormPageState {
  init,
  editing,
  completed,
  uncomplete,
}
