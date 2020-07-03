import 'package:flutterapp/ui/bloc_state/step_state.dart';
import 'package:flutterapp/ui/bloc_state/stepper_state.dart';
import 'package:flutterapp/ui/events/stepper_event.dart';
import 'package:flutterapp/utils/immutable_utils.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class StepperBloc extends HydratedBloc<StepperEvent, StepperState> {
  @override
  StepperState get initialState {
    StepperState initialState = super.initialState;
    if (initialState != null) return initialState;

    List<StepBlocState> steps = [
      StepBlocState(title: 'Pagina 1', state: PageState.editing),
      StepBlocState(title: 'Pagina 2'),
      StepBlocState(title: 'Pagina 3'),
    ];
    return StepperState(steps);
  }

  @override
  Stream<StepperState> mapEventToState(StepperEvent event) async* {
    if (event is GoToStepEvent) {
      yield onGoToStepEvent(event);
    } else if (event is NextStepEvent) {
      yield onNextStepEvent(event);
    }
  }

  StepperState onGoToStepEvent(GoToStepEvent event) {
    int stepPos = event.currentStep;
    //If we try to goTo to our current page, we just return the same state
    if (stepPos == state.currentStepPos) return state;

    return StepperState(state.steps, stepPos);
  }

  StepperState onNextStepEvent(NextStepEvent event) {
    if (state.isInLastPage()) {
      return state;
    } else {
      StepBlocState currentStep = state.currentStep;
      StepBlocState newCurrentStep = StepBlocState(title: currentStep.title, state: PageState.completed);
      StepBlocState nextStep = state.nextStep;
      StepBlocState newNextPage = StepBlocState(title: nextStep.title, state: PageState.init);
      List<StepBlocState> steps =
          state.steps.replace(currentStep, newCurrentStep).replace(nextStep, newNextPage);
      return StepperState(steps, state.currentStepPos + 1);
    }
  }

  @override
  StepperState fromJson(Map<String, dynamic> json) {
    // Called when trying to read cached state from storage.
    // Be sure to handle any exceptions that can occur and return null
    // to indicate that there is no cached data.
    if (json == null) return null;

    return StepperState.fromJson(json);
  }

  @override
  Map<String, dynamic> toJson(StepperState stepperState) {
    // Called on each state change (transition)
    // If it returns null, then no cache updates will occur.
    // Otherwise, the returned value will be cached.
    return stepperState.toJson();
  }
}
