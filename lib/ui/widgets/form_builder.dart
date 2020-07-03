import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/domain/question.dart';
import 'package:flutterapp/remote/question_server.dart';
import 'package:flutterapp/ui/bloc/question_bloc.dart';
import 'package:flutterapp/ui/bloc/stepper_bloc.dart';
import 'package:flutterapp/ui/bloc_state/step_state.dart';
import 'package:flutterapp/ui/bloc_state/stepper_state.dart';
import 'package:flutterapp/ui/events/stepper_event.dart';
import 'package:flutterapp/ui/state/question_state.dart';
import 'package:flutterapp/ui/widgets/question_field.dart';

class FormBuilder {

  static Map<String, Key> keyMap = Map();

  static Key _getKey(StepBlocState stepBlocState) {
    String id = stepBlocState.title; //DONOW map pages with unique id
    return keyMap[id] ??= GlobalKey<FormState>();
  }

  static Stepper buildStepper(BuildContext context, StepperState stepperState,
      Map<String, List<Question>> stepQuestions) {
    final StepperBloc stepperBloc = BlocProvider.of<StepperBloc>(context);
    return Stepper(
      steps: stepperState.steps.map((stepBlocState) => _buildSteps(context, stepBlocState, stepQuestions[stepBlocState.title])).toList(),
      currentStep: stepperState.currentStepPos,
      onStepTapped: (currentStep) => stepperBloc.add(GoToStepEvent(currentStep)),
      onStepContinue: () => stepperBloc.add(NextStepEvent()),
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

  static Step _buildSteps(BuildContext context, StepBlocState stepBlocState,
      List<Question> questions) {
    //DONOW remove key and questions casts
    GlobalKey<FormState> key = _getKey(stepBlocState) as GlobalKey<FormState>;
      return Step(
        title: Text(stepBlocState.title),
        isActive: true,
        state: _getState(stepBlocState.state),
        content: Form(
          key: key,
          child: Column(
            children: questions.map((q) {
              QuestionBloc questionBloc = QuestionBloc(q);
              return BlocBuilder<QuestionBloc, Question>(
                bloc: questionBloc, //DONOW
                builder: (context, questionState) {
                  return QuestionField.buildQuestionField(questionBloc, questionState, key);
                },
              );
            }).toList(),
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
