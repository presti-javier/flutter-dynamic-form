import 'package:flutterapp/ui/state/form_page.dart';

class FormBlocState {
  static const String PAGES = 'pages';
  static const CURRENT_STEP = 'current_step';

  final List<FormPage> pages;
  final int currentStep;
  FormPage get currentPage => pages[currentStep];
  FormPage get nextPage => pages[currentStep + 1];

  const FormBlocState(this.pages, [this.currentStep = 0]);

  static FormBlocState fromJson(Map<String, dynamic> json) {
    List<FormPage> pages = List();
    (json[PAGES] as List).forEach((e) {
      pages.add(FormPage.fromJson(Map<String, dynamic>.from(e)));
    });
    return FormBlocState(pages, json[CURRENT_STEP]);
  }

  bool isInLastPage() {
    return currentStep == pages.length - 1;
  }

  Map<String, dynamic> toJson() {
    List<Map<String, dynamic>> pagesList = pages.map((e) => e.toJson()).toList();
    return {PAGES: pagesList, CURRENT_STEP: currentStep};
  }
}
