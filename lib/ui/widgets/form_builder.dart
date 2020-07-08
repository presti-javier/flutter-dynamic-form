import 'package:flutter/material.dart';
import 'package:flutterapp/domain/question.dart';
import 'package:flutterapp/ui/bloc/form_bloc.dart';
import 'package:flutterapp/ui/events/stepper_event.dart';
import 'package:flutterapp/ui/state/form_page.dart';
import 'package:flutterapp/ui/state/form_state.dart';
import 'package:flutterapp/ui/widgets/bloc_widget.dart';
import 'package:flutterapp/ui/widgets/question_field.dart';
import 'package:flutterapp/ui/widgets/state_widget_builder.dart';

class FormBuilder {
  static BlocWidget<FormBlocState> getStepper(BuildContext context, FormBloc formBloc) {
    return StateWidgetBuilder.buildStepperWidget(
        formBloc.state,
        (state) => Stepper(
              steps: state.pages.map((page) => _getSteps(context, formBloc, page)).toList(),
              currentStep: state.currentStep,
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
            ));
  }

  static Step _getSteps(BuildContext context, FormBloc formBloc, FormPage page) {
    //DONOW remove questions cast
    return Step(
      title: Text(page.title),
      isActive: true,
      state: _getState(page.state),
      content: Form(
        //DONOW ListView instead of Column
        child: Column(
          children: page.questions
              .map((q) => QuestionField.buildQuestionField(formBloc, q as TextQuestion))
              .toList(),
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
