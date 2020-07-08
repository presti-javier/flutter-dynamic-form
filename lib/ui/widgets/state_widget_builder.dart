import 'package:flutter/widgets.dart';
import 'package:flutterapp/domain/question.dart';
import 'package:flutterapp/ui/state/form_state.dart';
import 'package:flutterapp/ui/widgets/bloc_widget.dart';

class StateWidgetBuilder {
  static const STEPPER_ID = "FormBlocStateStepper";

  // LATER: We should have List<WidgetInState> values, so we can have more than
  // one widget state for each key of this map
  static Map<String, WidgetInState> widgetStates = Map();

  static BlocWidget<Question> buildQuestionWidget(
      Question question, Widget Function(Question) builder) {
    return _buildWidget(question.id, question, builder);
  }

  static BlocWidget<FormBlocState> buildStepperWidget(
      FormBlocState state, Widget Function(FormBlocState) builder) {
    return _buildWidget(STEPPER_ID, state, builder);
  }

  static void onQuestionAnswered(Question question) {
    widgetStates[question.id].rebuild(question);
  }

  static void onStepperChanged(FormBlocState state) {
    widgetStates[STEPPER_ID].rebuild(state);
  }

  static BlocWidget<T> _buildWidget<T>(String id, T data, Widget Function(T) builder) {
    var initializer = (WidgetInState<T> state) => _initialize(id, state);
    return BlocWidget<T>(data, builder, initializer);
  }

  static void _initialize(String id, WidgetInState widgetInState) {
    widgetStates[id] = widgetInState;
  }
}
