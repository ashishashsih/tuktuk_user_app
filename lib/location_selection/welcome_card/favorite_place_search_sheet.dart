import 'dart:async';
import 'package:client_shared/config.dart';
import 'package:client_shared/map_providers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:osm_nominatim/osm_nominatim.dart';
import 'package:ridy/location_selection/welcome_card/place_search_sheet_view.dart';
import 'package:client_shared/components/marker_new.dart';
import 'package:velocity_x/velocity_x.dart';

class FavoritePlaceConfirmSheetView extends StatefulWidget {
  final FullLocation? defaultLocation;

  const FavoritePlaceConfirmSheetView(this.defaultLocation, {Key? key})
      : super(key: key);

  @override
  State<FavoritePlaceConfirmSheetView> createState() =>
      _FavoritePlaceConfirmSheetViewState();
}

class _FavoritePlaceConfirmSheetViewState
    extends State<FavoritePlaceConfirmSheetView> {
  final MapController mapController = MapController();
  TextEditingController textEditingController = TextEditingController();

  String? address;
  late StreamSubscription<MapEvent> subscription;
  LatLng? center;

  @override
  void initState() {
    address ??= widget.defaultLocation?.address;
    mapController.onReady.then((value) {
      center = mapController.center;
      subscription =
          mapController.mapEventStream.listen((MapEvent mapEvent) async {
        if (mapEvent is MapEventMoveStart) {
          setState(() {
            address = null;
          });
        } else if (mapEvent is MapEventMoveEnd) {
          final reverseSearchResult = await Nominatim.reverseSearch(
              lat: mapController.center.latitude,
              lon: mapController.center.longitude,
              nameDetails: true);
          final fullLocation = reverseSearchResult.convertToFullLocation();
          center = mapController.center;
          if (!mounted) return;
          setState(() {
            address = fullLocation.address;
          });
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back_ios_rounded,
                ),
              ),
              Text(
                "Back",
                style: TextStyle(),
              ),
            ],
          ),
          Text(
            "Name your favourite location",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: "google_fonts/DaysOne-Regular.ttf",
            ),
          ),
          SizedBox(
            height: 10,
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 8),
            onPressed: () {},
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xffECF4F0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: Color(0xffACACAC),
                  ),
                  Expanded(
                    child: TextField(
                      controller: TextEditingController(),
                      onTap: () {},
                      onChanged: (value) async {},
                      decoration: noBorderInputDecoration.copyWith(
                        hintText: "Title",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          CupertinoButton(
            padding: const EdgeInsets.symmetric(vertical: 8),
            onPressed: () {},
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xffECF4F0),
                borderRadius: BorderRadius.circular(5),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 8,
                    backgroundColor: Color(0xffACACAC),
                  ),
                  Text(
                    "Type",
                    style: TextStyle(
                      color: Color(0xffACACAC),
                    ),
                  ).pOnly(left: 8),
                  Spacer(),
                  Icon(
                    Icons.keyboard_arrow_down_sharp,
                    color: Color(0xff3B7B3F),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Expanded(
            child: FlutterMap(
              mapController: mapController,
              options: MapOptions(
                maxZoom: 20,
                zoom: 16,
                center: widget.defaultLocation?.latlng ?? fallbackLocation,
                interactiveFlags: InteractiveFlag.drag |
                    InteractiveFlag.pinchMove |
                    InteractiveFlag.pinchZoom |
                    InteractiveFlag.doubleTapZoom,
              ),
              children: [
                if (mapProvider == MapProvider.openStreetMap ||
                    (mapProvider == MapProvider.googleMap &&
                        mapBoxAccessToken.isEmptyOrNull))
                  TileLayerWidget(
                    options: openStreetTileLayer,
                  ),
                if (mapProvider == MapProvider.mapBox ||
                    (mapProvider == MapProvider.googleMap &&
                        !mapBoxAccessToken.isEmptyOrNull))
                  TileLayerWidget(
                    options: mapBoxTileLayer,
                  ),
                LocationMarkerLayerWidget(
                  options: LocationMarkerLayerOptions(),
                  plugin: const LocationMarkerPlugin(
                      centerOnLocationUpdate: CenterOnLocationUpdate.never),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 63),
                    child: MarkerNew(address: address),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              minimum: const EdgeInsets.all(16),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.06,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xffF4D206),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: GestureDetector(
                  onTap: () {},
                  child: Center(
                    child: const Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
