import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shajar/presentation/home_screen.dart';
import 'package:shajar/presentation/login_screen.dart';
import 'package:shajar/provider/login_provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Image logo;
  final String logoPath = 'assets/logo.png';
  bool isViewloaded = true;
  @override
  void initState() {
    super.initState();
    logo = Image.asset(logoPath);
    WidgetsBinding.instance.addPostFrameCallback((_) => checkLogin(context));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    precacheImage(logo.image, context);
  }

  Future<void> checkLogin(BuildContext context) async {
    await Future.delayed(Duration(milliseconds: 300));
    final FirebaseUser user = await FirebaseAuth.instance.currentUser();
    if (user != null) {
      Provider.of<LoginProvider>(context, listen: false).firebaseUser = user;
      Navigator.pushReplacementNamed(context, HomeScreen.route);
    }
    else
    Navigator.pushReplacementNamed(context, LoginScreen.route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Opacity(
        opacity: isViewloaded ? 1 : 0,
        child: Container(
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 5,
                fit: FlexFit.tight,
                child: Center(
                  child: Image(
                    image: AssetImage(logoPath),
                    height: 300,
                    width: 300,
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Text('Shajar',
                    style: TextStyle(
                      fontFamily: "Airbnb Cereal App",
                      fontWeight: FontWeight.w700,
                      fontSize: 44,
                      color: Color(0xff707070).withOpacity(1.0),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
