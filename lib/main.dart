import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shajar/presentation/calculation_onboard_screen.dart';
import 'package:shajar/presentation/home_screen.dart';
import 'package:shajar/presentation/map_screen.dart';
import 'package:shajar/presentation/message_screen.dart';
import 'package:shajar/presentation/splash_screen.dart';
import 'package:shajar/provider/login_provider.dart';
import 'presentation/login_screen.dart';
import 'package:shajar/presentation/chat_list_screen.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => LoginProvider(),
          child: MaterialApp(
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          MapScreen.route : (context) => MapScreen(),
          HomeScreen.route : (context) => HomeScreen(),
          DonorForm.route : (context) => DonorForm(),
          MessageScreen.route : (context) => MessageScreen(),
          ChatListScreen.route : (context) => ChatListScreen(),
          LoginScreen.route : (context) => LoginScreen(),
          CalculationOnboardScreen.route : (context) => CalculationOnboardScreen(),
          RoleTakingScreen.route : (context) => RoleTakingScreen(),
        },
      ),
    );
  }
}


