import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/domain/question.dart';
import 'package:flutterapp/ui/bloc/form_bloc.dart';
import 'package:flutterapp/ui/events/stepper_event.dart';
import 'package:flutterapp/ui/state/form_page.dart';
import 'package:flutterapp/ui/state/form_state.dart';
import 'package:flutterapp/ui/widgets/question_field.dart';

class FormBuilder {

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
    //DONOW remove questions casts
    return Step(
      title: Text(page.title),
      isActive: true,
      state: _getState(page.state),
      content: Form(
        child: Column(
          children: page.questions.map((q) {
            return BlocBuilder<FormBloc, FormBlocState>(
              condition: (previousState, currentState) {
                FormPage page = previousState.pages.firstWhere((p) => p.questions.any((qu) => qu.id == q.id));
                Question q1 = page.questions.firstWhere((qu) => qu.id == q.id);
                return (q as TextQuestion).answer != (q1 as TextQuestion).answer;
              },
              builder: (context, formState) {
                FormPage page = formState.pages.firstWhere((p) => p.questions.any((qu) => qu.id == q.id));
                Question q1 = page.questions.firstWhere((qu) => qu.id == q.id);

                return QuestionField.getQuestionField(formBloc, q1 as TextQuestion);
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
