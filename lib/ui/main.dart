import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutterapp/ui/bloc/form_bloc.dart';
import 'package:flutterapp/ui/state/form_state.dart';
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
        condition: (previousState, currentState) {
          bool changed = previousState.currentStep != currentState.currentStep;
          if (!changed) {
            for (int i = 0; i < previousState.pages.length; i++) {
              changed = changed || previousState.pages[i].state != currentState.pages[i].state;
            }
          }
          return changed;
        },
        builder: (context, formState) {
          return FormBuilder.getStepper(context, formState);
        },
      ),
    );
  }

}
