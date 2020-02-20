import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shajar/presentation/home_screen.dart';
import 'package:shajar/provider/login_provider.dart';

class CalculationOnboardScreen extends StatefulWidget {
  static const route = 'calculation_onboarding';
  @override
  _CalculationOnboardScreenState createState() =>
      _CalculationOnboardScreenState();
}

class _CalculationOnboardScreenState extends State<CalculationOnboardScreen> {
  final _pageController = PageController(initialPage: 0);
  final _electricityController = TextEditingController();
  final _gasController = TextEditingController();
  final _fuelController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        // physics: new NeverScrollableScrollPhysics(),
        children: <Widget>[
          _page1(),
          _page2(),
          _page3(),
        ],
      ),
    );
  }

  Widget filledPill() {
    return Container(
      height: 19.00,
      width: 72.00,
      decoration: BoxDecoration(
        color: Color(0xff51b055),
        borderRadius: BorderRadius.circular(8.00),
      ),
    );
  }

  Widget unfilledPill() {
    return Container(
      height: 19.00,
      width: 72.00,
      decoration: BoxDecoration(
        color: Color(0xff000000).withOpacity(0.38),
        borderRadius: BorderRadius.circular(8.00),
      ),
    );
  }

  Widget _page1() {
    final illustrationPath = 'assets/poll.png';
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: filledPill(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: unfilledPill(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: unfilledPill(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'How many units of  electricity do you consume every month?',
            style: TextStyle(
              fontFamily: "Airbnb Cereal App",
              fontWeight: FontWeight.w700,
              fontSize: 36,
              color: Color(0xff707070),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 0),
          child: TextField(
            controller: _electricityController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff51b055),
                  ),
                ),
                hintText: 'e.g 100',
                hintStyle: TextStyle(
                  fontFamily: "Airbnb Cereal App",
                  fontSize: 18,
                  color: Color(0xffb5b5b5),
                )),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  onPressed: () => _electricityController.text = '100',
                  child: Text('100',
                      style: TextStyle(
                        fontFamily: "Airbnb Cereal App",
                        fontSize: 22,
                        fontWeight: FontWeight.w200,
                        color: Color(0xff000000).withOpacity(0.80),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  onPressed: () => _electricityController.text = '200',
                  child: Text('200',
                      style: TextStyle(
                        fontFamily: "Airbnb Cereal App",
                        fontSize: 22,
                        fontWeight: FontWeight.w200,
                        color: Color(0xff000000).withOpacity(0.80),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  onPressed: () => _electricityController.text = '300',
                  child: Text('300',
                      style: TextStyle(
                        fontFamily: "Airbnb Cereal App",
                        fontSize: 22,
                        fontWeight: FontWeight.w200,
                        color: Color(0xff000000).withOpacity(0.80),
                      )),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Icon(
                    Icons.info_outline,
                    color: Color(0xff51b055),
                  )),
              SizedBox(
                width: 5,
              ),
              Flexible(
                  flex: 10,
                  child: Text(
                      'On average, electricity sources emits about 0.45 kg of CO2 per unit (kWh).',
                      style: TextStyle(
                        fontFamily: "Airbnb Cereal App",
                        fontSize: 18,
                        color: Color(0xffb5b5b5),
                      ))),
              Flexible(
                  flex: 3,
                  child: Opacity(
                      opacity: 0.5,
                      child: AspectRatio(
                          aspectRatio: 1,
                          child: Image(image: AssetImage(illustrationPath))))),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Container(
            height: 48,
            width: 120,
            child: FlatButton(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              clipBehavior: Clip.antiAlias,
              textColor: Colors.white,
              onPressed: () {
                _pageController.nextPage(
                    duration: Duration(milliseconds: 700),
                    curve: Curves.easeInOut);
                FocusScope.of(context).unfocus();
              },
              color: Color(0xff51b055),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('NEXT',
                        style: TextStyle(
                          fontFamily: "Airbnb Cereal App",
                          fontSize: 18,
                          color: Color(0xffffffff),
                        )),
                    Icon(Icons.keyboard_arrow_right),
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _page2() {
    final illustrationPath = 'assets/flame.png';
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: filledPill(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: filledPill(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: unfilledPill(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'How many units (MMBTU) of  gas do you consume every month?',
            style: TextStyle(
              fontFamily: "Airbnb Cereal App",
              fontWeight: FontWeight.w700,
              fontSize: 36,
              color: Color(0xff707070),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 0),
          child: TextField(
            controller: _gasController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff51b055),
                  ),
                ),
                hintText: 'e.g 3',
                hintStyle: TextStyle(
                  fontFamily: "Airbnb Cereal App",
                  fontSize: 18,
                  color: Color(0xffb5b5b5),
                )),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  onPressed: () => _gasController.text = '2',
                  child: Text('2',
                      style: TextStyle(
                        fontFamily: "Airbnb Cereal App",
                        fontSize: 22,
                        fontWeight: FontWeight.w200,
                        color: Color(0xff000000).withOpacity(0.80),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  onPressed: () => _gasController.text = '3',
                  child: Text('3',
                      style: TextStyle(
                        fontFamily: "Airbnb Cereal App",
                        fontSize: 22,
                        fontWeight: FontWeight.w200,
                        color: Color(0xff000000).withOpacity(0.80),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  onPressed: () => _gasController.text = '5',
                  child: Text('5',
                      style: TextStyle(
                        fontFamily: "Airbnb Cereal App",
                        fontSize: 22,
                        fontWeight: FontWeight.w200,
                        color: Color(0xff000000).withOpacity(0.80),
                      )),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Icon(
                    Icons.info_outline,
                    color: Color(0xff51b055),
                  )),
              SizedBox(
                width: 5,
              ),
              Flexible(
                  flex: 10,
                  child: Text(
                      'On average, 1 mmbtu of natural gas emits about 14.4 kg of CO2.',
                      style: TextStyle(
                        fontFamily: "Airbnb Cereal App",
                        fontSize: 18,
                        color: Color(0xffb5b5b5),
                      ))),
              Flexible(
                  flex: 3,
                  child: Opacity(
                      opacity: 0.5,
                      child: AspectRatio(
                          aspectRatio: 1,
                          child: Image(image: AssetImage(illustrationPath))))),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Container(
            height: 48,
            width: 120,
            child: FlatButton(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              clipBehavior: Clip.antiAlias,
              textColor: Colors.white,
              onPressed: () {
                _pageController.nextPage(
                    duration: Duration(milliseconds: 700),
                    curve: Curves.easeInOut);
                FocusScope.of(context).unfocus();
              },
              color: Color(0xff51b055),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('NEXT',
                        style: TextStyle(
                          fontFamily: "Airbnb Cereal App",
                          fontSize: 18,
                          color: Color(0xffffffff),
                        )),
                    Icon(Icons.keyboard_arrow_right),
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  Widget _page3() {
    final illustrationPath = 'assets/car.png';
    return ListView(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: filledPill(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: filledPill(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: filledPill(),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text(
            'How many liters of fuel does your vehicle consume every month?',
            style: TextStyle(
              fontFamily: "Airbnb Cereal App",
              fontWeight: FontWeight.w700,
              fontSize: 36,
              color: Color(0xff707070),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12.0, 0, 12, 0),
          child: TextField(
            keyboardType: TextInputType.number,
            controller: _fuelController,
            decoration: InputDecoration(
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xff51b055),
                  ),
                ),
                hintText: 'e.g 100',
                hintStyle: TextStyle(
                  fontFamily: "Airbnb Cereal App",
                  fontSize: 18,
                  color: Color(0xffb5b5b5),
                )),
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  onPressed: () => _fuelController.text = '15',
                  child: Text('15',
                      style: TextStyle(
                        fontFamily: "Airbnb Cereal App",
                        fontSize: 22,
                        fontWeight: FontWeight.w200,
                        color: Color(0xff000000).withOpacity(0.80),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  onPressed: () => _fuelController.text = '30',
                  child: Text('30',
                      style: TextStyle(
                        fontFamily: "Airbnb Cereal App",
                        fontSize: 22,
                        fontWeight: FontWeight.w200,
                        color: Color(0xff000000).withOpacity(0.80),
                      )),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: OutlineButton(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0)),
                  onPressed: () => _fuelController.text = '60',
                  child: Text('60',
                      style: TextStyle(
                        fontFamily: "Airbnb Cereal App",
                        fontSize: 22,
                        fontWeight: FontWeight.w200,
                        color: Color(0xff000000).withOpacity(0.80),
                      )),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                  flex: 1,
                  fit: FlexFit.tight,
                  child: Icon(
                    Icons.info_outline,
                    color: Color(0xff51b055),
                  )),
              SizedBox(
                width: 5,
              ),
              Flexible(
                  flex: 10,
                  child: Text(
                      'On average, unleaded gasoline emits about 19.56 pounds of CO2 per gallon.',
                      style: TextStyle(
                        fontFamily: "Airbnb Cereal App",
                        fontSize: 18,
                        color: Color(0xffb5b5b5),
                      ))),
              Flexible(
                  flex: 3,
                  child: Opacity(
                      opacity: 0.5,
                      child: AspectRatio(
                          aspectRatio: 1,
                          child: Image(image: AssetImage(illustrationPath))))),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Center(
          child: Container(
            height: 48,
            width: 120,
            child: FlatButton(
              shape: BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(4.0)),
              ),
              clipBehavior: Clip.antiAlias,
              textColor: Colors.white,
              onPressed: () => submitCalculations(context),
              color: Color(0xff51b055),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text('NEXT',
                        style: TextStyle(
                          fontFamily: "Airbnb Cereal App",
                          fontSize: 18,
                          color: Color(0xffffffff),
                        )),
                    Icon(Icons.keyboard_arrow_right),
                  ]),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _gasController.dispose();
    _fuelController.dispose();
    _pageController.dispose();
    _electricityController.dispose();
    super.dispose();
  }

  void submitCalculations(BuildContext context) async {
    FocusScope.of(context).unfocus();

    if (_gasController.text.isEmpty ||
        _electricityController.text.isEmpty ||
        _fuelController.text.isEmpty) {
      Fluttertoast.showToast(msg: "All text fields must not be empty");
      return;
    }

    showDialog(
        context: context,
        builder: (context) => SimpleDialog(
              title: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: <Widget>[
                    Text('Calculating'),
                    SizedBox(height: 30),
                    CircularProgressIndicator(),
                    SizedBox(
                      height: 10,
                    ),
                  ],
                ),
              ),
            ));

    await Future.delayed(Duration(seconds: 2));
    Navigator.of(context).pop();
    try {
      int noOfPlants = Provider.of<LoginProvider>(context, listen: false)
          .calculateUsage(
              double.parse(_electricityController.text.trim()),
              double.parse(_gasController.text.trim()),
              double.parse(_fuelController.text.trim()));
      Navigator.pushNamed(context, RoleTakingScreen.route,
          arguments: noOfPlants);
    } on FormatException {
      Fluttertoast.showToast(msg: "Only numbers are allowed in text fields");
      return;
    }
  }
}

class RoleTakingScreen extends StatefulWidget {
  static const route = 'role_taking';
  @override
  _RoleTakingScreenState createState() => _RoleTakingScreenState();
}

class _RoleTakingScreenState extends State<RoleTakingScreen> {
  final _pageContrller = PageController();
  final donorillustrationPath = 'assets/donor.png';
  final caretakerillustrationPath = 'assets/caretaker.png';
  int plants;
  int rolesSelected = 0; // 1 = care taker, 2 = donor
  int cpiValue = 1;
  bool isDialogOpen = false;
  @override
  Widget build(BuildContext context) {
    plants = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: PageView(
        controller: _pageContrller,
        children: <Widget>[
          _pagePlantCount(),
          _roleTakingPage(),
        ],
      ),
    );
  }

  Widget buildReadMoreDialog(int role) {
    return Container(
      height: MediaQuery.of(context).size.height / 1.5,
      width: MediaQuery.of(context).size.height / 1.1,
      decoration: BoxDecoration(
        color: Color(0xffffffff),
        border: Border.all(
          width: 1.00,
          color: Color(0xff707070),
        ),
        boxShadow: [
          BoxShadow(
            offset: Offset(0.00, 3.00),
            color: Color(0xff000000).withOpacity(0.16),
            blurRadius: 12,
          ),
        ],
        borderRadius: BorderRadius.circular(12.00),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              IconButton(
                onPressed: () {
                  setState(() {
                    isDialogOpen = false;
                  });
                },
                icon: Icon(Icons.cancel),
                color: Color(0xff51b055),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 32),
                child: Image(
                    image: AssetImage(readMoreSelected == 1
                        ? caretakerillustrationPath
                        : donorillustrationPath),
                    height: MediaQuery.of(context).size.height / 3.5),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(readMoreSelected == 1 ? 'Caretaker' : 'Donor',
                style: TextStyle(
                  fontFamily: "Airbnb Cereal App",
                  fontWeight: FontWeight.w400,
                  fontSize: 22,
                  color: Color(0xff000000),
                )),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
                readMoreSelected == 1
                    ? 'Find a safe spot where you will plant the donated sapling and nurture it to ensure it survives its first season'
                    : "Donate any number of trees to anyone. Find your sapling's caretaker and they will keep you updated with its progress as well.",
                style: TextStyle(
                  fontFamily: "Airbnb Cereal App",
                  fontWeight: FontWeight.w300,
                  fontSize: 18,
                  color: Color(0xffb5b5b5),
                )),
          ),
        ],
      ),
    );
  }

  void openReadMoreDialog(int role) {
    setState(() {
      readMoreSelected = role;
      isDialogOpen = true;
    });
  }

  int readMoreSelected = 1;

  Widget _roleTakingPage() {
    return Stack(children: <Widget>[
      Visibility(
        visible: isDialogOpen ? false : true,
        child: Container(
          color: Colors.white,
          child: ListView(
            children: <Widget>[
              SizedBox(
                height: 40,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(48.0, 12, 48, 12),
                child: Text('Become a Shajarkar',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Airbnb Cereal App",
                      fontWeight: FontWeight.w700,
                      fontSize: 36,
                      color: Color(0xff707070),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 2, 18, 2),
                child: Text(
                    'To begin contributing, Lets first pick a role that suits you the most',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Airbnb Cereal App",
                      fontSize: 18,
                      color: Color(0xffb5b5b5),
                    )),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: new Container(
                  height: 167.00,
                  width: MediaQuery.of(context).size.width / 1.1,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border.all(
                      width: 2.00,
                      color: rolesSelected == 1
                          ? Color(0xff51b055)
                          : Color(0xff707070),
                    ),
                    borderRadius: BorderRadius.circular(12.00),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('Care Taker',
                                  style: TextStyle(
                                    fontFamily: "Airbnb Cereal App",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22,
                                    color: Color(0xff000000),
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () => openReadMoreDialog(1),
                                child: Text('Read more',
                                    style: TextStyle(
                                      fontFamily: "Airbnb Cereal App",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: Color(0xff51b055),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 4,
                          fit: FlexFit.tight,
                          child: Image(
                            image: AssetImage(caretakerillustrationPath),
                          )),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              rolesSelected = 1;
                            });
                          },
                          icon: Icon(
                            rolesSelected == 1
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            size: 32,
                            color: rolesSelected == 1
                                ? Color(0xff51b055)
                                : Color(0xff707070),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: new Container(
                  height: 167.00,
                  width: MediaQuery.of(context).size.width / 1.1,
                  decoration: BoxDecoration(
                    color: Color(0xffffffff),
                    border: Border.all(
                      width: 2.00,
                      color: rolesSelected == 2
                          ? Color(0xff51b055)
                          : Color(0xff707070),
                    ),
                    borderRadius: BorderRadius.circular(12.00),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Flexible(
                        flex: 3,
                        fit: FlexFit.tight,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: <Widget>[
                              Text('Donor',
                                  style: TextStyle(
                                    fontFamily: "Airbnb Cereal App",
                                    fontWeight: FontWeight.w400,
                                    fontSize: 22,
                                    color: Color(0xff000000),
                                  )),
                              SizedBox(
                                height: 5,
                              ),
                              GestureDetector(
                                onTap: () => openReadMoreDialog(2),
                                child: Text('Read more',
                                    style: TextStyle(
                                      fontFamily: "Airbnb Cereal App",
                                      fontWeight: FontWeight.w300,
                                      fontSize: 14,
                                      color: Color(0xff51b055),
                                    )),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Flexible(
                          flex: 4,
                          fit: FlexFit.tight,
                          child: Image(
                            image: AssetImage(donorillustrationPath),
                          )),
                      Flexible(
                        flex: 1,
                        fit: FlexFit.tight,
                        child: IconButton(
                          onPressed: () {
                            setState(() {
                              rolesSelected = 2;
                            });
                          },
                          icon: Icon(
                            rolesSelected == 2
                                ? Icons.check_circle
                                : Icons.check_circle_outline,
                            size: 32,
                            color: rolesSelected == 2
                                ? Color(0xff51b055)
                                : Color(0xff707070),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 30,),
              Center(
                child: Container(
                  width: MediaQuery.of(context).size.width / 1.5,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FlatButton(
                      onPressed: () {
                        if (rolesSelected != 0) {
                          uploadCalculations(context, plants, rolesSelected);
                        } else {
                          Fluttertoast.showToast(
                              msg: "Select one of the above roles first");
                        }
                      },
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(4.0)),
                      ),
                      clipBehavior: Clip.antiAlias,
                      textColor: Colors.white,
                      color: rolesSelected == 0
                          ? Color(0xff707070)
                          : Color(0xff51b055),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: <Widget>[
                            Text("LET'S GO",
                                style: TextStyle(
                                  fontFamily: "Airbnb Cereal App",
                                  fontSize: 18,
                                  color: Color(0xffffffff),
                                )),
                          ]),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      Visibility(
        visible: isDialogOpen ? true : false,
        child: Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: buildReadMoreDialog(readMoreSelected),
          ),
        ),
      ),
    ]);
  }

  void uploadCalculations(
      BuildContext context, int noOfPlants, int roleSelected) async {
    await Provider.of<LoginProvider>(context, listen: false)
        .uploadGoal(roleSelected, noOfPlants);
    Navigator.pushReplacementNamed(context, HomeScreen.route);
  }

  Widget _pagePlantCount() {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height / 2,
            child: Stack(
              children: <Widget>[
                TweenAnimationBuilder(
                  curve: Curves.easeInOutQuart,
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: Duration(seconds: 2),
                  builder: (BuildContext context, double value, Widget child) {
                    return Center(
                      child: Container(
                        width: 300,
                        height: 300,
                        child: CircularProgressIndicator(
                          strokeWidth: 30,
                          value: value,
                          valueColor: AlwaysStoppedAnimation(Color(0xff51b055)),
                          backgroundColor: Colors.red,
                        ),
                      ),
                    );
                  },
                ),
                Align(
                    alignment: Alignment.center,
                    child: Text('$plants plants',
                        style: TextStyle(
                          fontFamily: "Airbnb Cereal App",
                          fontWeight: FontWeight.w700,
                          fontSize: 36,
                          color: Color(0xff000000).withOpacity(0.78),
                        ))),
              ],
            ),
          ),
          Text('You need to plant $plants trees',
              style: TextStyle(
                fontFamily: "Airbnb Cereal App",
                fontSize: 20,
                color: Color(0xffb5b5b5),
              )),
          Container(
            width: MediaQuery.of(context).size.width / 1.5,
            height: MediaQuery.of(context).size.height / 3,
            child: Center(
              child: FlatButton(
                onPressed: () {
                  _pageContrller.nextPage(
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                clipBehavior: Clip.antiAlias,
                textColor: Colors.white,
                color: Color(0xff51b055),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Text("WHAT'S NEXT",
                          style: TextStyle(
                            fontFamily: "Airbnb Cereal App",
                            fontSize: 18,
                            color: Color(0xffffffff),
                          )),
                    ]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
