import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/domain/question.dart';
import 'package:flutterapp/ui/bloc/form_bloc.dart';
import 'package:flutterapp/ui/events/stepper_event.dart';
import 'package:flutterapp/ui/state/form_page.dart';
import 'package:flutterapp/ui/state/form_state.dart';
import 'package:flutterapp/ui/widgets/question_field.dart';

class FormBuilder {

  static Map<String, Key> keyMap = Map();

  static Key _getKey(FormPage page) {
    String id = page.title; //DONOW map pages with unique id
    return keyMap[id] ??= GlobalKey<FormState>();
  }

  static Stepper getStepper(BuildContext context, FormBlocState formState) {
    final FormBloc formBloc = BlocProvider.of<FormBloc>(context);
    return Stepper(
      steps: formState.pages.map((page) => _getSteps(context, formBloc, page)).toList(),
      currentStep: formState.currentStep,
      onStepTapped: (currentStep) => formBloc.add(GoToStepEvent(currentStep)),
      onStepContinue: () => formBloc.add(NextStepEvent()),
      controlsBuilder: (BuildContext context,
          {VoidCallback onStepContinue, VoidCallback onStepCancel}) {
        return Row(
          children: <Widget>[
            FlatButton(
              onPressed: onStepContinue,
              child: const Text('NEXT'),
            ),
          ],
        );
      },
    );
  }

  static Step _getSteps(BuildContext context, FormBloc formBloc, FormPage page) {
    //DONOW remove key and questions casts
    GlobalKey<FormState> key = _getKey(page) as GlobalKey<FormState>;
      return Step(
        title: Text(page.title),
        isActive: true,
        state: _getState(page.state),
        content: Form(
          key: key,
          child: Column(
            children: page.questions.map((q) => QuestionField.buildQuestionField(formBloc, q as TextQuestion, key)).toList(),
          ),
        ),
      );
  }

  static StepState _getState(PageState pageState) {
    switch (pageState) {
      case PageState.init:
        return StepState.indexed;
      case PageState.editing:
        return StepState.editing;
      case PageState.completed:
        return StepState.complete;
      case PageState.uncompleted:
        return StepState.error;
      default:
        return StepState.indexed;
    }
  }

}
