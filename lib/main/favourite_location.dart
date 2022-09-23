import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:ridy/location_selection/welcome_card/favorite_place_search_sheet.dart';
import 'package:ridy/main/bloc/current_location_cubit.dart';

import '../location_selection/welcome_card/place_confirm_sheet_view.dart';
import '../location_selection/welcome_card/place_search_sheet_view.dart';

class FavouriteLocation extends StatelessWidget {
  const FavouriteLocation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios,
                  size: 20,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                "Favourite Locations",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: "google_fonts/DaysOne-Regular.ttf",
                ),
              ),
              Text(
                "Set your favourite locations",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xff9A9A9A),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Divider(
                color: Color(0xff9A9A9A),
              ),
              SizedBox(
                height: 20,
              ),
              GestureDetector(
                onTap: () async {
                  await showBarModalBottomSheet<FullLocation>(
                    enableDrag: false,
                    context: context,
                    builder: (context) {
                      return FavoritePlaceConfirmSheetView(
                        context.read<CurrentLocationCubit>().state,
                      );
                    },
                  );
                },
                child: Row(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.14,
                      color: Color(0xffECF4F0),
                      child: Icon(
                        Icons.add,
                        color: Colors.green,
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.05,
                    ),
                    Text(
                      "Add Favourite Location",
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
