import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridy/main/bloc/ride_history_state.dart';

class RideHistoryCubit extends Cubit<RideHistoryItemState> {
  RideHistoryCubit()
      : super(const RideHistoryItemState(RideHistoryItem.bookedRides, 0));

  void getRideHistoryItem(RideHistoryItem rideHistoryItem) {
    switch (rideHistoryItem) {
      case RideHistoryItem.bookedRides:
        emit(const RideHistoryItemState(RideHistoryItem.bookedRides, 0));
        break;
      case RideHistoryItem.pastActivity:
        emit(const RideHistoryItemState(RideHistoryItem.pastActivity, 1));
        break;
    }
  }
}
