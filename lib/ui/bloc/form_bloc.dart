import 'dart:math';

import 'package:flutterapp/ui/state/form_state.dart';
import 'package:flutterapp/domain/question.dart';
import 'package:flutterapp/remote/question_server.dart';
import 'package:flutterapp/ui/events/answer_event.dart';
import 'package:flutterapp/ui/events/stepper_event.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class FormBloc extends HydratedBloc<FormEvent, FormBlocState> {
  @override
  FormBlocState get initialState {
    FormBlocState initialState = super.initialState;
    if (initialState != null) return initialState;

    //DONOW load questions in form
    List<Question> questions = [
      Question.fromServerQuestionStatic(ServerQuestion({
        ServerQuestion.QUESTION_TYPE: "text",
        ServerQuestion.ID: "1",
        ServerQuestion.MANDATORY: true,
        ServerQuestion.TITLE: "Titulo 1",
        ServerQuestion.HINT: "Hint 1",
        ServerQuestion.ICON: null,
      })),
      Question.fromServerQuestionStatic(ServerQuestion({
        ServerQuestion.QUESTION_TYPE: "text",
        ServerQuestion.ID: "2",
        ServerQuestion.MANDATORY: true,
        ServerQuestion.TITLE: "Titulo 2",
        ServerQuestion.HINT: "Hint 2",
        ServerQuestion.ICON: null,
      })),
    ];
    return FormBlocState(questions);
  }

  @override
  Stream<FormBlocState> mapEventToState(FormEvent event) async* {
    if (event is GoToStepEvent) {
      yield onGoToStepEvent(event);
    } else if (event is NextStepEvent) {
      yield onNextStepEvent(event);
    } else if (event is AnswerInputEvent) {
      yield onAnswerInputEvent(event);
    }
  }

  FormBlocState onGoToStepEvent(GoToStepEvent event) {
    return FormBlocState(state.questions, event.currentStep);
  }

  FormBlocState onNextStepEvent(NextStepEvent event) {
    return FormBlocState(state.questions, min(state.currentStep + 1, state.maxStep));
  }

  FormBlocState onAnswerInputEvent(AnswerInputEvent event) {
    String questionId = event.questionId;
    Function(Question) applyEvent = (Question q) => q.id == questionId ? q.onEvent(event) : q; //DONOW delegate event to app
    List<Question> questionsAfterEvent = state.questions.map<Question>(applyEvent).toList();
    return FormBlocState(questionsAfterEvent, state.currentStep);
  }

  @override
  FormBlocState fromJson(Map<String, dynamic> json) {
    // Called when trying to read cached state from storage.
    // Be sure to handle any exceptions that can occur and return null
    // to indicate that there is no cached data.
    if (json == null) return null;

    return FormBlocState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(FormBlocState form) {
    // Called on each state change (transition)
    // If it returns null, then no cache updates will occur.
    // Otherwise, the returned value will be cached.
    return form.toJson();
  }
}
