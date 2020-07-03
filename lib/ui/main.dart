import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/domain/question.dart';
import 'package:flutterapp/remote/question_server.dart';
import 'package:flutterapp/ui/bloc/stepper_bloc.dart';
import 'package:flutterapp/ui/bloc_state/stepper_state.dart';
import 'package:flutterapp/ui/widgets/form_builder.dart';
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
      home: BlocProvider<StepperBloc>(
        create: (context) => StepperBloc(),
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {

  static Map<String, List<Question>> stepQuestions = <String, List<Question>>{
    'Pagina 1': [
      Question.fromServerQuestionStatic(ServerQuestion({
        ServerQuestion.QUESTION_TYPE: "text",
        ServerQuestion.ID: "10",
        ServerQuestion.MANDATORY: true,
        ServerQuestion.TITLE: "Titulo 10",
        ServerQuestion.HINT: "Hint 10",
        ServerQuestion.ICON: null,
      })),
      Question.fromServerQuestionStatic(ServerQuestion({
        ServerQuestion.QUESTION_TYPE: "text",
        ServerQuestion.ID: "11",
        ServerQuestion.MANDATORY: true,
        ServerQuestion.TITLE: "Titulo 11",
        ServerQuestion.HINT: "Hint 11",
        ServerQuestion.ICON: null,
      })),
    ],
    'Pagina 2': [
      Question.fromServerQuestionStatic(ServerQuestion({
        ServerQuestion.QUESTION_TYPE: "text",
        ServerQuestion.ID: "20",
        ServerQuestion.MANDATORY: true,
        ServerQuestion.TITLE: "Titulo 20",
        ServerQuestion.HINT: "Hint 20",
        ServerQuestion.ICON: null,
      })),
    ],
    'Pagina 3': [
      Question.fromServerQuestionStatic(ServerQuestion({
        ServerQuestion.QUESTION_TYPE: "text",
        ServerQuestion.ID: "30",
        ServerQuestion.MANDATORY: true,
        ServerQuestion.TITLE: "Titulo 30",
        ServerQuestion.HINT: "Hint 30",
        ServerQuestion.ICON: null,
      })),
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('HomePage')),
      body: BlocBuilder<StepperBloc, StepperState>(
        builder: (context, stepperState) {
          return FormBuilder.buildStepper(context, stepperState, stepQuestions);
        },
      ),
    );
  }
}
