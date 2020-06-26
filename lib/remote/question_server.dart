import 'package:flutter/foundation.dart';

class ServerQuestion {
  static final String ID = 'id';
  static final String MANDATORY = 'mandatory';
  static final String TITLE = 'title';
  static final String HINT = 'hint';
  static final String ICON = 'icon';
  static final String QUESTION_TYPE = 'question_type';

  static final String OPTIONS = 'options';

  final String id;
  final bool mandatory;
  final QuestionType questionType;

  final String title;
  final String hint;
  final String icon;

  final List<String> options;

  ServerQuestion(Map<String, Object> json)
      : id = json[ID],
        mandatory = json[MANDATORY],
        questionType =
        QuestionType.values.firstWhere((e) => describeEnum(e) == json[QUESTION_TYPE]),
        title = json[TITLE],
        hint = json[HINT],
        icon = json[ICON],
        options = json[OPTIONS];
}

enum QuestionType {
  text,
  email,
  number,
  date,
  phone,
  address,
  nationality,
  checkbox,
  link_checkbox,
  image,
  combo_simple,
  combo_multiple,
  combo_chain
}
