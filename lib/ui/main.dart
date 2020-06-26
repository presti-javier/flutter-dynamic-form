import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/ui/state/form_state.dart';
import 'package:flutterapp/domain/question.dart';
import 'package:flutterapp/ui/bloc/form_bloc.dart';
import 'package:flutterapp/ui/widgets/question_field.dart';
import 'package:flutterapp/ui/events/stepper_event.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  BlocSupervisor.delegate = await HydratedBlocDelegate.build();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "flutter Demo",
      home: BlocProvider<FormBloc>(
        create: (context) => FormBloc(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HomePage')),
      body: BlocBuilder<FormBloc, FormBlocState>(
        builder: (context, formState) {
          return getStepper(context, formState);
        },
      ),
    );
  }

  Stepper getStepper(BuildContext context, FormBlocState formState) {
    final FormBloc formBloc = BlocProvider.of<FormBloc>(context);
    return Stepper(
      steps: getSteps(context, formBloc, formState.questions),
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

  List<Step> getSteps(BuildContext context, FormBloc formBloc, List<Question> questions) {
    return [
      Step(
        title: Text("Step 1"),
        isActive: true,
        state: StepState.error,
        content: QuestionField.getQuestionField(formBloc, questions.first),
      ),
      Step(
        title: Text("Step 2"),
        isActive: true,
        state: StepState.indexed,
        content: QuestionField.getQuestionField(formBloc, questions[1]),
      ),
    ];
  }
}
