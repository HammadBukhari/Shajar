import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shajar/presentation/calculation_onboard_screen.dart';
import 'package:shajar/presentation/home_screen.dart';
import 'package:shajar/provider/login_provider.dart';

// class LoginWithGoogle extends StatefulWidget {
//   @override
//   _LoginWithGoogleState createState() => _LoginWithGoogleState();
// }

// class _LoginWithGoogleState extends State<LoginWithGoogle> {
//   bool visiblity = false;
//   bool isLoginChecked = false;
//   @override
//   void initState() {
//     super.initState();
//     // WidgetsBinding.instance
//     //     .addPostFrameCallback((_) => onWidgetBuildCompleted(context));
//   }

//   Future<void> checkLogin(BuildContext context) async {
//     isLoginChecked = true;
//     FirebaseAuth auth =
//         Provider.of<LoginProvider>(context, listen: false).firebaseAuth;
//     FirebaseUser user = await auth.currentUser();
//     if (user != null) {
//       Provider.of<LoginProvider>(context, listen: false).firebaseUser = user;
//       Navigator.of(context).pushNamed(HomeScreen.route);
//     } else {
//       setState(() {
//         visiblity = true;
//       });
//     }
//   }

//   void uploadGoal(
//       BuildContext context, LoginProvider provider, String goal) async {
//     bool result = await provider.uploadGoal(int.parse(goal));
//     if (result == true) {
//       Navigator.of(context).pushNamed(HomeScreen.route);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     final _goalController = TextEditingController();
//     return Opacity(
//       opacity: visiblity ? 1.0 : 0.0,
//       child: Consumer<LoginProvider>(builder: (context, login, child) {
//         if (!isLoginChecked) checkLogin(context);
//         if (!login.isloggedIn) {
//           return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 SizedBox(
//                   height: 80,
//                 ),
//                 Flexible(
//                   flex: 1,
//                   child: Center(
//                       child: Text("Shajarkaar",
//                           style: Theme.of(context).textTheme.display1)),
//                 ),
//                 Flexible(
//                     flex: 10,
//                     child: Center(
//                       child: RaisedButton(
//                         child: Text("Login With Google"),
//                         onPressed: () {
//                           Provider.of<LoginProvider>(context, listen: false)
//                               .signInWithGoogle();
//                         },
//                       ),
//                     ))
//               ]);
//         } else if (login.isNewLogin) {
//           return Container(
//             decoration: BoxDecoration(color: Colors.white),
//             child: Padding(
//               padding: EdgeInsets.all(24.0),
//               child: Column(
//                 children: <Widget>[
//                   Flexible(
//                     fit: FlexFit.tight,
//                     flex: 2,
//                     child: Center(
//                       child: Text(
//                         'Hey, tell us about your goal',
//                         style: TextStyle(
//                           fontWeight: FontWeight.bold,
//                           color: Colors.greenAccent,
//                           fontSize: 35.0,
//                         ),
//                       ),
//                     ),
//                   ),
//                   Flexible(
//                     flex: 3,
//                     child: Column(
//                       children: <Widget>[
//                         TextField(
//                           controller: _goalController,
//                           cursorColor: Colors.white10,
//                           decoration: InputDecoration(
//                             labelText: "Goal (no of plants)",
//                             labelStyle: TextStyle(
//                               color: Colors.greenAccent,
//                               fontSize: 25.0,
//                             ),
//                           ),
//                         ),
//                         Padding(
//                           padding: const EdgeInsets.all(16.0),
//                           child: RaisedButton(
//                             elevation: 8.0,
//                             child: Text('NEXT'),
//                             onPressed: () async {
//                               uploadGoal(context, login, _goalController.text);
//                             },
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         } else if (login.isloggedIn) {
//           return Container(
//             child: Text("Logged in"),
//           );
//         }
//       }),
//     );
//   }
// }


class LoginScreen extends StatelessWidget {
  static const route = 'login';
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OnboardingScreen());
  }
}

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _pageController = PageController(initialPage: 0);

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: <Widget>[
        _page1(),
        _page2(),
        _page3(),
      ],
    );
  }

  Widget unselectedPageDot() {
    return Container(
      height: 12.00,
      width: 12.00,
      decoration: BoxDecoration(
        color: Color(0xff707070),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget selectedPageDot() {
    return Container(
      height: 15.00,
      width: 15.00,
      decoration: BoxDecoration(
        color: Color(0xff000000),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _page1() {
    final illustrationPath = 'assets/firstOnboard.png';
    return Container(
      child: ListView(
        children: <Widget>[
          Image(
            image: AssetImage(illustrationPath),
          ),
          Center(
            child: Text('Welcome to Shajar',
                style: TextStyle(
                  fontFamily: "Airbnb Cereal App",
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  color: Color(0xff000000).withOpacity(0.78),
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24, 12),
            child: Text(
                'Get guaranteed tree growth by teaming up to take care of saplings.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Airbnb Cereal App",
                  fontSize: 18,
                  color: Color(0xffb5b5b5),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: selectedPageDot(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: unselectedPageDot(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: unselectedPageDot(),
              ),
            ],
          ),
          SizedBox(
            height: 30,
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
                onPressed: () => _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut),
                color: Color(0xff51b055),
                child: Text('NEXT'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _page2() {
    final illustrationPath = 'assets/secondOnboard.png';
    return Container(
      child: ListView(
        children: <Widget>[
          Image(
            image: AssetImage(illustrationPath),
          ),
          SizedBox(
            height: 140,
          ),
          Center(
            child: Text('Collaborate to Contribute',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Airbnb Cereal App",
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  color: Color(0xff000000).withOpacity(0.78),
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24, 12),
            child: Text(
                'Donate saplings or take care of their growth. Whatever suits you the most!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Airbnb Cereal App",
                  fontSize: 18,
                  color: Color(0xffb5b5b5),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: unselectedPageDot(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: selectedPageDot(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: unselectedPageDot(),
              ),
            ],
          ),
          SizedBox(
            height: 30,
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
                onPressed: () => _pageController.nextPage(
                    duration: Duration(milliseconds: 300),
                    curve: Curves.easeInOut),
                color: Color(0xff51b055),
                child: Text('NEXT'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _page3() {
    final illustrationPath = 'assets/thirdOnboard.png';
    return Container(
      child: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Image(
              image: AssetImage(illustrationPath),
            ),
          ),
          SizedBox(
            height: 150,
          ),
          Center(
            child: Text('Calculate Usage, Plant Trees & Earn Points',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Airbnb Cereal App",
                  fontWeight: FontWeight.w700,
                  fontSize: 36,
                  color: Color(0xff000000).withOpacity(0.78),
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24, 12),
            child: Text(
                'Get an estimate of the trees you should plant according to your consumption.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Airbnb Cereal App",
                  fontSize: 18,
                  color: Color(0xffb5b5b5),
                )),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: unselectedPageDot(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: unselectedPageDot(),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: selectedPageDot(),
              ),
            ],
          ),
          SizedBox(
            height: 30,
          ),
          Center(
            child: Container(
              height: 48,
              child: FlatButton(
                shape: BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                clipBehavior: Clip.antiAlias,
                textColor: Color(0xFFFFFFFF),
                color: Color(0xff51b055),
                onPressed: () => 
                  signInWithGoogle(context),
                child: Text('Sign in with Google'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> signInWithGoogle(BuildContext context) async {
    bool isNewLogin =
        await Provider.of<LoginProvider>(context, listen: false).signInWithGoogle();
    if (!isNewLogin) {
      Navigator.pushReplacementNamed(context, HomeScreen.route);
    } else {
      Navigator.pushReplacementNamed(context, CalculationOnboardScreen.route);
    }
  }
}
