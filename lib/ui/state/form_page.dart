import 'package:flutter/cupertino.dart';
import 'package:flutterapp/domain/question.dart';

class FormPage {
  static const String TITLE = 'title';
  static const String QUESTIONS = 'questions';
  static const String STATE = 'state';

  final String title;
  final List<Question> questions;
  final PageState state;

  const FormPage(
      {@required this.title, @required this.questions, this.state = PageState.init});

  static FormPage fromJson(Map<String, dynamic> json) {
    List<Question> questions = List();
    (json[QUESTIONS] as List).forEach((e) {
      Question question = Question.fromJsonStatic(Map<String, dynamic>.from(e));
      questions.add(question);
    });

    return FormPage(
      title: json[TITLE],
      questions: questions,
      state: PageState.get(json[STATE]),
    );
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> questionsList = questions.map((e) => e.toJson()).toList();
    return {
      TITLE: title,
      QUESTIONS: questionsList,
      STATE: state.toString(),
    };
  }
}

enum FormPageState {
  init,
  editing,
  completed,
  uncompleted,
}

class PageState {
  
  final String _id;

  const PageState._(this._id);

  static const PageState init = PageState._('init');
  static const PageState editing = PageState._('editing');
  static const PageState completed = PageState._('completed');
  static const PageState uncompleted = PageState._('uncompleted');

  static Map<String, PageState> _map;

  static PageState get(String name) {
    if (_map == null) {
      _map = {
        init._id: init,
        editing._id: editing,
        completed._id: completed,
        uncompleted._id: uncompleted,
      };
    }
    return _map[name];
  }

  @override
  String toString() {
    return _id;
  }
}
