import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shajar/model/plant.dart';
import 'package:provider/provider.dart';
import 'package:shajar/model/user.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shajar/model/user_location_status.dart';
import 'package:shajar/presentation/chat_list_screen.dart';
import 'package:shajar/presentation/map_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:async';
import 'dart:io';
import 'package:app_settings/app_settings.dart';
import 'package:shajar/provider/login_provider.dart';

class HomeScreen extends StatefulWidget {
  static const route = 'home';

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  List<Widget> _widgets = <Widget>[
    AnimatedSwitcher(
        transitionBuilder: (Widget child, Animation<double> animation) =>
            RotationTransition(
              turns: animation,
              child: child,
            ),
        duration: const Duration(seconds: 2),
        child: ProfileWidget()),
    AnimatedSwitcher(
        transitionBuilder: (Widget child, Animation<double> animation) =>
            RotationTransition(
              turns: animation,
              child: child,
            ),
        duration: const Duration(seconds: 2),
        child: MapScreen()),
    ChatListScreen(),
  ];
  Widget _buildBottomNavigationBar(BuildContext context) {
    return SizedBox(
      height: 72.0,
      child: BottomNavigationBar(
        elevation: 8.0,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map),
            title: Text('Nearby'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.mail_outline),
            activeIcon: Icon(Icons.mail),
            title: Text('Inbox'),
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.greenAccent,
        onTap: _onItemTapped,
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: _buildBottomNavigationBar(context),
      body: IndexedStack(
        children: _widgets,
        index: _selectedIndex,
      ),
    );
  }
}

class ProfileWidget extends StatefulWidget {
  @override
  _ProfileWidgetState createState() => _ProfileWidgetState();
}

class _ProfileWidgetState extends State<ProfileWidget> {
  User user;
  bool isProgressVisible = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => onWidgetBuildCompleted(context));
  }

  Future<void> onWidgetBuildCompleted(BuildContext context) async {
    await Provider.of<LoginProvider>(context, listen: false)
        .getUserProfileFromFirebase();
    await Provider.of<LoginProvider>(context, listen: false)
        .getOngoingplantsFromFirebase();
    setState(() {
      user = Provider.of<LoginProvider>(context, listen: false).user;
      isProgressVisible = true;
    });
    Timer.periodic(Duration(seconds: 10), (timer) async {
  await Provider.of<LoginProvider>(context, listen: false)
        .getUserProfileFromFirebase();
    await Provider.of<LoginProvider>(context, listen: false)
        .getOngoingplantsFromFirebase();
    setState(() {
      user = Provider.of<LoginProvider>(context, listen: false).user;
      isProgressVisible = true;
    });
});
  }

  Widget _buildProfileAppbar(BuildContext context) {
    return AppBar(
      leading: Container(),
      centerTitle: true,
      title: Text('Shajar',
          style: TextStyle(
            fontFamily: "Airbnb Cereal App",
            fontSize: 22,
            color: Color(0xff51b055),
          )),
      backgroundColor: Colors.white,
    );
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Morning';
    }
    if (hour < 17) {
      return 'Afternoon';
    }
    return 'Evening';
  }

  buildGreetingRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Container(
          width: 62,
          height: 62,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(48.0),
            child: Image.network(
                Provider.of<LoginProvider>(context, listen: false)
                    .firebaseUser
                    .photoUrl),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Text(
            '${greeting()}, ${Provider.of<LoginProvider>(context, listen: false).firebaseUser.displayName}',
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: "Airbnb Cereal App",
              fontWeight: FontWeight.w400,
              fontSize: 20,
              color: Color(0xff0d0d0d),
            )),
      ]),
    );
  }

  Widget buildProgress() {
    return Container(
      height: MediaQuery.of(context).size.height / 3,
      child: Stack(
        children: <Widget>[
          TweenAnimationBuilder(
            curve: Curves.easeOutBack,
            tween: Tween<double>(
                begin: 0,
                end: user.goals[0]['goalCompleted'] / user.goals[0]['goal']),
            duration: Duration(seconds: 5),
            builder: (BuildContext context, double value, Widget child) {
              return Center(
                child: Container(
                  width: MediaQuery.of(context).size.height / 3.5,
                  height: MediaQuery.of(context).size.height / 3.5,
                  child: CircularProgressIndicator(
                    strokeWidth: 30,
                    value: value,
                    valueColor: AlwaysStoppedAnimation(Color(0xff51b055)),
                    backgroundColor: Color(0xff000000).withOpacity(0.38),
                  ),
                ),
              );
            },
          ),
          Align(
              alignment: Alignment.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                      '${user.goals[0]['goalCompleted']} of ${user.goals[0]['goal']}',
                      style: TextStyle(
                        fontFamily: "Airbnb Cereal App",
                        fontWeight: FontWeight.w700,
                        fontSize: 32,
                        color: Color(0xff000000).withOpacity(0.78),
                      )),
                  Text('Plants',
                      style: TextStyle(
                        fontFamily: "Airbnb Cereal App",
                        fontWeight: FontWeight.w400,
                        fontSize: 22,
                        color: Color(0xff0d0d0d),
                      )),
                ],
              )),
        ],
      ),
    );
  }

  Widget buildHeading(String text) {
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 8, 8, 8),
      child: Text(text,
          style: TextStyle(
            fontFamily: "Airbnb Cereal App",
            fontWeight: FontWeight.w400,
            fontSize: 22,
            color: Color(0xff0d0d0d),
          )),
    );
  }

  bool ongoingListHasItems = false;
  Widget buildOngoingPlantTile(BuildContext context, User user, Plant plant) {
    if (plant.status == Plant.STATUS_DONATED) return Container();
    ongoingListHasItems = true;
    return ListTile(
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: CachedNetworkImage(
          imageUrl: plant.pictureUrl,
          fit: BoxFit.fill,
          height: 48,
          width: 48,
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(),
          ),
        ),
      ),
      title: Text(plant.name),
      subtitle: Text(user.name),
    );
  }

  List<Widget> buildOngoingPlant(BuildContext context) {
    int i = -1;
    final tiles = Provider.of<LoginProvider>(context).chatUsers.map((u) {
      i++;
      final plant = Provider.of<LoginProvider>(context).chatPlants[i];
      return buildOngoingPlantTile(context, u, plant);
    }).toList();
    if (!ongoingListHasItems) {
      return [
        SizedBox(
          height: 20,
        ),
        Center(
          child: Text('No ongoing process',
              style: TextStyle(
                fontFamily: "Airbnb Cereal App",
                fontWeight: FontWeight.w300,
                fontSize: 22,
                color: Color(0xff000000),
              )),
        )
      ];
    }
    return tiles;
  }

  List<Widget> buildScafoldBody(BuildContext context) {
    final List<Widget> list = [];
    list.add(buildGreetingRow(context));
    list.add(buildHeading('Your Progress'));
    list.add(buildProgress());
    list.add(buildHeading('Ongiong'));
    list.addAll(buildOngoingPlant(context));
    return list;
  }

  Widget buildFAB() {
    return FloatingActionButton.extended(
      onPressed: () {
        Navigator.pushNamed(context, DonorForm.route);
      },
      icon: Icon(Icons.add),
      backgroundColor: Color(0xff51b055),
      label: Text('Donate plant'),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (isProgressVisible) {
      return Scaffold(
        floatingActionButton: user.role == 2 ? buildFAB() : Container(),
        appBar: _buildProfileAppbar(context),
        body: Container(
            color: Colors.white,
            child: ListView(
              children: buildScafoldBody(context),
            )),
      );
    } else
      return Container();
  }
}

class DonorForm extends StatefulWidget {
  static const route = 'donor_form';
  DonorForm({Key key}) : super(key: key);

  @override
  _DonorFormState createState() => _DonorFormState();
}

class _DonorFormState extends State<DonorForm> {
  File _image;
  Position _currentLocation;
  GoogleMapController _mapController;
  final _quantityController = TextEditingController();
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

    setState(() {
      _image = image;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _quantityController.dispose();

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildLocationDisableAlertDialog() {
    return AlertDialog(
      title: Text("Location not enabled"),
      content: Text(
          'Location service is either disabled or location permission is not granted '),
      actions: <Widget>[
        FlatButton(
          child: Text('Open App Settings'),
          onPressed: () {
            AppSettings.openAppSettings();
            Navigator.of(context).pop();
          },
        ),
        FlatButton(
          child: Text('Open Location Settings'),
          onPressed: () {
            AppSettings.openLocationSettings();
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }

  Widget _buildUploadingPlantOnlingTaskAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Uploading!'),
      content: Container(
        height: 100,
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
      actions: <Widget>[],
    );
  }

  Widget _buildUploadingPlantFailedAlertDialog(BuildContext context) {
    return AlertDialog(
      title: Text('Upload failed'),
      content:
          Text("Error connecting to Internet. Check your WiFi/Data connection"),
      actions: <Widget>[
        FlatButton(
          child: Text('ok'),
          onPressed: () =>
              Provider.of<LoginProvider>(context).resetPlantUploadProgress(),
        ),
      ],
    );
  }

  Widget _buildUploadingPlantCompleted(BuildContext context) {
    return AlertDialog(
      title: Text('Upload Complete'),
      actions: <Widget>[
        FlatButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            }),
      ],
    );
  }

  Widget _buildFormAndProgressDialogs(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Color(0xff51b055),
        onPressed: () async {
          if (_nameController.text.isEmpty ||
              _quantityController.text.isEmpty) {
            Fluttertoast.showToast(msg: "name and quantity are mandatory");
            return;
          }
          try {
            int.parse(_quantityController.text);
          } on FormatException {
            Fluttertoast.showToast(msg: "Quantity must be an integer");
            return;
          }

          Future.delayed(Duration.zero).then((value) {
            showDialog(
              context: context,
              builder: (context) =>
                  _buildUploadingPlantOnlingTaskAlertDialog(context),
            );
          });

          bool result = await Provider.of<LoginProvider>(context, listen: false)
              .uploadPlant(_nameController.text.trim(),
                  int.parse(_quantityController.text), _image);
          Navigator.of(context, rootNavigator: true).pop('dialog');
          if (result == false) {
            Future.delayed(Duration.zero).then((value) {
              showDialog(
                context: context,
                builder: (context) =>
                    _buildUploadingPlantFailedAlertDialog(context),
              );
            });
          } else {
            Future.delayed(Duration.zero).then((value) {
              showDialog(
                context: context,
                builder: (context) => _buildUploadingPlantCompleted(context),
              );
            });
          }
        },
        label: Text('Donate',
            style: TextStyle(
              fontFamily: "Airbnb Cereal App",
              fontWeight: FontWeight.w400,
              fontSize: 18,
              color: Color(0xffffffff),
            )),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.only(left: 10.0, top: 3.0),
              alignment: Alignment.centerLeft,
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
            SizedBox(
              height: 9,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 0, 12.0),
              child: Text('Add a Plant',
                  style: TextStyle(
                    fontFamily: "Airbnb Cereal App",
                    fontWeight: FontWeight.w700,
                    fontSize: 36,
                    color: Color(0xff000000).withOpacity(0.78),
                  )),
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: TextFormField(
                controller: _nameController,
                decoration: new InputDecoration(
                    labelText: "Name",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                    )),
                validator: (value) {
                  if (value.trim().length == 0) {
                    return 'Please enter some text';
                  } else
                    return null;
                },
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: EdgeInsets.all(10.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      height: 120.0,
                      width: 120,
                      child: OutlineButton(
                        onPressed: () => getImage(),
                        padding: EdgeInsets.fromLTRB(12.0, 20.0, 12.0, 20.0),
                        child: Column(
                          children: <Widget>[
                            Expanded(child: Icon(Icons.add_a_photo)),
                            Text(_image == null ? 'Add image' : 'Replace image')
                          ],
                        ),
                      ),
                    ),
                    _image != null
                        ? Container(
                            margin: EdgeInsets.only(left: 20),
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4.0),
                                border:
                                    Border.all(color: Colors.grey, width: 1.0)),
                            child: Image.file(_image))
                        : Container(),
                  ]),
            ),
            Center(
              child: Text(
                'Add the photo of plant if you have already bought it.',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            SizedBox(
              height: 15,
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                keyboardType: TextInputType.numberWithOptions(decimal: false),
                controller: _quantityController,
                decoration: new InputDecoration(
                    labelText: "Quantity",
                    fillColor: Colors.white,
                    border: new OutlineInputBorder(
                      borderRadius: new BorderRadius.circular(12.0),
                    )),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                'Location',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
            Consumer<LoginProvider>(
              builder: (context, provider, child) {
                if (provider.userPlacemark != null) {
                  return Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Text(
                      '${provider.userPlacemark.name}, ${provider.userPlacemark.subLocality}, ${provider.userPlacemark.locality}, ${provider.userPlacemark.administrativeArea}, ${provider.userPlacemark.country} ',
                    ),
                  );
                }
                return Container();
              },
            ),
            Consumer<LoginProvider>(builder: (context, provider, child) {
              if (provider.userLocationStatus == UserLocationStatus.disabled) {
                Future.delayed(Duration.zero).then((value) {
                  showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (_) => _buildLocationDisableAlertDialog(),
                  );
                  Navigator.of(context).pop();
                });
                return Container();
              } else if (provider.userLocationStatus ==
                  UserLocationStatus.fetching) {
                return Center(child: CircularProgressIndicator());
              } else if (provider.userLocationStatus ==
                  UserLocationStatus.sucessful) {
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: AspectRatio(
                    aspectRatio: 2 / 1,
                    child: GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: LatLng(provider.userLocation.latitude,
                              provider.userLocation.longitude),
                          zoom: 17.0,
                        ),
                        mapType: MapType.normal,
                        myLocationButtonEnabled: false,
                        myLocationEnabled: true,
                        onMapCreated: (GoogleMapController controller) {
                          _mapController = controller;
                        }),
                  ),
                );
              }
            }),
            // Consumer<LoginProvider>(
            //   builder: (context, provider, child) {
            //     if (provider.uploadPlantProgress == OnlineProgress.error) {
            //       Future.delayed(Duration.zero).then((onValue) {
            //         showDialog(
            //           context: context,
            //           builder: (context) =>
            //               _buildUploadingPlantFailedAlertDialog(context));
            //       });

            //     } else if (provider.uploadPlantProgress ==
            //         OnlineProgress.ongoing) {
            //      Future.delayed(Duration.zero).then((onValue) {
            //         showDialog(
            //           context: context,
            //           builder: (context) =>
            //               _buildFormAndProgressDialogs(context));
            //       });
            //     } else if (provider.uploadPlantProgress ==
            //         OnlineProgress.completed) {
            //      Future.delayed(Duration.zero).then((onValue) {
            //         showDialog(
            //           context: context,
            //           builder: (context) =>
            //               _buildUploadingPlantCompleted(context));
            //       });
            //     }
            //     return Container();
            //   },
            // ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<LoginProvider>(context, listen: false).getCurrentLocation();
    return MaterialApp(
      home: _buildFormAndProgressDialogs(context),
    );
  }
}
