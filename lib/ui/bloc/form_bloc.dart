import 'package:flutterapp/domain/question.dart';
import 'package:flutterapp/remote/question_server.dart';
import 'package:flutterapp/ui/events/answer_event.dart';
import 'package:flutterapp/ui/events/stepper_event.dart';
import 'package:flutterapp/ui/state/form_page.dart';
import 'package:flutterapp/ui/state/form_state.dart';
import 'package:flutterapp/ui/widgets/state_widget_builder.dart';
import 'package:flutterapp/utils/immutable_utils.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class FormBloc extends HydratedBloc<FormEvent, FormBlocState> {

  @override
  FormBlocState get initialState {
    FormBlocState initialState = super.initialState;
    if (initialState != null) return initialState;

    //LATER load questions in form
    List<FormPage> pages = [
      FormPage(title: 'pagina 1', state: PageState.editing, questions: [
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
      ]),
      FormPage(title: 'pagina 2', questions: [
        Question.fromServerQuestionStatic(ServerQuestion({
          ServerQuestion.QUESTION_TYPE: "text",
          ServerQuestion.ID: "20",
          ServerQuestion.MANDATORY: true,
          ServerQuestion.TITLE: "Titulo 20",
          ServerQuestion.HINT: "Hint 20",
          ServerQuestion.ICON: null,
        })),
      ]),
      FormPage(title: 'pagina 3', questions: [
        Question.fromServerQuestionStatic(ServerQuestion({
          ServerQuestion.QUESTION_TYPE: "text",
          ServerQuestion.ID: "30",
          ServerQuestion.MANDATORY: true,
          ServerQuestion.TITLE: "Titulo 30",
          ServerQuestion.HINT: "Hint 30",
          ServerQuestion.ICON: null,
        })),
      ]),
    ];
    return FormBlocState(pages);
  }

  @override
  Stream<FormBlocState> mapEventToState(FormEvent event) async* {
    if (event is GoToStepEvent) {
      yield onGoToStepEvent(event);
    } else if (event is NextStepEvent) {
      yield onNextStepEvent(event);
    } else if (event is StringAnswerInputEvent) {
      yield onStringAnswerInputEvent(event);
    }
  }

  FormBlocState onGoToStepEvent(GoToStepEvent event) {
    FormBlocState newState = FormBlocState(state.pages, event.currentStep);
    StateWidgetBuilder.onStepperChanged(newState); //DONOW stream data
    return newState;
  }

  FormBlocState onNextStepEvent(NextStepEvent event) {
    if (state.isInLastPage()) {
      return state;
    } else {
      FormPage currentPage = state.currentPage;
      FormPage newCurrentPage = FormPage(
          title: currentPage.title, questions: currentPage.questions, state: PageState.completed);
      FormPage nextPage = state.nextPage;
      FormPage newNextPage =
          FormPage(title: nextPage.title, questions: nextPage.questions, state: PageState.init);
      List<FormPage> pages =
          state.pages.replace(currentPage, newCurrentPage).replace(nextPage, newNextPage);
      FormBlocState newState = FormBlocState(pages, state.currentStep + 1);
      StateWidgetBuilder.onStepperChanged(newState); //DONOW stream data
      return newState;
    }
  }

  FormBlocState onStringAnswerInputEvent(StringAnswerInputEvent event) {
    String questionId = event.questionId;
    String answer = event.answer;
    List<FormPage> pages = List();
    state.pages.forEach((page) {
      List<Question> questions = List();
      page.questions.forEach((question) {
        if (question.id == questionId) {
          assert(question is TextQuestion);
          TextQuestion newQuestion = TextQuestion.fromJson(question.toJson()..[TextQuestion.ANSWER] = answer);
          questions.add(newQuestion);
          StateWidgetBuilder.onQuestionAnswered(newQuestion); //DONOW stream data
        } else {
          questions.add(question);
        }
      });
      PageState state = event.validForm ? PageState.completed : PageState.editing;
      pages.add(FormPage(title: page.title, questions: questions, state: state));
    });
    return FormBlocState(pages, state.currentStep);
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
