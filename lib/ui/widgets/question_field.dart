import 'package:flutter/material.dart';
import 'package:flutterapp/domain/question.dart';
import 'package:flutterapp/ui/events/answer_event.dart';
import 'package:flutterapp/ui/bloc/form_bloc.dart';

abstract class QuestionField {
  static Map<String, TextEditingController> _controllers = Map();

  static Widget getQuestionField(FormBloc formBloc, TextQuestion question) {
    return TextQuestionField(formBloc, _getController(question), question);
  }

  static TextEditingController _getController(TextQuestion question) {
    String questionId = question.id;
    if (_controllers[questionId] == null) {
      _controllers[questionId] = TextEditingController(text: question.answer);
    }
    return _controllers[questionId];
  }
}

class TextQuestionField extends TextFormField {
  TextQuestionField(FormBloc formBloc, TextEditingController controller, TextQuestion question)
      : super(
          autovalidate: true,
          validator: (value) {
            if (value.isEmpty) {
              return 'Enter text';
            }
            return null;
          },
          decoration: InputDecoration(
            labelText: '${question.title} answer: ${question.answer}',
          ),
          controller: controller,
          onChanged: (String answer) {
            formBloc.add(StringAnswerInputEvent(question.id, answer));
          },
        );
}
