import 'dart:developer';

class PageViewState {
  int page = 0;

  PageViewState({required this.page}) {
    if (page > 3) {
      page = 0;
    } else {
      page = page + 1;
    }
  }

  PageViewState copyWith({required int changeState}) {
    log("2+++++++++++++++++++++++++++$changeState");
    return PageViewState(page: changeState);
  }
}
