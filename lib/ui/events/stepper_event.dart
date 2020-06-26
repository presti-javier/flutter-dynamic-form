import 'package:flutterapp/ui/events/answer_event.dart';

class GoToStepEvent with FormEvent {
  final int currentStep;

  const GoToStepEvent(this.currentStep);
}

class NextStepEvent with FormEvent {
  const NextStepEvent();
}
