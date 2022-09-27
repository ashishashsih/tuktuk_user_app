import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridy/main/bloc/notification_evnt.dart';
import 'package:ridy/main/bloc/notification_state.dart';

class NotificationScreen extends StatelessWidget {
  List<String> title = [
    'Recent',
    'Last week',
  ];

  int selected = 0;
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
              Text(
                "Notifications",
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
                child: BlocBuilder<NavigationCubit, NavigationState>(
                  builder: (context, state) {
                    return Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: Row(
                        children: List.generate(
                          2,
                          (index) => Expanded(
                            child: GestureDetector(
                              onTap: () {
                                selected = index;
                                if (index == 0) {
                                  BlocProvider.of<NavigationCubit>(context)
                                      .getNavBarItem(NotificationItem.recent);
                                } else if (index == 1) {
                                  BlocProvider.of<NavigationCubit>(context)
                                      .getNavBarItem(NotificationItem.lastWeek);
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
                                              : FontWeight.normal),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color(0xff29BF79),
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Karan Kolhi",
                        style: TextStyle(
                          color: Color(0xff979797),
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Ride verification code: 2670",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "MH 12 AU 2748",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
