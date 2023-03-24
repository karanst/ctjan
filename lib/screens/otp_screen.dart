import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:CTJan/Helper/api_path.dart';
import 'package:CTJan/Helper/token_strings.dart';
import 'package:CTJan/models/get_profile_model.dart';
import 'package:CTJan/responsive/mobile_screen_layout.dart';
import 'package:CTJan/utils/colors.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:otp_text_field/otp_text_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:shared_preferences/shared_preferences.dart';


class OTPScreen extends StatefulWidget {
  String? code,mobile;
  OTPScreen({this.mobile,this.code});

  @override
  State<OTPScreen> createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {


  OtpFieldController controller  =  OtpFieldController();
  FocusNode focusNode = FocusNode();
  String? enteredOtp;
  bool loading = false;
  var focusedBorderColor = primaryClr;
  var fillColor =  greyColor1;
  var borderColor = greyColor2;

  int? newOtp;

  resendOtp()async{
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? type = prefs.getString(TokenString.userType);
    print("kkkkk ${type}");
    var headers = {
      'Cookie': 'ci_session=25ff5e4d1c8952f258520edbe7b2b7ec8703cfa9'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.loginWithOtp));
    request.fields.addAll({
      'mobile': '${widget.mobile}'
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse =  await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      print("final json response ${jsonResponse}");
      setState(() {
        newOtp = jsonResponse['otp'];
        widget.code = newOtp.toString();
        print("new otp ${newOtp.toString()}");
      });
      print("sdsdsdsds ${widget.code}");
      var snackBar = SnackBar(
        content: Text('${jsonResponse['message']}'),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    else {
      print(response.reasonPhrase);
    }

  }

  verifyOtp()async{
    SharedPreferences prefs  = await SharedPreferences.getInstance();
    String? type = prefs.getString(TokenString.userType);
    print("kkkkk ${type}");
    var headers = {
      'Cookie': 'ci_session=25ff5e4d1c8952f258520edbe7b2b7ec8703cfa9'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.verifyOtp));
    request.fields.addAll({
      'mobile': '${widget.mobile}',
      'otp': newOtp == null || newOtp == "" ? '${widget.code }': newOtp.toString()
    });
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse =  await response.stream.bytesToString();
      // final jsonResponse = json.decode(finalResponse);
      // print("final json response ${jsonResponse}");

      final jsonResponse = GetProfileModel.fromJson(json.decode(finalResponse));
        if(jsonResponse.responseCode == "1") {
          setState(() {
            loading = false;
          });
          String userid = jsonResponse.userId!.id.toString();
          String userName = jsonResponse.userId!.username.toString();
          String mobile = jsonResponse.userId!.mobile.toString();
          String email = jsonResponse.userId!.email.toString();
          String userProfile = jsonResponse.userId!.profilePic.toString();
          String isGroupJoined = jsonResponse.userId!.groupId.toString();

          await prefs.setString(TokenString.userid, userid);
          await prefs.setString(TokenString.userName, userName);
          await prefs.setString(TokenString.userMobile, mobile);
          await prefs.setString(TokenString.userEmail, email);
          await prefs.setString(TokenString.userProfile, userProfile);
          await prefs.setString(TokenString.groupJoined, isGroupJoined);

          var snackBar = SnackBar(
            content: Text(jsonResponse.message.toString()),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.push(context, MaterialPageRoute(builder: (context) => const BottomBar()));

          // Navigator.push(context, MaterialPageRoute(builder: (context) => const MobileScreenLayout()));
      }
        else{
          setState(() {
            loading = false;
          });
          var snackBar = SnackBar(
            content: Text(jsonResponse.message.toString()),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
    }
    else {
      print(response.reasonPhrase);
    }

  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: Scaffold(
          backgroundColor: mobileBackgroundColor,
            appBar: AppBar(
              elevation: 0,
              centerTitle: true,
              backgroundColor: Colors.transparent,
              leading: GestureDetector(
                onTap: (){
                  Navigator.pop(context);
                  // Get.to(SignInScreen());
                },
                child: Icon(Icons.arrow_back_ios, color: primaryClr, size: 26),
              ),
              title:  Text('Verification', style: TextStyle(color: primaryClr, fontSize: 21, fontWeight: FontWeight.bold),),
            ),
            body: Padding(
              padding: EdgeInsets.all(10),
              child: Container(
                alignment: Alignment.center,
                width: size.width,
                height: size.height,
                child: Column(
                  children: [
                   const  SizedBox(height: 50,),
                    Text("Code has sent to", style: TextStyle(fontSize: 22, color: primaryClr),),
                   const  SizedBox(height: 5,),
                    Text("${widget.mobile}", style: const  TextStyle(fontWeight: FontWeight.w600, fontSize: 22, color: primaryColor),),
                   const SizedBox(height: 10,),
                    Text(
                        newOtp == null || newOtp == "" ?
                        "${widget.code}"
                            : newOtp.toString(), style: const TextStyle(
                      color: primaryColor
                    ),),
                   const SizedBox(height: 30,),
                    Padding(
                        padding: const EdgeInsets.all(10),
                        child:OTPTextField(
                          controller: controller,
                          length: 4,
                          keyboardType: TextInputType.number,
                          width: MediaQuery.of(context).size.width,
                          textFieldAlignment: MainAxisAlignment.spaceEvenly,
                          fieldWidth: 50,
                          contentPadding: const EdgeInsets.all(11),
                          fieldStyle: FieldStyle.box,
                          outlineBorderRadius: 15,
                          otpFieldStyle: OtpFieldStyle(
                              backgroundColor: Colors.white,
                              disabledBorderColor: Colors.white
                          ),
                          style: TextStyle(fontSize: 17, height: 2.2, color: webBackgroundColor),
                          onChanged: (pin) {
                            print("checking pin here ${pin}");
                          },
                          onCompleted: (pin) {
                            if (pin.isNotEmpty && pin.length == 4) {
                              setState(() {
                                enteredOtp = pin;
                              });
                            } else {

                            }
                          },
                        )
                      // child: PinCodeTextField(
                      //   controller: controller,
                      //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      //   appContext: (context),
                      //   onChanged: (value){
                      //
                      //   },
                      //   onSubmitted: ,
                      //   length: 4,
                      //   pinTheme: PinTheme(
                      //       shape: PinCodeFieldShape.box,
                      //       borderRadius: BorderRadius.circular(10),
                      //       activeColor: primaryClr,
                      //       fieldWidth: 48,
                      //       fieldHeight: 48,
                      //       selectedColor:  greyColor,
                      //       borderWidth: 2,
                      //       inactiveColor: Colors.grey
                      //   ),
                      // ),
                    ),
                    SizedBox(height: 30,child: Text("Haven't received the verification code?", style: TextStyle(color: primaryClr, fontWeight: FontWeight.bold),),),
                    InkWell(
                        onTap: (){
                          resendOtp();
                        },
                        child: const Text("Resend",

                          style: TextStyle(fontWeight: FontWeight.bold, color: webBackgroundColor, fontSize: 16, decoration: TextDecoration.underline),
                        )),
                    const SizedBox(height: 50 ,),
                    Container(
                      width: MediaQuery.of(context).size.width - 30,
                      child: NeoPopTiltedButton(
                        isFloating: true,
                        onTapUp: () {
                          setState(() {
                            loading = true;
                          });
                          verifyOtp();
                          // AppRouter.pushNamed(Routes.LoginScreenRoute);
                        },
                        decoration:  NeoPopTiltedButtonDecoration(
                            color: primaryClr,
                            plunkColor: Colors.black,
                            shadowColor: Colors.grey,
                            showShimmer: true,
                            shimmerColor: Colors.white,
                            shimmerWidth: 10),
                        child:   Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 30.0,
                              vertical: 15,
                            ),
                            child: loading ? Center(
                              child: Container(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  color: whiteColor,
                                ),
                              ),
                            ):
                            const  Text('Verify OTP',
                                style: TextStyle(
                                  color: mobileBackgroundColor,
                                  //ThemeDate.isDark? AppColors.txtPrmyLightColor:AppColors.txtPrmydarkColor,
                                  fontWeight: FontWeight.bold,

                                )),
                          ),
                        ),
                      ),
                    ),
                    // GestureDetector(
                    //   onTap: (){
                    //     setState(() {
                    //       loading = true;
                    //     });
                    //     verifyOtp();
                    //     // if(enteredOtp == widget.code){
                    //     //   Fluttertoast.showToast(msg: "Otp verified successfully");
                    //     //   Navigator.push(context, MaterialPageRoute(builder: (context) => const MobileScreenLayout()));
                    //     //   setState(() {
                    //     //     loading = false;
                    //     //   });
                    //     // }
                    //     // else{
                    //     //   Fluttertoast.showToast(msg: "Please enter valid otp");
                    //     //   setState(() {
                    //     //     loading = false;
                    //     //   });
                    //     // }
                    //   },
                    //   child: Container(
                    //     width: MediaQuery.of(context).size.width / 1.1,
                    //     height: 52,
                    //     alignment: Alignment.center,
                    //     //padding: EdgeInsets.all(6),
                    //     decoration: BoxDecoration(
                    //         color: primaryClr,
                    //         borderRadius: BorderRadius.circular(10)
                    //     ),
                    //     child: loading ? Center(
                    //       child: Container(
                    //         height: 30,
                    //         width: 30,
                    //         child: CircularProgressIndicator(
                    //           color: whiteColor,
                    //         ),
                    //       ),
                    //     ): const Text("Verify Authentication Code", style: TextStyle(
                    //       fontWeight: FontWeight.w600,
                    //       fontSize: 16,
                    //       color: Colors.white
                    //     ),),
                    //
                    //   ),
                    // ),
                    // CustomTextButton(buttonText: "Verify Authentication Code", onTap: (){
                    //   if(enteredOtp == widget.code){
                    //     Fluttertoast.showToast(msg: "Otp verified successfully");
                    //     Navigator.push(context, MaterialPageRoute(builder: (context) => BottomBar()));
                    //   }
                    //   else{
                    //     Fluttertoast.showToast(msg: "Please enter valid otp");
                    //   }
                    // },),
                  ],
                ),
              ),
            )
        ));
  }
}

