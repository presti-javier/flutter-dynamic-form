import 'package:flutter/material.dart';
import 'package:flutterapp/domain/question.dart';
import 'package:flutterapp/ui/bloc/question_bloc.dart';
import 'package:flutterapp/ui/events/answer_event.dart';

abstract class QuestionField {
  static Map<String, TextEditingController> _controllers = Map();

  static Widget buildQuestionField(
      QuestionBloc questionBloc, TextQuestion question, GlobalKey<FormState> formKey) {
    return TextQuestionField(questionBloc, _getController(question), question, formKey);
  }

  static TextEditingController _getController(TextQuestion question) {
    return _controllers[question.id] ??= TextEditingController(text: question.answer);
  }
}

class TextQuestionField extends TextFormField {
  TextQuestionField(QuestionBloc questionBloc, TextEditingController controller, TextQuestion question,
      GlobalKey<FormState> formKey)
      : super(
          validator: (s) => question.isValidAnswer(s) ? null : 'Enter text',
          decoration: InputDecoration(
            labelText: '${question.title} answer: ${question.answer}',
          ),
          controller: controller,
          onChanged: (String answer) {
            questionBloc
                .add(StringAnswerInputEvent(question.id, answer, formKey.currentState.validate()));
          },
        );
}
