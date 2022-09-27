import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridy/main/bloc/notification_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState(NotificationItem.recent, 0));

  void getNavBarItem(NotificationItem notificationItem) {
    switch (notificationItem) {
      case NotificationItem.recent:
        emit(const NavigationState(NotificationItem.recent, 0));
        break;
      case NotificationItem.lastWeek:
        emit(const NavigationState(NotificationItem.lastWeek, 1));
        break;
    }
  }
}
