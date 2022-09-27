import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridy/main/bloc/ride_history_event.dart';
import 'package:ridy/main/bloc/ride_history_state.dart';

class RideHistory extends StatelessWidget {
  int selected = 0;
  List title = [
    "Booked Rides",
    "Past Activity",
  ];

  List bookedRide = [
    {
      "time": "10/09/22, 10:25 am",
      "price": "235 ₹",
      "address": "NH62, Ranka Nagar, sdhtry, Jodhpur District, Rajasthan...",
    },
  ];

  List pastActivity = [
    {
      "time": "10/09/22, 10:25 am",
      "price": "235 ₹",
      "address": "NH62, Ranka Nagar, sdhtry, Jodhpur District, Rajasthan...",
    },
    {
      "time": "10/09/22, 10:25 am",
      "price": "235 ₹",
      "address": "NH62, Ranka Nagar, sdhtry, Jodhpur District, Rajasthan...",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: BlocBuilder<RideHistoryCubit, RideHistoryItemState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_rounded,
                      size: 20,
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    "Ride History",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "google_fonts/DaysOne-Regular.ttf",
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.8,
                      child: Row(
                        children: List.generate(
                          2,
                          (index) => Expanded(
                            child: GestureDetector(
                              onTap: () {
                                selected = index;
                                if (index == 0) {
                                  BlocProvider.of<RideHistoryCubit>(context)
                                      .getRideHistoryItem(
                                          RideHistoryItem.bookedRides);
                                } else if (index == 1) {
                                  BlocProvider.of<RideHistoryCubit>(context)
                                      .getRideHistoryItem(
                                          RideHistoryItem.pastActivity);
                                }
                              },
                              child: Padding(
                                padding: EdgeInsets.all(1.0),
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.06,
                                  decoration: BoxDecoration(
                                    color: selected == index
                                        ? Color(0xffF4D206).withOpacity(0.2)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                  child: Center(
                                    child: Text(
                                      title[index],
                                      style: TextStyle(
                                        color: selected == index
                                            ? Colors.black
                                            : Color(0xff979797),
                                        fontWeight: selected == index
                                            ? FontWeight.bold
                                            : FontWeight.normal,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: selected == 0
                          ? bookedRide.length
                          : pastActivity.length,
                      itemBuilder: (context, index) {
                        log("=====selected======$selected");
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.asset(
                              "images/map.png",
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  selected == 0
                                      ? bookedRide[index]["time"]
                                      : pastActivity[index]["time"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  selected == 0
                                      ? bookedRide[index]["price"]
                                      : pastActivity[index]["price"],
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.black,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              selected == 0
                                  ? bookedRide[index]["address"]
                                  : pastActivity[index]["address"],
                              style: TextStyle(
                                fontSize: 12,
                                color: Color(0xff979797),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
