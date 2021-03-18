import 'package:flutter/material.dart';
import 'package:foodadmin/provider/user.dart';
import 'package:foodadmin/screen/home.dart';
import 'package:foodadmin/screen/login.dart';
import 'package:foodadmin/screen/register.dart';
import 'package:foodadmin/screen/splash.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
      MultiProvider(
          providers: [
            ChangeNotifierProvider.value(value: UserProvider.initialize()),
          ],
          child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'FoodSwipe',
              theme: ThemeData(
                primarySwatch: Colors.red,
              ),
              home: ScreensController()))

  );
}

class ScreensController extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<UserProvider>(context);
    switch (auth.status) {
      case Status.Uninitialized:
        return Splash();
      case Status.Unauthenticated:
      case Status.Authenticating:
        return login();
      case Status.Authenticated:
        return Home();
      default:
        return login();
    }
  }
}
