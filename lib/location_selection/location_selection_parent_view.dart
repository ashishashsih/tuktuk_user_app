import 'dart:async';
import 'package:client_shared/config.dart';
import 'package:client_shared/map_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:hive/hive.dart';
import 'package:lifecycle/lifecycle.dart';
import 'package:lottie/lottie.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:ridy/location_selection/reservation_messages/looking_sheet_view.dart';
import 'package:ridy/location_selection/welcome_card/place_search_sheet_view.dart';
import 'package:ridy/main/bloc/current_location_cubit.dart';
import 'package:ridy/main/bloc/jwt_cubit.dart';
import 'package:ridy/main/bloc/rider_profile_cubit.dart';
import 'package:ridy/main/drawer.dart';
import 'package:ridy/main/map_providers/google_map_provider.dart';
import 'package:ridy/main/map_providers/open_street_map_provider.dart';
import 'package:ridy/main/pay_for_ride_sheet_view.dart';
import 'package:ridy/main/rate_ride_sheet_view.dart';
import 'package:client_shared/theme/theme.dart';
import '../graphql/generated/graphql_api.graphql.dart';
import '../main/bloc/main_bloc.dart';
import '../main/order_status_sheet_view.dart';
import '../main/service_selection_card_view.dart';
import 'welcome_card/welcome_card_view.dart';
import 'package:velocity_x/velocity_x.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class LocationSelectionParentView extends StatefulWidget {
  const LocationSelectionParentView({Key? key}) : super(key: key);

  @override
  State<LocationSelectionParentView> createState() =>
      _LocationSelectionParentViewState();
}

class _LocationSelectionParentViewState
    extends State<LocationSelectionParentView> {
  late GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController textEditingController = TextEditingController();

  Refetch? refetch;
  MapController? controller;

  int? isSelected;
  bool? selected;
  bool isSwitch = false;
  bool isPaySwitch = false;
  bool hideBottomSheet = true;

  Future bottomSheet() async {
    await Future.delayed(
      const Duration(seconds: 2),
      () {
        Navigator.pop(context);
        showModalBottomSheet(
          context: context,
          builder: (context) {
            return StatefulBuilder(
              builder: (context, setState) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            "Payment Method",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text(
                            "Select your payment method",
                            style: TextStyle(
                              fontSize: 11,
                              color: Color(0xff979797),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "TukTuk Pay",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: [
                              Image.asset(
                                "images/marker_logo.png",
                                scale: 0.5,
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    "TukTuk Pay",
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "0.00 Rs",
                                    style: TextStyle(
                                      fontSize: 11,
                                      color: Color(0xff979797),
                                    ),
                                  ),
                                ],
                              ),
                              Spacer(),
                              CupertinoSwitch(
                                value: isPaySwitch,
                                onChanged: (val) {
                                  setState(() {
                                    isPaySwitch = val;
                                  });
                                },
                              ),
                            ],
                          ),
                          const Text(
                            "Payment method",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: const [
                              Icon(
                                Icons.currency_rupee,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Cash",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                              showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 15),
                                      child: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            const Text(
                                              "Add Payment Method",
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const Text(
                                              "Select your payment method",
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Color(0xff979797),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return SingleChildScrollView(
                                                      child: AnimatedPadding(
                                                        padding: MediaQuery.of(
                                                                context)
                                                            .viewInsets,
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    100),
                                                        curve:
                                                            Curves.decelerate,
                                                        child: Container(
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    horizontal:
                                                                        15),
                                                            child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                SizedBox(
                                                                  height: 10,
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceBetween,
                                                                  children: [
                                                                    Text(
                                                                      "Paytm",
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            20,
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                        fontFamily:
                                                                            "google_fonts/DaysOne-Regular.ttf",
                                                                      ),
                                                                    ),
                                                                    GestureDetector(
                                                                      onTap:
                                                                          () {
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .close,
                                                                        size:
                                                                            30,
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                                Text(
                                                                  "Type your paytm code",
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        16,
                                                                    color: Color(
                                                                        0xff9A9A9A),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                                Container(
                                                                  height: 50,
                                                                  color: Color(
                                                                      0xffECF4F0),
                                                                  child:
                                                                      TextFormField(
                                                                    controller:
                                                                        textEditingController,
                                                                    keyboardType:
                                                                        TextInputType
                                                                            .text,
                                                                    decoration:
                                                                        const InputDecoration(
                                                                      border:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide.none,
                                                                      ),
                                                                      disabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide.none,
                                                                      ),
                                                                      enabledBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide.none,
                                                                      ),
                                                                      focusedBorder:
                                                                          OutlineInputBorder(
                                                                        borderSide:
                                                                            BorderSide.none,
                                                                      ),
                                                                      fillColor:
                                                                          Color(
                                                                              0xffECF4F0),
                                                                      filled:
                                                                          true,
                                                                      isDense:
                                                                          true,
                                                                      hintText:
                                                                          "Enter eight digit code",
                                                                      helperStyle:
                                                                          TextStyle(
                                                                        color: Color(
                                                                            0xffACACAC),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                const SizedBox(
                                                                  height: 20,
                                                                ),
                                                                GestureDetector(
                                                                  onTap: () {
                                                                    if (textEditingController
                                                                        .text
                                                                        .isNotEmpty) {}
                                                                  },
                                                                  child:
                                                                      Container(
                                                                    height: MediaQuery.of(context)
                                                                            .size
                                                                            .height *
                                                                        0.06,
                                                                    width: double
                                                                        .infinity,
                                                                    decoration:
                                                                        BoxDecoration(
                                                                      color: Colors
                                                                          .yellow,
                                                                      borderRadius:
                                                                          BorderRadius.circular(
                                                                              30),
                                                                    ),
                                                                    child:
                                                                        Center(
                                                                      child:
                                                                          Text(
                                                                        "Done",
                                                                        style:
                                                                            TextStyle(
                                                                          fontSize:
                                                                              16,
                                                                          color: textEditingController.text.isNotEmpty
                                                                              ? Colors.black
                                                                              : Colors.black.withOpacity(0.5),
                                                                          fontWeight:
                                                                              FontWeight.bold,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                                SizedBox(
                                                                  height: 30,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  Text(
                                                    "Paytm",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                  Icon(
                                                    Icons.arrow_forward_ios,
                                                    color: Color(0xff979797),
                                                    size: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Google Pay",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Color(0xff979797),
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Credit or debit card",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Color(0xff979797),
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 15,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: const [
                                                Text(
                                                  "Amazon pay",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Color(0xff979797),
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: const [
                                                Text(
                                                  "PhonePe",
                                                  style: TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.arrow_forward_ios,
                                                  color: Color(0xff979797),
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                            const SizedBox(
                                              height: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.add,
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Text(
                                  "Add payment method",
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            "Vouchers",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          Row(
                            children: const [
                              Icon(
                                Icons.add,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                "Add vouchers",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    final mainBloc = context.read<MainBloc>();
    final jwt = Hive.box('user').get('jwt').toString();
    if (!jwt.isEmptyOrNull) {
      context.read<JWTCubit>().login(jwt);
    }
    return Scaffold(
      key: scaffoldKey,
      drawer: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Drawer(
          backgroundColor: Colors.white,
          child: DrawerView(),
        ),
      ),
      body: Stack(children: [
        if (mapProvider == MapProvider.mapBox ||
            mapProvider == MapProvider.openStreetMap)
          const OpenStreetMapProvider(),
        if (mapProvider == MapProvider.googleMap) const GoogleMapProvider(),
        LifecycleWrapper(
          onLifecycleEvent: (event) {
            if (event == LifecycleEvent.visible && refetch != null) {
              refetch!();
            }
          },
          child: FutureBuilder<PackageInfo>(
              future: PackageInfo.fromPlatform(),
              builder: (context, snapshot) {
                return BlocBuilder<JWTCubit, String?>(
                    builder: (context, jwtState) {
                  return Query(
                      options: QueryOptions(
                          document: GET_CURRENT_ORDER_QUERY_DOCUMENT,
                          variables: GetCurrentOrderArguments(
                                  versionCode: int.parse(
                                      snapshot.data?.buildNumber ?? "99999"))
                              .toJson(),
                          fetchPolicy: FetchPolicy.noCache),
                      builder: (QueryResult result,
                          {Refetch? refetch, FetchMore? fetchMore}) {
                        if (result.isLoading) {
                          return const Center(
                            child: CircularProgressIndicator.adaptive(),
                          );
                        }
                        this.refetch = refetch;
                        final query = result.data != null
                            ? GetCurrentOrder$Query.fromJson(result.data!)
                            : null;
                        if (result.data != null && query != null) {
                          context
                              .read<RiderProfileCubit>()
                              .updateProfile(query.rider!);
                          if (query.requireUpdate ==
                              VersionStatus.mandatoryUpdate) {
                            mainBloc
                                .add(VersionStatusEvent(query.requireUpdate));
                          } else {
                            mainBloc.add(
                              ProfileUpdated(
                                profile: query.rider!,
                                driverLocation:
                                    query.getCurrentOrderDriverLocation,
                              ),
                            );
                          }
                        }

                        return const SizedBox();
                      });
                });
              }),
        ),
        BlocBuilder<MainBloc, MainBlocState>(builder: (context, state) {
          return Stack(children: [
            if (state is OrderPreview)
              SmallBackFloatingActionButton(
                onPressed: () {
                  context.read<MainBloc>().add(ResetState());
                  setState(() {
                    hideBottomSheet = true;
                  });
                },
              ),
            if (state is OrderPreview && hideBottomSheet == true)
              Positioned(
                bottom: 0,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: [
                      BoxShadow(
                        color: Color(0xff0000004A),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.03,
                        ),
                        Text(
                          "TukTuk Electric Auto",
                          style: TextStyle(
                            fontSize: 23,
                            fontWeight: FontWeight.bold,
                            fontFamily: "google_fonts/DaysOne-Regular.ttf",
                          ),
                        ),
                        Text(
                          "Choose your preference",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff9A9A9A),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        ListView.builder(
                          padding: EdgeInsets.zero,
                          shrinkWrap: true,
                          itemCount: auto.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 5,
                              ),
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isSelected = index;
                                  });
                                  selected = true;
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    vertical: 5,
                                    horizontal: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: isSelected == index
                                        ? Color(0xffF4D206).withOpacity(0.5)
                                        : Colors.transparent,
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "${auto[index].title}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                        ),
                                      ),
                                      Text(
                                        "${auto[index].price}",
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        selected == true
                            ? Divider(
                                color: Colors.grey.withOpacity(0.3),
                                height: 2,
                              )
                            : SizedBox(),
                        SizedBox(
                          height: 10,
                        ),
                        selected == true
                            ? Text(
                                "Ride Preference",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : SizedBox(),
                        selected == true
                            ? Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Luggage",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                    CupertinoSwitch(
                                      value: isSwitch,
                                      onChanged: (val) {
                                        setState(() {
                                          isSwitch = val;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox(),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.025,
                        ),
                        GestureDetector(
                          onTap: () {
                            showModalBottomSheet<void>(
                              // isScrollControlled: true,
                              context: context,
                              builder: (BuildContext context) {
                                return SingleChildScrollView(
                                  child: AnimatedPadding(
                                    padding: MediaQuery.of(context).viewInsets,
                                    duration: const Duration(milliseconds: 100),
                                    curve: Curves.decelerate,
                                    child: Container(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 15),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  "Coupon Code",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily:
                                                        "google_fonts/DaysOne-Regular.ttf",
                                                  ),
                                                ),
                                                Icon(
                                                  Icons.close,
                                                  size: 30,
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "Type your coupon code to be applied",
                                              style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xff9A9A9A),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                            Container(
                                              height: 50,
                                              color: Color(0xffECF4F0),
                                              child: Row(
                                                children: [
                                                  Image.asset(
                                                    "images/Edit.png",
                                                  ),
                                                  Expanded(
                                                    child: TextFormField(
                                                      controller:
                                                          textEditingController,
                                                      keyboardType:
                                                          TextInputType.text,
                                                      decoration:
                                                          const InputDecoration(
                                                        border:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                        disabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                        enabledBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                        focusedBorder:
                                                            OutlineInputBorder(
                                                          borderSide:
                                                              BorderSide.none,
                                                        ),
                                                        fillColor:
                                                            Color(0xffECF4F0),
                                                        filled: true,
                                                        isDense: true,
                                                        hintText:
                                                            "Enter coupon code",
                                                        helperStyle: TextStyle(
                                                          color:
                                                              Color(0xffACACAC),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                if (textEditingController
                                                    .text.isNotEmpty) {}
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.yellow,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Apply",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color:
                                                          textEditingController
                                                                  .text
                                                                  .isNotEmpty
                                                              ? Colors.black
                                                              : Colors.black
                                                                  .withOpacity(
                                                                      0.5),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 30,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.yellow,
                                width: 2,
                              ),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: const Center(
                              child: Text(
                                "Coupon Code",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.yellow,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.02,
                        ),
                        GestureDetector(
                          onTap: () {
                            if (selected == true) {
                              setState(() {
                                hideBottomSheet = false;
                              });
                              showModalBottomSheet(
                                isDismissible: false,
                                context: context,
                                builder: (context) {
                                  return SingleChildScrollView(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                SizedBox(
                                                  height: 10,
                                                ),
                                                Text(
                                                  "Ride Requested",
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Spacer(),
                                                Lottie.asset(
                                                  "images/loading.json",
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.3,
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.07,
                                                ),
                                                Image.asset(
                                                  "images/Auto_Designed.png",
                                                ),
                                              ],
                                            ),
                                            Text(
                                              "We are looking for nearest TukTuk for you.",
                                              style: TextStyle(
                                                fontSize: 11,
                                                fontWeight: FontWeight.normal,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.pop(context);
                                                showModalBottomSheet(
                                                  context: context,
                                                  builder: (context) {
                                                    return Container(
                                                      child:
                                                          SingleChildScrollView(
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .symmetric(
                                                                  horizontal:
                                                                      20),
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Row(
                                                                children: [
                                                                  SizedBox(
                                                                    height: 10,
                                                                  ),
                                                                  Text(
                                                                    "Ride Avaliable",
                                                                    style:
                                                                        TextStyle(
                                                                      fontSize:
                                                                          20,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                    ),
                                                                  ),
                                                                  Spacer(),
                                                                  Image.asset(
                                                                    "images/Auto_Designed.png",
                                                                  ),
                                                                ],
                                                              ),
                                                              Text(
                                                                "We are looking for nearest TukTuk for you.",
                                                                style:
                                                                    TextStyle(
                                                                  fontSize: 11,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 20,
                                                              ),
                                                              Center(
                                                                child: Icon(
                                                                  Icons.done,
                                                                  size: 30,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                              ),
                                                              SizedBox(
                                                                height: 30,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                );
                                                bottomSheet();
                                              },
                                              child: Container(
                                                height: MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                    0.06,
                                                width: double.infinity,
                                                decoration: BoxDecoration(
                                                  color: Colors.yellow,
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    "Cancel",
                                                    style: TextStyle(
                                                      fontSize: 16,
                                                      color: selected == true
                                                          ? Colors.black
                                                          : Colors.black
                                                              .withOpacity(0.5),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height * 0.06,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Center(
                              child: Text(
                                "Book now",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: selected == true
                                      ? Colors.black
                                      : Colors.black.withOpacity(0.5),
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
            if (state is SelectingPoints)
              MenuButton(
                onPressed: () {
                  scaffoldKey.currentState?.openDrawer();
                },
                bookingCount: state.bookingsCount,
              ),
            Container(
              constraints: const BoxConstraints(maxWidth: 500),
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.width >
                          CustomTheme.tabletBreakpoint
                      ? 16
                      : 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (state is SelectingPoints) const WelcomeCardView(),
                  if (state is OrderPreview) const ServiceSelectionCardView(),
                  if (state is StateWithActiveOrder)
                    Subscription(
                      options: SubscriptionOptions(
                          document: UPDATED_ORDER_SUBSCRIPTION_DOCUMENT,
                          fetchPolicy: FetchPolicy.noCache),
                      builder: (QueryResult result) {
                        if (result.data != null) {
                          final order =
                              GetCurrentOrder$Query$Rider$Order.fromJson(
                                  result.data!['orderUpdated']);
                          WidgetsBinding.instance.addPostFrameCallback((_) {
                            mainBloc.add(CurrentOrderUpdated(order));
                          });
                        }
                        if (state is OrderInProgress) {
                          return const OrderStatusSheetView();
                        }
                        if (state is OrderInvoice) {
                          return Mutation(
                              options: MutationOptions(
                                  document: UPDATE_ORDER_MUTATION_DOCUMENT),
                              builder: (RunMutation runMutation,
                                  QueryResult? result) {
                                return PayForRideSheetView(
                                  onClosePressed: state.order.status ==
                                          OrderStatus.waitingForPostPay
                                      ? null
                                      : () async {
                                          final result = await runMutation(
                                                  UpdateOrderArguments(
                                                          id: state.order.id,
                                                          update: UpdateOrderInput(
                                                              status: OrderStatus
                                                                  .riderCanceled,
                                                              waitMinutes: 0,
                                                              tipAmount: 0))
                                                      .toJson())
                                              .networkResult;
                                          final order =
                                              UpdateOrder$Mutation.fromJson(
                                                  result!.data!);
                                          mainBloc.add(CurrentOrderUpdated(
                                              order.updateOneOrder));
                                        },
                                  order: state.order,
                                );
                              });
                        }
                        if (state is OrderReview) {
                          return const RateRideSheetView();
                        }
                        if (state is OrderLooking) {
                          return const LookingSheetView();
                        }
                        return const Text("Unacceptable state");
                      },
                    ),
                ],
              ),
            ).centered()
          ]);
        })
      ]),
    );
  }

  void setCurrentLocation(BuildContext context, Position position) async {
    final geocodeResult = await Nominatim.reverseSearch(
        lat: position.latitude, lon: position.longitude, nameDetails: true);
    final fullLocation = geocodeResult.toFullLocation();
    try {
      context.read<CurrentLocationCubit>().updateLocation(fullLocation);
      // ignore: empty_catches
    } catch (error) {}
  }
}

class SmallBackFloatingActionButton extends StatelessWidget {
  final Function onPressed;

  const SmallBackFloatingActionButton({
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: FloatingActionButton.small(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 2,
        onPressed: () => onPressed(),
        backgroundColor: CustomTheme.primaryColors.shade50,
        child: Icon(
          Ionicons.arrow_back,
          color: CustomTheme.primaryColors.shade800,
        ),
      ),
    );
  }
}

class MenuButton extends StatelessWidget {
  const MenuButton({
    Key? key,
    required this.onPressed,
    required this.bookingCount,
  }) : super(key: key);

  final Function onPressed;
  final int bookingCount;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(16),
      child: FloatingActionButton(
        heroTag: 'menuFab',
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        onPressed: () => onPressed(),
        backgroundColor: Colors.white,
        child: bookingCount == 0
            ? Icon(
                Ionicons.menu,
                color: CustomTheme.primaryColors.shade800,
              )
            : Container(
                decoration: BoxDecoration(
                    color: Colors.red, borderRadius: BorderRadius.circular(50)),
                child: SizedBox(
                  width: 25,
                  height: 25,
                  child: Center(
                    child: Text(
                      bookingCount.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

extension PlaceToFullLocation on Place {
  FullLocation toFullLocation() {
    return FullLocation(
        latlng: LatLng(lat, lon),
        address: displayName,
        title: nameDetails?['name'] ?? "");
  }
}

extension PointMixinHelper on PointMixin {
  LatLng toLatLng() {
    return LatLng(lat, lng);
  }
}

extension FullLocationHelper on FullLocation {
  PointInput toPointInput() {
    return PointInput(lat: latlng.latitude, lng: latlng.longitude);
  }
}

const fitBoundsOptions = FitBoundsOptions(
    padding: EdgeInsets.only(top: 100, bottom: 500, left: 130, right: 130));

class ChooseAuto {
  final String? title;
  final String? price;
  ChooseAuto({this.title, this.price});
}

List<ChooseAuto> auto = [
  ChooseAuto(title: "This start to end Ride", price: "235 ₹"),
  ChooseAuto(price: "1005 ₹", title: "City Darshan"),
];
