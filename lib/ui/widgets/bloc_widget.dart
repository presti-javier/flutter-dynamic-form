import 'package:flutter/widgets.dart';

class BlocWidget<T> extends StatefulWidget {

  final T initialData;
  final Widget Function(T) builder;
  WidgetInState state;

  BlocWidget(this.initialData, this.builder);

  @override
  State<StatefulWidget> createState() {
    state = WidgetInState<T>(initialData);
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
