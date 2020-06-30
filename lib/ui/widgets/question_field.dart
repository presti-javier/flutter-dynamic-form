import 'package:flutter/material.dart';
import 'package:flutterapp/domain/question.dart';
import 'package:flutterapp/ui/bloc/form_bloc.dart';
import 'package:flutterapp/ui/events/answer_event.dart';

abstract class QuestionField {
  static Map<String, TextEditingController> _controllers = Map();

  static Widget getQuestionField(
      FormBloc formBloc, TextQuestion question, GlobalKey<FormState> formKey) {
    return TextQuestionField(formBloc, _getController(question), question, formKey);
  }

  static TextEditingController _getController(TextQuestion question) {
    return _controllers[question.id] ??= TextEditingController(text: question.answer);
  }
}

class TextQuestionField extends TextFormField {
  TextQuestionField(FormBloc formBloc, TextEditingController controller, TextQuestion question,
      GlobalKey<FormState> formKey)
      : super(
          validator: (s) => question.isValidAnswer(s) ? null : 'Enter text',
          decoration: InputDecoration(
            labelText: '${question.title} answer: ${question.answer}',
          ),
          controller: controller,
          onChanged: (String answer) {
            formBloc
                .add(StringAnswerInputEvent(question.id, answer, formKey.currentState.validate()));
          },
        );
}
