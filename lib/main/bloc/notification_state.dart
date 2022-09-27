import 'package:equatable/equatable.dart';

enum NotificationItem { recent, lastWeek }

class NavigationState extends Equatable {
  final NotificationItem navbarItem;
  final int index;

  const NavigationState(this.navbarItem, this.index);

  @override
  List<Object> get props => [this.navbarItem, this.index];
}
