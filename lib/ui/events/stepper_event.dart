import 'package:flutterapp/ui/events/answer_event.dart';

mixin StepperEvent {
}

class GoToStepEvent with FormEvent, StepperEvent {
  final int currentStep;

  const GoToStepEvent(this.currentStep);
}

class NextStepEvent with FormEvent, StepperEvent {
  const NextStepEvent();
}
