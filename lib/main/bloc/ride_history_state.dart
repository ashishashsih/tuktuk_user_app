import 'package:equatable/equatable.dart';

enum RideHistoryItem { bookedRides, pastActivity }

class RideHistoryItemState extends Equatable {
  final RideHistoryItem rideHistoryItem;
  final int index;

  const RideHistoryItemState(this.rideHistoryItem, this.index);

  @override
  List<Object> get props => [this.rideHistoryItem, this.index];
}
