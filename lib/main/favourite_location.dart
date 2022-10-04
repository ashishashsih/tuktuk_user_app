import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ridy/address/address_details_view.dart';
import 'package:ridy/address/address_list_view.dart';
import 'package:ridy/graphql/generated/graphql_api.graphql.dart';
import 'package:ridy/location_selection/welcome_card/welcome_card_view.dart';
import 'package:ridy/main/bloc/current_location_cubit.dart';
import 'package:ridy/main/bloc/main_bloc.dart';
import 'package:ridy/main/bloc/rider_profile_cubit.dart';

class FavouriteLocation extends StatelessWidget {
  const FavouriteLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: BlocBuilder<RiderProfileCubit, GetCurrentOrder$Query$Rider?>(
              builder: (context, state) {
            if (state == null) {
              return const SizedBox();
            }
            return Query(
              options: QueryOptions(document: GET_ADDRESSES_QUERY_DOCUMENT),
              builder: (QueryResult result,
                  {Refetch? refetch, FetchMore? fetchMore}) {
                if (result.isLoading) {
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                }
                final addresses = result.data != null
                    ? GetAddresses$Query.fromJson(result.data!).riderAddresses
                    : <GetAddresses$Query$RiderAddress>[];
                return Column(
                  children: [
                    Container(
                      constraints: const BoxConstraints(maxHeight: 150),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: addresses
                              .map(
                                (GetAddresses$Query$RiderAddress address) =>
                                    WelcomeCardSavedLocationButton(
                                  onTap: () {
                                    final currentLocation = context
                                        .read<CurrentLocationCubit>()
                                        .state;
                                    if (currentLocation == null) {
                                      showLocationNotDeterminedDialog(context);
                                      return;
                                    }
                                    context.read<MainBloc>().add(
                                          ShowPreview(
                                            points: [
                                              currentLocation,
                                              address.toFullLocation()
                                            ],
                                            selectedOptions: [],
                                          ),
                                        );
                                  },
                                  type: address.type,
                                  address: address.details,
                                ),
                              )
                              .toList(),
                        ),
                      ),
                    ),
                    AddressListAddLocationButton(
                      onTap: () async {
                        final currentLocation =
                            context.read<CurrentLocationCubit>().state;
                        await showBarModalBottomSheet(
                          context: context,
                          builder: (_) {
                            return BlocProvider.value(
                                value: BlocProvider.of<CurrentLocationCubit>(
                                    context),
                                child: AddressDetailsView(
                                    currentLocation: currentLocation));
                          },
                        );
                        refetch!();
                      },
                    )
                  ],
                );
              },
            );
          }),
        ),
      ),
    );
  }

  void showLocationNotDeterminedDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Location"),
            content: const Text(
                "We were not able to get your current location using your device's GPS, Please check device location permission for app from device's settings. Alternatively you can use search field above to select your pickup point."),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("OK", textAlign: TextAlign.end))
            ],
          );
        });
  }
}
