import 'package:flutter/foundation.dart';
import 'package:flutterapp/remote/question_server.dart';
import 'package:flutterapp/ui/events/answer_event.dart';
import 'package:meta/meta.dart';

abstract class Question {
  static final String TYPE = 'type';
  static final String ID = 'id';
  static final String MANDATORY = 'mandatory';
  static final String TITLE = 'title';
  static final String HINT = 'hint';
  static final String ICON = 'icon';

  QuestionType get questionType;

  final String id;
  final bool mandatory;

  final String title;
  final String hint;
  final String icon;

  const Question({@required this.id, @required this.mandatory, this.title, this.hint, this.icon});

  Question.fromJson(Map<String, dynamic> json)
      : id = json[ID],
        mandatory = json[MANDATORY],
        title = json[TITLE],
        hint = json[HINT],
        icon = json[ICON];

  Question.fromServer(ServerQuestion serverQuestion)
      : this(
          id: serverQuestion.id,
          mandatory: serverQuestion.mandatory,
          title: serverQuestion.title,
          hint: serverQuestion.hint,
          icon: serverQuestion.icon,
        );

  static Question fromServerQuestionStatic(ServerQuestion serverQuestion) {
    switch (serverQuestion.questionType) {
      case QuestionType.text:
        return TextQuestion.fromServer(serverQuestion);
      case QuestionType.combo_simple:
        return SimpleComboQuestion.fromServer(serverQuestion);
      default:
        throw ("error");
    }
  }

  static Question fromJsonStatic(Map<String, dynamic> json) {
    switch (QuestionType.values.firstWhere((e) => json[TYPE] == describeEnum(e))) {
      case QuestionType.text:
        return TextQuestion.fromJson(json);
      case QuestionType.combo_simple:
        return SimpleComboQuestion.fromJson(json);
      default:
        throw ("error");
    }
  }

  Map<String, dynamic> toJson() {
    return {
      TYPE: describeEnum(questionType),
      ID: id,
      MANDATORY: mandatory,
      TITLE: title,
      HINT: hint,
      ICON: icon,
    };
  }

  Question onEvent(AnswerInputEvent event) {//DONOW make abstract method
    return this;
  }
}

class TextQuestion extends Question {
  static final String ANSWER = 'answer';

  final String answer;

  const TextQuestion(
      {@required String id,
      @required bool mandatory,
      String title,
      String hint,
      String icon,
      this.answer})
      : super(id: id, mandatory: mandatory, title: title, hint: hint, icon: icon);

  TextQuestion.fromJson(Map<String, dynamic> json)
      : answer = json[ANSWER],
        super.fromJson(json);

  TextQuestion.fromServer(ServerQuestion serverQuestion)
      : answer = null,
        super.fromServer(serverQuestion);

  @override
  TextQuestion onEvent(AnswerInputEvent event) {
    assert(event is StringAnswerInputEvent);
    String answer = (event as StringAnswerInputEvent).answer;
    return TextQuestion(
        id: id, mandatory: mandatory, title: title, hint: hint, icon: icon, answer: answer);
  }

  @override
  Map<String, Object> toJson() {
    return super.toJson()..[ANSWER] = answer;
  }

  @override
  QuestionType get questionType => QuestionType.text;
}

abstract class ComboQuestion extends Question {
  static final String OPTIONS = 'options';

  List<String> options;

  ComboQuestion.fromJson(Map<String, dynamic> json)
      : options = json[OPTIONS],
        super.fromJson(json);

  ComboQuestion.fromServer(ServerQuestion serverQuestion)
      : options = serverQuestion.options,
        super.fromServer(serverQuestion);
}

class SimpleComboQuestion extends ComboQuestion {
  static final String ANSWER = 'answer';

  String answer;

  SimpleComboQuestion.fromJson(Map<String, dynamic> json)
      : answer = json[ANSWER],
        super.fromJson(json);

  SimpleComboQuestion.fromServer(ServerQuestion serverQuestion) : super.fromServer(serverQuestion);

  @override
  QuestionType get questionType => QuestionType.combo_simple;
}

class SimpleComboChainQuestion extends SimpleComboQuestion {
  static final String CHAIN_ID = "chain_id";
  static final String OPTIONS = 'options';

  final String chainId;
  final Map<String, List<String>> optionsMap;

  SimpleComboChainQuestion.fromJson(Map<String, dynamic> json)
      : chainId = json[CHAIN_ID],
        optionsMap = json[OPTIONS],
        super.fromJson(json) {
    options = optionsMap.keys.toList();
  }

  @override
  QuestionType get questionType => QuestionType.combo_chain;
}
