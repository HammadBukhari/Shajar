import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:shajar/model/plant.dart';
import 'package:shajar/provider/login_provider.dart';
import 'package:shajar/provider/map_provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shajar/presentation/message_screen.dart';
import 'package:shajar/model/chat_argument.dart';

class MapScreen extends StatelessWidget {
  static const route = 'map';
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => MapProvider(),
      child: Scaffold(
        body: MapWidget(),
      ),
    );
  }
}

class MapWidget extends StatefulWidget {
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {
  BitmapDescriptor pinLocationIcon;
  Set<Marker> plantsMarkers;
  GoogleMapController mapController;
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Plant _selectedPlant;
  void onMarkerTap(Plant plant) {
    print(plant.name);
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: LatLng(plant.latitude - 0.003, plant.longitude),
        zoom: 16,
      ),
    ));
    setState(() {
      _selectedPlant = plant;
      _isCardViewVisible = true;
    });
  }

  Future<void> createMarker(BuildContext context) async {
    final plantList = await Provider.of<LoginProvider>(context, listen: false)
        .getMarkerInformation();
    List<Marker> markerList = [];
    for (final plant in plantList) {
      if (plant.donorUid !=
              Provider.of<LoginProvider>(context, listen: false)
                  .firebaseUser
                  .uid &&
          plant.status == Plant.STATUS_START) {
        markerList.add(Marker(
          icon: pinLocationIcon,
          markerId: MarkerId(plant.pid),
          position: LatLng(plant.latitude, plant.longitude),
          onTap: () => onMarkerTap(plant),
        ));
      }
    }
    setState(() {
      plantsMarkers = markerList.toSet();
    });
  }

  void onWidgetBuildCompleted(BuildContext context) async {
    pinLocationIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 2.5), 'assets/marker.png');
    await Future.delayed(Duration(seconds: 3));
    userLocation = await Provider.of<LoginProvider>(context, listen: false)
        .getCurrentLocation();
    if (userLocation != null) {
      mapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(userLocation.latitude, userLocation.longitude),
          zoom: 13,
        ),
      ));
    }
    createMarker(context);
    setState(() {
      userLocation = userLocation;
    });
  }

  void startChat(
    BuildContext context,
  ) {
    Navigator.pushNamed(context, MessageScreen.route,
        arguments: ChatArguments(
            appUser:
                Provider.of<LoginProvider>(context, listen: false).firebaseUser,
            plantToDiscussUid: _selectedPlant.pid,
            secondParticipantUid: _selectedPlant.donorUid));
  }

  Widget _buildPlantPanel() {
    if (_selectedPlant == null) return Container();
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _selectedPlant.pictureUrl != null
              ? ClipRRect(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24.0),
                      topRight: Radius.circular(24.0)),
                  child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: CachedNetworkImage(
                      imageUrl: _selectedPlant.pictureUrl,
                      placeholder: (context, url) =>
                          Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Icon(Icons.error),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                )
              : Container(),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
            child: Text(
              _selectedPlant.name,
              style: Theme.of(context).textTheme.headline5,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 0.0),
            child: Text(
              'Quantity: ${_selectedPlant.quantity.toString()}',
            ),
          ),
          Provider.of<LoginProvider>(context, listen: false).user.role == 1
              ? Flexible(
                  flex: 1,
                  child: Center(
                    child: RaisedButton(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Icon(Icons.message),
                          SizedBox(
                            width: 5,
                          ),
                          Text("Ask for donation"),
                        ],
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      onPressed: () => startChat(context),
                      color: Color(0xff51b055),
                      textColor: Colors.white,
                      padding: EdgeInsets.fromLTRB(9, 9, 9, 9),
                      splashColor: Colors.grey,
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => onWidgetBuildCompleted(context));
  }

  Position userLocation;

  bool _isCardViewVisible = false;
  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      GestureDetector(
        child: GoogleMap(
          buildingsEnabled: false,
          onMapCreated: _onMapCreated,
          myLocationEnabled: userLocation != null ? true : false,
          myLocationButtonEnabled: userLocation != null ? true : false,
          onTap: (latLng) {
            if (_isCardViewVisible) {
              setState(() {
                _isCardViewVisible = false;
              });
            }
          },
          markers: plantsMarkers,
          initialCameraPosition: CameraPosition(
            target: userLocation == null
                ? LatLng(0, 0)
                : LatLng(userLocation.latitude, userLocation.longitude),
            zoom: 16.0,
          ),
        ),
      ),
      Align(
        alignment: Alignment.bottomCenter,
        child: Visibility(
          visible: _isCardViewVisible,
          child: Container(
            height: MediaQuery.of(context).size.height / 2,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(24.0)),
                boxShadow: [
                  BoxShadow(
                    blurRadius: 24.0,
                    color: Colors.grey,
                    offset: Offset(0, 12),
                  ),
                ]),
            margin: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
            child: _buildPlantPanel(),
          ),
        ),
      ),
    ]);
  }
}
