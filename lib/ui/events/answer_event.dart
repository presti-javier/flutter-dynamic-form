mixin FormEvent {}

abstract class AnswerInputEvent with FormEvent {
  final String questionId;

  const AnswerInputEvent(this.questionId);
}

class StringAnswerInputEvent extends AnswerInputEvent {
  final String answer;
  final bool validForm;

  const StringAnswerInputEvent(String questionId, this.answer, this.validForm) : super(questionId);
}
