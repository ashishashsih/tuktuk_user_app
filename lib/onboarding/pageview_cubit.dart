import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridy/onboarding/onboarding_state.dart';

class PageViewCubit extends Cubit<PageViewState> {
  PageViewCubit() : super(PageViewState(page: 0));

  void changeValue(int value) {
    log("1+++++++++++++++++++++++++++$value");
    emit(state.copyWith(changeState: value));
  }
}
