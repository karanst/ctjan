import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:CTJan/Helper/api_path.dart';
import 'package:CTJan/Helper/authtextfield.dart';
import 'package:CTJan/screens/send_otp.dart';
import 'package:CTJan/utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formkey1 = GlobalKey<FormState>();
  var gender;
  /// seeker controllers
  TextEditingController jemailController = TextEditingController();
  TextEditingController jmobileController = TextEditingController();
  TextEditingController jpasswordController = TextEditingController();
  TextEditingController jcpasswordController = TextEditingController();
  TextEditingController jfirstNameController = TextEditingController();
  TextEditingController jlastNameController = TextEditingController();
  TextEditingController birthDateController = TextEditingController();



  bool showPassword = false;
  bool isLoading = false;


  seekerSignUp()async{
    var headers = {
      'Cookie': 'ci_session=b2a1ec2780ae767ff59e374f863d83e3a991de16'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.registerUser));
    request.fields.addAll({
    'first_name': jfirstNameController.text.toString() ,
    'last_name': jlastNameController.text.toString() ,
    'mobile': jmobileController.text.toString() ,
    'email': jemailController.text.toString(),
    'gender': gender.toString(),
    'dob': birthDateController.text.toString()
    });
    print("this is registeration =-=====>>> ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResult);
      print("final response here ${jsonResponse}");
      if (jsonResponse['response_code'] == "1"){
        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        setState(() {});
        Navigator.push(context, MaterialPageRoute(builder: (context) => SignInScreen()));
      }
      else {
        Fluttertoast.showToast(msg: "${jsonResponse['message']}");
        print(response.reasonPhrase);
      }
    }
  }

  // recruiterSignUp()async{
  //   var headers = {
  //     'Cookie': 'ci_session=ec94f0bdb488239dc4b0f8c114420748ca7c936d'
  //   };
  //   var request = http.MultipartRequest('POST', Uri.parse('${ApiPath.baseUrl}signUp'));
  //   request.fields.addAll({
  //     'type': 'recruiter',
  //     'email': remailController.text,
  //     'name': fullNameController.text,
  //     'company': companyNameController.text,
  //     'mno': mobileController.text,
  //     'ps':  passwordController.text
  //   });
  //   print("paramters here ${request.fields}");
  //   request.headers.addAll(headers);
  //   http.StreamedResponse response = await request.send();
  //   if (response.statusCode == 200) {
  //     var finalResponse = await response.stream.bytesToString();
  //     final jsonResponse = json.decode(finalResponse);
  //     print("final response here ${jsonResponse}");
  //     if (jsonResponse['staus'] == "true" || jsonResponse['staus'] ==  true){
  //       Fluttertoast.showToast(msg: "Registered Successfully");
  //       setState(() {});
  //       // Navigator.push(context, MaterialPageRoute(builder: (context) => AccountCreatedScreen()));
  //     }
  //     else {
  //       Fluttertoast.showToast(msg: "${jsonResponse['message']}");
  //       print(response.reasonPhrase);
  //     }
  //   }
  //   else {
  //     print(response.reasonPhrase);
  //   }
  // }

  String _dateValue = '';
  var dateFormate;

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  Future _selectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate:  DateTime.now(),
        firstDate: DateTime(1950),
        lastDate: DateTime.now(),
        //firstDate: DateTime.now().subtract(Duration(days: 1)),
        // lastDate: new DateTime(2022),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
                primaryColor: primaryClr,
                accentColor: Colors.black,
                colorScheme:  ColorScheme.light(primary:  primaryClr),
                // ColorScheme.light(primary: const Color(0xFFEB6C67)),
                buttonTheme:
                ButtonThemeData(textTheme: ButtonTextTheme.accent)),
            child: child!,
          );
        });
    if (picked != null) {
      setState(() {
        String yourDate = picked.toString();
        _dateValue = convertDateTimeDisplay(yourDate);
        print(_dateValue);
        dateFormate = DateFormat("dd/MM/yyyy").format(DateTime.parse(_dateValue ?? ""));
        birthDateController = TextEditingController(text: _dateValue);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
        child: DefaultTabController(
          length: 2,
          child: Scaffold(
              backgroundColor: primaryClr,
              body: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 15, bottom: 15),
                      height: 100,
                      // height: size.height / 5.5 ,
                      decoration: BoxDecoration(
                        color: primaryClr,
                      ),
                      child: Image.asset(
                        'assets/appicon.png',
                        scale: 1.0,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(14),
                      width: size.width,
                      // height: size.height,
                      decoration: BoxDecoration(
                          color: whiteColor,
                          borderRadius:
                          BorderRadius.only(topRight: Radius.circular(70))),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Sign Up',
                            style: TextStyle(
                              color: primaryClr,
                                fontWeight: FontWeight.bold, fontSize: 32),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            child: Form(
                              key: _formkey,
                              child: Column(
                                children: [

                                  AuthTextField(
                                    validatior: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter your First name';
                                      }
                                    },
                                    obsecureText: false,
                                    iconImage: Icon(Icons.person, color: primaryClr,),
                                    // Image.asset(
                                    //   'assets/AuthAssets/Icon awesome-user.png',
                                    //   scale: 1.3,
                                    //   color: primaryClr,
                                    // ),
                                    hintText: "First Name",
                                    controller: jfirstNameController,
                                  ),
                                  AuthTextField(
                                    validatior: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Enter your last name';
                                      }
                                    },
                                    obsecureText: false,
                                    iconImage:  Icon(Icons.person, color: primaryClr,),
                                    hintText: "Last Name",
                                    controller: jlastNameController,
                                  ),
                                  AuthTextField(
                                    validatior: (input) => input!.isValidEmail() ? null : "Please Enter Valid email",
                                    //   (value) {
                                    // if (value!.isEmpty) {
                                    //   return "Enter valid email";
                                    //   print("Email");
                                    // }
                                    // return null;
                                    obsecureText: false,
                                    iconImage: Icon(Icons.email_outlined, color: primaryClr,),
                                    hintText: "Email",
                                    keyboardtype: TextInputType.emailAddress,
                                    controller: jemailController,
                                  ),
                                  AuthTextField(
                                    validatior: (value) {
                                      if (value == null || value.isEmpty || value.length != 10) {
                                        return 'Enter valid mobile number';
                                      }
                                    },
                                    obsecureText: false,
                                    iconImage: Icon(Icons.call, color: primaryClr,),
                                    hintText: "Mobile No.",
                                    keyboardtype: TextInputType.number,
                                    length: 10,
                                    controller: jmobileController,
                                  ),
                                  AuthTextField(
                                    onTap: (){
                                      FocusManager.instance.primaryFocus?.unfocus();
                                      _selectDate();
                                    },
                                    validatior: (value) {
                                      if (value == null || value.isEmpty || value.length != 10) {
                                        return 'Enter valid Date of birth';
                                      }
                                    },
                                    obsecureText: false,
                                    enabled: true,
                                    iconImage:  Icon(Icons.calendar_month, color: primaryClr,),
                                    hintText: "DOB",
                                    // keyboardtype: TextInputType.number,
                                    // length: 10,
                                    controller: birthDateController,
                                  ),

                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Material(
                                          elevation: 4,
                                          borderRadius: BorderRadius.circular(10),
                                          child: Container(
                                            width: 48,
                                            height: 48,
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(Icons.male, color: primaryClr,size: 16,),
                                                Icon(Icons.female, color: primaryClr,size: 16,),
                                              ],
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 18,),
                                        Expanded(
                                          child: Container(
                                            padding: EdgeInsets.only(left: 5),
                                            width: MediaQuery.of(context).size.width - 50,
                                            height: 60,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.circular(8),
                                                boxShadow: const [
                                                  BoxShadow(
                                                    color: Colors.grey,
                                                    offset:  Offset(
                                                      1.0,
                                                      1.0,
                                                    ),
                                                    blurRadius: 0.5,
                                                    spreadRadius: 0.5,
                                                  ),
                                                ]
                                            ),
                                            child: DropdownButtonHideUnderline(
                                              child: DropdownButton(
                                                isExpanded: true,
                                                // Initial Value
                                                value: gender,
                                                dropdownColor: Colors.white,
                                                hint: const Text("Gender", style: TextStyle(
                                                  color: webBackgroundColor
                                                ),),
                                                // Down Arrow Icon
                                                icon:  const Icon(Icons.keyboard_arrow_down,color:  webBackgroundColor),

                                                // Array list of items
                                                items: ['Male', 'Female', 'Other'].map(( items) {
                                                  return DropdownMenuItem(
                                                    value: items
                                                        .toString(),
                                                    child: Text(items.toString(), style: TextStyle(
                                                      color: webBackgroundColor
                                                    ),),
                                                  );
                                                }).toList(),
                                                // After selecting the desired option,it will
                                                // change button value to selected value
                                                onChanged: ( newValue) {
                                                  setState(() {
                                                    gender = newValue;
                                                  });
                                                },
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 30,
                                  ),

                                  Container(
                                    width: MediaQuery.of(context).size.width - 30,
                                    child: NeoPopTiltedButton(
                                      isFloating: true,
                                      onTapUp: () {
                                        setState(() {
                                          isLoading = true;
                                        });
                                        if (_formkey.currentState!.validate()) {
                                          seekerSignUp();
                                          setState(() {
                                            isLoading = true;
                                          });
                                        }
                                        else {
                                          setState(() {
                                            isLoading = false;
                                          });
                                          Fluttertoast.showToast(
                                              msg: "All fields are required");
                                        }
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
                                          child: isLoading ? Center(
                                            child: Container(
                                              height: 30,
                                              width: 30,
                                              child: CircularProgressIndicator(
                                                color: whiteColor,
                                              ),
                                            ),
                                          ):
                                          const  Text('Send OTP',
                                              style: TextStyle(
                                                color: mobileBackgroundColor,
                                                //ThemeDate.isDark? AppColors.txtPrmyLightColor:AppColors.txtPrmydarkColor,
                                                fontWeight: FontWeight.bold,

                                              )),
                                        ),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      if (_formkey.currentState!.validate()) {
                                        seekerSignUp();
                                        setState(() {
                                          isLoading = true;
                                        });
                                      }
                                      else {
                                        setState(() {
                                          isLoading = false;
                                        });
                                        Fluttertoast.showToast(
                                            msg: "All fields are required");
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width / 1.1,
                                      height: 52,
                                      alignment: Alignment.center,
                                      //padding: EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                          color: primaryClr,
                                          borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: isLoading ?
                                      Center(
                                        child: Container(
                                          width: 30,
                                          height: 30,
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        ),
                                      )
                                          : Text("Submit", style: TextStyle(
                                        color: whiteColor,
                                        fontWeight: FontWeight.w600
                                      ),),
                                    ),
                                  ),
                                  // CustomTextButton(
                                  //   buttonText: 'Submit',
                                  //   onTap: () {
                                  //    if( _formkey.currentState!.validate()){
                                  //      seekerSignUp();
                                  //    }
                                  //    else{
                                  //     Fluttertoast.showToast(msg: "All fields are required");
                                  //    }
                                  //     //jobseekersignup();
                                  //   },
                                  // ),
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "I already have an account!",
                                        style: TextStyle(
                                            color: greyColor,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      GestureDetector(onTap: (){
                                        // Get.to(SignInScreen());
                                        },child: Text("  Sign In", style: TextStyle(color: primaryClr, fontWeight: FontWeight.bold),))
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          //           TabBar(
                          //               labelColor: primaryClr,
                          //               unselectedLabelColor: Colors.grey,
                          //               labelStyle: TextStyle(
                          //                   fontSize: 18, fontWeight: FontWeight.bold),
                          //               unselectedLabelStyle: TextStyle(
                          //                   fontSize: 18, fontWeight: FontWeight.bold),
                          //               indicator: UnderlineTabIndicator(
                          //                   borderSide:
                          //                       BorderSide(width: 4.5, color: primaryClr)),
                          //               indicatorColor: primaryClr,
                          //               indicatorSize: TabBarIndicatorSize.label,
                          //               tabs: [
                          //                 Tab(
                          //                   text: "Job Seeker",
                          //                 ),
                          //                 Tab(
                          //                   text: "Recruiter",
                          //                 ),
                          //               ]),
                          //           SizedBox(
                          //             height: 12,
                          //           ),
                          //           SizedBox(
                          //             height: MediaQuery.of(context).size.height / 1.65,
                          //             child: TabBarView(children: [
                          //               // JobSeekerTab(),
                          //               /// seeker section
                          //               Container(
                          //                 child: Form(
                          //                   key: _formkey,
                          //                   child: ListView(
                          //                     children: [
                          //                       AuthTextField(
                          //                         validatior: (value) {
                          //                           if (value!.isEmpty) {
                          //                             return "Enter Some Text";
                          //                             print("Email");
                          //                           }
                          //                           return null;
                          //                         },
                          //                         obsecureText: false,
                          //                         iconImage: Image.asset(
                          //                           'assets/AuthAssets/Icon material-email.png',
                          //                           scale: 1.3,
                          //                           color: primaryClr,
                          //                         ),
                          //                         hintText: "Email",
                          //                         keyboardtype: TextInputType.emailAddress,
                          //                         controller: jemailController,
                          //                       ),
                          //                       AuthTextField(
                          //                         validatior: (value) {
                          //                           if (value == null || value.isEmpty) {
                          //                             return 'Enter above Detail';
                          //                           }
                          //                         },
                          //                         obsecureText: false,
                          //                         iconImage: Image.asset(
                          //                           'assets/AuthAssets/Icon awesome-user.png',
                          //                           scale: 1.3,
                          //                           color: primaryClr,
                          //                         ),
                          //                         hintText: "First Name",
                          //                         controller: jfirstNameController,
                          //                       ),
                          //                       AuthTextField(
                          //                         validatior: (value) {
                          //                           if (value == null || value.isEmpty) {
                          //                             return 'Enter above Detail';
                          //                           }
                          //                         },
                          //                         obsecureText: false,
                          //                         iconImage: Image.asset(
                          //                           'assets/AuthAssets/Icon awesome-user.png',
                          //                           scale: 1.3,
                          //                           color: primaryClr,
                          //                         ),
                          //                         hintText: "Last Name",
                          //                         controller: jlastNameController,
                          //                       ),
                          //                       AuthTextField(
                          //                         validatior: (value) {
                          //                           if (value == null || value.isEmpty) {
                          //                             return 'Enter above Detail';
                          //                           }
                          //                         },
                          //                         obsecureText: false,
                          //                         iconImage: Image.asset(
                          //                           'assets/AuthAssets/Icon ionic-ios-call.png',
                          //                           scale: 1.3,
                          //                           color: primaryClr,
                          //                         ),
                          //                         hintText: "Mobile No.",
                          //                         keyboardtype: TextInputType.number,
                          //                         length: 10,
                          //                         controller: jmobileController,
                          //                       ),
                          //                       AuthTextField(
                          //                         suffixIcons: InkWell(
                          //                             onTap: (){
                          //                               setState(() {
                          //                                 showPassword = !showPassword;
                          //                               });
                          //                             },
                          //                             child: Icon(showPassword == true ? Icons.visibility : Icons.visibility_off,color: primaryClr,)),
                          //                         obsecureText:showPassword == true ? false : true,
                          //                         controller: jpasswordController,
                          //                         iconImage: Image.asset('assets/AuthAssets/Icon ionic-ios-lock.png', scale: 1.3, color: primaryClr,),
                          //                         hintText: 'Password',
                          //
                          //                         validatior: (value) {
                          //                           if (value == null || value.isEmpty) {
                          //                             return 'Enter above Detail';
                          //                           }
                          //                         },
                          //                       ),
                          //
                          //                       // AuthTextField(
                          //                       //   suffixIcons: InkWell(
                          //                       //       onTap: (){
                          //                       //         setState(() {
                          //                       //           showPassword = !showPassword;
                          //                       //         });
                          //                       //       },
                          //                       //       child: showPassword == true ? Icon(Icons.visibility) : Icon(Icons.visibility_off)
                          //                       //   ),
                          //                       //
                          //                       //   validatior: (value) {
                          //                       //     if (value == null || value.isEmpty) {
                          //                       //       return 'Enter above Detail';
                          //                       //     }
                          //                       //   },
                          //                       //   obsecureText: showPassword == true ? true : false,
                          //                       //   iconImage: Image.asset(
                          //                       //     'assets/AuthAssets/Icon ionic-ios-lock.png',
                          //                       //     scale: 1.3,
                          //                       //     color: primaryClr,
                          //                       //   ),
                          //                       //   hintText: "Password",
                          //                       //   controller: jpasswordController,
                          //                       // ),
                          //
                          //                       // AuthTextField(
                          //                       //   validatior: (value){
                          //                       //     if (value == null || value.isEmpty) {
                          //                       //       return 'Enter above Detail';
                          //                       //     }
                          //                       //   },
                          //                       //   obsecureText: true,
                          //                       //   iconImage: Image.asset(
                          //                       //     'assets/AuthAssets/Icon ionic-ios-lock.png',
                          //                       //     scale: 1.3,
                          //                       //     color: primaryClr,
                          //                       //   ),
                          //                       //   hintText: "Confirm Password",
                          //                       //   controller: jcpasswordController,
                          //                       // ),
                          //                       SizedBox(
                          //                         height: 30,
                          //                       ),
                          //                       GestureDetector(
                          //                         onTap: () {
                          //                           setState(() {
                          //                             isLoading = true;
                          //                           });
                          //                           if (_formkey.currentState!.validate()) {
                          //                             seekerSignUp();
                          //                             setState(() {
                          //                               isLoading = true;
                          //                             });
                          //                           }
                          //                           else {
                          //                             Fluttertoast.showToast(
                          //                                 msg: "All fields are required");
                          //                           }
                          //                         },
                          //                         child: Container(
                          //                           width: MediaQuery.of(context).size.width / 1.1,
                          //                           height: 52,
                          //                           alignment: Alignment.center,
                          //                           //padding: EdgeInsets.all(6),
                          //                           decoration: BoxDecoration(
                          //                               color: primaryClr,
                          //                               borderRadius: BorderRadius.circular(10)
                          //                           ),
                          //                           child: isLoading ?
                          //                           Center(
                          //                             child: Container(
                          //                               width: 30,
                          //                               height: 30,
                          //                               child: CircularProgressIndicator(
                          //                                 color: Colors.white,
                          //                               ),
                          //                             ),
                          //                           )
                          //                               : Text("Submit", style: buttonTextStyle,),
                          //                         ),
                          //                       ),
                          //                       // CustomTextButton(
                          //                       //   buttonText: 'Submit',
                          //                       //   onTap: () {
                          //                       //    if( _formkey.currentState!.validate()){
                          //                       //      seekerSignUp();
                          //                       //    }
                          //                       //    else{
                          //                       //     Fluttertoast.showToast(msg: "All fields are required");
                          //                       //    }
                          //                       //     //jobseekersignup();
                          //                       //   },
                          //                       // ),
                          //                       SizedBox(
                          //                         height: 15,
                          //                       ),
                          //                       Row(
                          //                         mainAxisAlignment: MainAxisAlignment.center,
                          //                         children: [
                          //                           Text(
                          //                             "I already have an account!",
                          //                             style: TextStyle(
                          //                                 color: greyColor,
                          //                                 fontWeight: FontWeight.bold),
                          //                           ),
                          //                             GestureDetector(onTap: (){Get.to(SignInScreen());},child: Text("  Sign In", style: TextStyle(color: primaryClr, fontWeight: FontWeight.bold),))
                          //                         ],
                          //                       ),
                          //                       SizedBox(
                          //                         height: 20,
                          //                       ),
                          //                     ],
                          //                   ),
                          //                 ),
                          //               ),
                          //               /// Recruiter section
                          //              Container(
                          //   child: Form(
                          //     key: _formkey1,
                          //     child: ListView(
                          //       shrinkWrap: true,
                          //       physics: AlwaysScrollableScrollPhysics(),
                          //       children: [
                          //         AuthTextField(
                          //           obsecureText: false,
                          //           keyboardtype: TextInputType.emailAddress,
                          //           iconImage: Image.asset('assets/AuthAssets/Icon material-email.png', scale: 1.3, color: primaryClr,),hintText: "Email", controller: remailController,),
                          //         AuthTextField(
                          //           obsecureText: false,
                          //           iconImage: Image.asset('assets/AuthAssets/Icon awesome-user.png', scale: 1.3, color: primaryClr,),hintText: "Full Name",controller: fullNameController,),
                          //         AuthTextField(
                          //           obsecureText: false,iconImage: Image.asset('assets/AuthAssets/Icon awesome-user.png', scale: 1.3, color: primaryClr,),hintText: "Company Name", controller: companyNameController ,),
                          //         AuthTextField(
                          //           obsecureText: false,
                          //           keyboardtype: TextInputType.number,
                          //           length: 10,
                          //           controller: mobileController,
                          //           iconImage: Image.asset('assets/AuthAssets/Icon ionic-ios-call.png', scale: 1.3, color: primaryClr,),hintText: "Mobile No.",),
                          //         AuthTextField(
                          //           suffixIcons: InkWell(
                          //               onTap: (){
                          //                 setState(() {
                          //                   showPassword = !showPassword;
                          //                 });
                          //               },
                          //               child: Icon(showPassword == true ? Icons.visibility : Icons.visibility_off,color: primaryClr,)),
                          //           obsecureText:showPassword == true ? false : true,
                          //           controller: passwordController,
                          //           iconImage: Image.asset('assets/AuthAssets/Icon ionic-ios-lock.png', scale: 1.3, color: primaryClr,),
                          //           hintText: 'Password',
                          //         ),
                          //         // AuthTextField(
                          //         //   obsecureText: true,
                          //         //   iconImage: Image.asset('assets/AuthAssets/Icon ionic-ios-lock.png', scale: 1.3, color: primaryClr,),hintText: "Confirm Password",),
                          //         // SizedBox(height: 30,),
                          //         CustomTextButton(buttonText: 'Submit', onTap: (){
                          //           if(_formkey1.currentState!.validate()){
                          //             recruiterSignUp();
                          //           }
                          //           else{
                          //             Fluttertoast.showToast(msg: "All fields are required");
                          //           }
                          //           //recruitersignup();
                          //           },),
                          //         SizedBox(height: 15,),
                          //         Row(
                          //           mainAxisAlignment: MainAxisAlignment.center,
                          //           children: [
                          //             Text(
                          //               "I already have an account!",
                          //               style: TextStyle(
                          //                   color: greyColor,
                          //                   fontWeight: FontWeight.bold),
                          //             ),
                          //             GestureDetector(onTap: (){Get.to(SignInScreen());},child: Text("  Sign In", style: TextStyle(color: primaryClr, fontWeight: FontWeight.bold),))
                          //           ],
                          //         ),
                          //         SizedBox(height: 20,),
                          //       ],
                          //     ),
                          //   ),
                          // ),
                          //               //RecruiterTab()
                          //             ]),
                          //           ),
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        ));
  }
}

extension EmailValidator on String {
  bool isValidEmail() {
    return RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }
}