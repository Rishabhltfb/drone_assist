import 'package:drone_assist/src/helper/dimensions.dart';
import 'package:drone_assist/src/providers/user_provider.dart';
import 'package:drone_assist/src/screens/home_screen.dart';
import 'package:drone_assist/src/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  ValueNotifier<bool> _isLoading = ValueNotifier<bool>(false);
  late double vpH, vpW;
  AuthService _auth = new AuthService();

  Widget _button(String title, BuildContext context, double vpH) {
    return PhysicalModel(
      color: Colors.transparent,
      shadowColor: Colors.blue.withOpacity(0.3),
      borderRadius: BorderRadius.all(Radius.circular(50)),
      elevation: 8.0,
      child: FlatButton(
        color: Color(0xff2C2A2D),
        textColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 12.0),
        onPressed: () async {
          // Navigator.of(context).pushReplacement(MaterialPageRoute(
          //   builder: (context) {
          //     return HomeScreen();
          //   },
          // ));
          _isLoading.value = true;
          _auth.signInWithGoogle().then((user) {
            Provider.of<UserProvider>(context, listen: false).setUser = user;
            _isLoading.value = false;
            if (user.name.isNotEmpty) {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) {
                  return HomeScreen();
                },
              ));
              print("User is not null");
            } else {
              print("returned User has no name");
            }
          }).catchError((onError) {
            _isLoading.value = false;
            print("Error on Google Signin: $onError");
          });
        },
        shape: new RoundedRectangleBorder(
            borderRadius: new BorderRadius.circular(35.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/img/google_icon.png',
              fit: BoxFit.fitHeight,
              height: vpH * 0.06,
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              title,
              style:
                  TextStyle(fontSize: vpH * 0.03, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    vpH = getViewportHeight(context);
    vpW = getViewportWidth(context);
    return Scaffold(
      body: ValueListenableBuilder(
        valueListenable: _isLoading,
        builder: (context, value, child) => _isLoading.value
            ? Container(
                height: vpH,
                width: vpW,
                child: Center(child: CircularProgressIndicator()),
              )
            : Column(
                // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: vpW,
                    height: vpH * 0.1,
                  ),
                  Text(
                    'Authentication',
                    style: TextStyle(
                      fontSize: vpW * 0.08,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 20),
                      child: SvgPicture.asset(
                        'assets/illustrations/authenticate.svg',
                        // height: vpH * 0.4,
                        width: vpW * 0.7,
                      )),
                  SizedBox(height: vpH * 0.2),
                  _button("SignIn with Google", context, vpH)
                ],
              ),
      ),
    );
  }
}
