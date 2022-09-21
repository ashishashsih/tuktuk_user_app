import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ridy/onboarding/onboarding_state.dart';
import 'package:ridy/onboarding/pageview_cubit.dart';

class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final PageController _pageController = PageController(initialPage: 0);

  int? currentPage = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<PageViewCubit, PageViewState>(
        builder: (context, state) {
          return Stack(
            children: [
              PageView(
                controller: _pageController,
                onPageChanged: (value) {
                  currentPage = value;
                  context.read<PageViewCubit>().changeValue(value);
                },
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.1,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Get special offers on TukTuk Full Day rides.",
                          style: TextStyle(
                            height: 1,
                            fontSize: 50,
                            color: Color(0xff2591FD),
                            fontWeight: FontWeight.bold,
                            fontFamily: "google_fonts/DaysOne-Regular.ttf",
                          ),
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "#CityDarshan",
                          style: TextStyle(
                            fontSize: 30,
                            color: Color(0xffF4D206),
                            fontWeight: FontWeight.bold,
                            fontFamily: "google_fonts/DaysOne-Regular.ttf",
                          ),
                        ),
                      ),
                      Spacer(),
                      Image.asset(
                        "images/riksho_road.png",
                        fit: BoxFit.cover,
                      ),
                    ],
                  ),
                  Container(
                    color: Color(0xff3B7B3F),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          Text(
                            "Clean and hygienic TukTuk rides.",
                            style: TextStyle(
                              height: 1,
                              fontSize: 50,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: "google_fonts/DaysOne-Regular.ttf",
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01,
                          ),
                          Text(
                            "#TheSaafSawaari",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Color(0xffF4D206),
                            ),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.1,
                          ),
                          Image.asset(
                            "images/auto.png",
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.white,
                    child: SafeArea(
                      child: Column(
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.04,
                          ),
                          Padding(
                            padding: EdgeInsets.only(left: 20, right: 70),
                            child: Text(
                              "Get the charge on the go with TukTuk.",
                              style: TextStyle(
                                height: 1.2,
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                                fontFamily: "google_fonts/DaysOne-Regular.ttf",
                                color: Color(0xff2591FD),
                              ),
                            ),
                          ),
                          Spacer(),
                          Image.asset(
                            "images/mobile.png",
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).size.width * 0.05,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    color: Color(0xff3B7B3F),
                    child: SafeArea(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                            Text(
                              "0% pollution, environment friendly ride.",
                              style: TextStyle(
                                height: 1.2,
                                fontSize: 45,
                                fontWeight: FontWeight.bold,
                                fontFamily: "google_fonts/DaysOne-Regular.ttf",
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.1,
                            ),
                            Image.asset(
                              "images/auto_charge.png",
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context)
                                    .pushNamed("locationSelectionParentView");
                              },
                              child: Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.06,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  color: Colors.yellow,
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                child: Center(
                                  child: Text(
                                    "Lets Ride A TukTuk",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.05,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 30),
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.05,
                    ),
                    Row(
                      children: List.generate(
                        4,
                        (index) => Container(
                          height: MediaQuery.of(context).size.height * 0.015,
                          width: MediaQuery.of(context).size.width * 0.03,
                          margin: EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                            ),
                            color: currentPage == index
                                ? Colors.black
                                : Colors.white,
                            borderRadius: BorderRadius.circular(7.5),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
