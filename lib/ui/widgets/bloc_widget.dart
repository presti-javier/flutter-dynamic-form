import 'package:flutter/widgets.dart';

class BlocWidget<T> extends StatefulWidget {
  final T initialData;
  final Widget Function(T) builder;
  final void Function(WidgetInState<T>) onStateCreated;

  BlocWidget(this.initialData, this.builder, this.onStateCreated);

  @override
  State<StatefulWidget> createState() {
    WidgetInState<T> state = WidgetInState<T>(initialData);
    onStateCreated(state);
    return state;
  }
}

class WidgetInState<T> extends State<BlocWidget<T>> {
  T data;

  WidgetInState(this.data);

  @override
  Widget build(BuildContext context) {
    return widget.builder(data);
  }

  void rebuild(T data) {
    setState(() {
      this.data = data;
    });
  }
}
