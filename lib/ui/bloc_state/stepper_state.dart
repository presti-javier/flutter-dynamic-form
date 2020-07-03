import 'package:flutterapp/ui/bloc_state/step_state.dart';

class StepperState {
  static const String STEPS = 'steps';
  static const CURRENT_STEP = 'current_step';

  final List<StepBlocState> steps;
  final int currentStepPos;
  StepBlocState get currentStep => steps[currentStepPos];
  StepBlocState get nextStep => steps[currentStepPos + 1];

  const StepperState(this.steps, [this.currentStepPos = 0]);

  static StepperState fromJson(Map<String, dynamic> json) {
    List<StepBlocState> steps = List();
    List<Map> pagesJson = json[STEPS].cast<Map>();
    pagesJson.forEach((e) {
      steps.add(StepBlocState.fromJson(Map<String, dynamic>.from(e)));
    });
    return StepperState(steps, json[CURRENT_STEP]);
  }

  bool isInLastPage() {
    return currentStepPos == steps.length - 1;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> stepsList = steps.map((e) => e.toJson()).toList();
    return <String, dynamic>{STEPS: stepsList, CURRENT_STEP: currentStepPos};
  }

}
