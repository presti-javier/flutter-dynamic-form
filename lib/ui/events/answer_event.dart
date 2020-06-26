mixin FormEvent {}

abstract class AnswerInputEvent with FormEvent {
  final String questionId;

  const AnswerInputEvent(this.questionId);
}

class StringAnswerInputEvent extends AnswerInputEvent {
  final String answer;

  const StringAnswerInputEvent(String questionId, this.answer) : super(questionId);
}
