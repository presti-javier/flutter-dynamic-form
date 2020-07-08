import 'package:flutter/material.dart';
import 'package:flutterapp/domain/question.dart';
import 'package:flutterapp/ui/bloc/form_bloc.dart';
import 'package:flutterapp/ui/events/answer_event.dart';
import 'package:flutterapp/ui/widgets/bloc_widget.dart';
import 'package:flutterapp/ui/widgets/state_widget_builder.dart';

abstract class QuestionField {
  static Widget buildQuestionField(FormBloc formBloc, TextQuestion question) {
    BlocWidget<Question> blocWidget = StateWidgetBuilder.buildQuestionWidget(
        question, (question) => TextQuestionField(formBloc: formBloc, question: question));
    return blocWidget;
  }
}

class TextQuestionField extends StatefulWidget {
  final FormBloc formBloc;
  final TextQuestion question;

  TextQuestionField({Key key, this.formBloc, this.question}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return TextQuestionFieldState();
  }
}

class TextQuestionFieldState extends State<TextQuestionField> {
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.question.answer);
  }

  @override
  Widget build(BuildContext context) {
    TextQuestion question = widget.question;
    FormBloc formBloc = widget.formBloc;
    return TextFormField(
      validator: (s) => question.isValidAnswer(s) ? null : 'Enter text',
      decoration: InputDecoration(
        labelText: '${question.title} answer: ${question.answer}',
      ),
      controller: _controller,
      onChanged: (String answer) {
        formBloc.add(StringAnswerInputEvent(question.id, answer, Form.of(context)?.validate()));
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
