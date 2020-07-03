import 'package:meta/meta.dart';

class StepBlocState {
  static const String TITLE = 'title';
  static const String STATE = 'state';

  final String title;
  final PageState state;

  const StepBlocState({@required this.title, this.state = PageState.init});

  static StepBlocState fromJson(Map<String, dynamic> json) {
    return StepBlocState(
      title: json[TITLE],
      state: PageState.get(json[STATE]),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      TITLE: title,
      STATE: state.toString(),
    };
  }
}

enum FormPageState {
  init,
  editing,
  completed,
  uncompleted,
}

class PageState {

  final String _id;

  const PageState._(this._id);

  static const PageState init = PageState._('init');
  static const PageState editing = PageState._('editing');
  static const PageState completed = PageState._('completed');
  static const PageState uncompleted = PageState._('uncompleted');

  static Map<String, PageState> _map;

  static PageState get(String name) {
    if (_map == null) {
      _map = {
        init._id: init,
        editing._id: editing,
        completed._id: completed,
        uncompleted._id: uncompleted,
      };
    }
    return _map[name];
  }

  @override
  String toString() {
    return _id;
  }
}
