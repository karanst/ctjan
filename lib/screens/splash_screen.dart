import 'package:flutter/material.dart';
import 'package:CTJan/Helper/token_strings.dart';
import 'package:CTJan/responsive/mobile_screen_layout.dart';
import 'package:CTJan/screens/send_otp.dart';
import 'package:CTJan/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }


  String? userId;
  getUserData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userId = prefs.getString(TokenString.userid);
    if(userId == null || userId == "") {
      Future.delayed(Duration(seconds: 3), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignInScreen()));
      });
    }else{
      Future.delayed(Duration(seconds: 3), () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) =>  BottomBar()));
      });
    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryClr,
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width/2,
          height: MediaQuery.of(context).size.height/2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/applogo.png'),
              const Text("Jan", style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 36
              ),)
            ],
          ),
        ),
      ),
    );
  }
}
