import 'package:flutterapp/domain/question.dart';
import 'package:flutterapp/remote/question_server.dart';
import 'package:flutterapp/ui/events/answer_event.dart';
import 'package:flutterapp/ui/state/question_state.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class QuestionBloc extends HydratedBloc<QuestionEvent, Question> {

  Question _question;

  QuestionBloc(this._question);

  @override
  String get id => _question.id;

  @override
  Question get initialState {
    Question initialState = super.initialState;
    if (initialState != null) {
      _question = initialState;
      return initialState;
    }
    //LATER fetch question here instead of having a _question field
    return _question;
  }

  @override
  Stream<Question> mapEventToState(QuestionEvent event) async* {
    if (event is StringAnswerInputEvent) {
      yield onStringAnswerInputEvent(event);
    }
  }

  Question onStringAnswerInputEvent(StringAnswerInputEvent event) {
    String answer = event.answer;
    TextQuestion question = TextQuestion.fromJson(state.toJson()
      ..[TextQuestion.ANSWER] = answer);
    return question;
  }

  @override
  Question fromJson(Map<String, dynamic> json) {
    // Called when trying to read cached state from storage.
    // Be sure to handle any exceptions that can occur and return null
    // to indicate that there is no cached data.
    if (json == null) return null;

    return Question.fromJsonStatic(json);
  }

  @override
  Map<String, dynamic> toJson(Question questionState) {
    // Called on each state change (transition)
    // If it returns null, then no cache updates will occur.
    // Otherwise, the returned value will be cached.
    return questionState.toJson();
  }
}
