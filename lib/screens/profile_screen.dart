import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:CTJan/Helper/token_strings.dart';
import 'package:CTJan/models/get_profile_model.dart';
import 'package:CTJan/resources/auth_methods.dart';
import 'package:CTJan/resources/firestore_methods.dart';
import 'package:CTJan/screens/edit_profile_screen.dart';
import 'package:CTJan/screens/send_otp.dart';
import 'package:CTJan/utils/colors.dart';
import 'package:CTJan/utils/global_variables.dart';
import 'package:CTJan/widgets/follow_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Helper/api_path.dart';

class ProfileScreen extends StatefulWidget {
  // final String? uid;
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var userData = {};
  int postLen = 0;
  int followerLen = 0;
  int followingLen = 0;
  bool isFollowing = false;
  bool loadingData = false;
  @override
  void initState() {
    getProfileData();
    super.initState();
  }
  String? profileImage;
  String? userName;
  String? email;
  String? userid;
  getProfileData()async{
    setState(() {
      loadingData = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.getUserProfile));
    request.fields.addAll({
      'user_id': userid.toString()
      // 'seeker_email': '$userid'
    });
    print("this is profile request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = GetProfileModel.fromJson(json.decode(finalResponse));
      if(jsonResponse.responseCode == "1") {

        setState(() {
          loadingData = false;
          profileImage = jsonResponse.userId!.profilePic.toString();
          userName = jsonResponse.userId!.username.toString();
          email = jsonResponse.userId!.email.toString();
          // seekerProfileModel = jsonResponse;
          // firstNameController = TextEditingController(text: seekerProfileModel!.data![0].name);
          // emailController = TextEditingController(text: seekerProfileModel!.data![0].email);
          // mobileController = TextEditingController(text: seekerProfileModel!.data![0].mobile);
          // profileImage = '${seekerProfileModel!.data![0].image}';
        });
      }else{
        setState(() {
          loadingData = false;
        });
      }
      // print("select qualification here ${selectedQualification}");
    }
    else {
      print(response.reasonPhrase);
    }
  }
  // getProfileData() async {
  //   try {
  //     var userSnap = await FirebaseFirestore.instance
  //         .collection('users')
  //         .doc(widget.uid)
  //         .get();
  //     userData = userSnap.data()!;
  //     var postSnap = await FirebaseFirestore.instance
  //         .collection('posts')
  //         .where('uid', isEqualTo: widget.uid)
  //         .get();
  //     postLen = postSnap.docs.length;
  //     followerLen = userSnap.data()!['followers'].length;
  //     followingLen = userSnap.data()!['following'].length;
  //     isFollowing = userSnap
  //         .data()!['followers']
  //         .contains(FirebaseAuth.instance.currentUser!.uid);
  //     setState(() {});
  //   } catch (err) {
  //     if (kDebugMode) {
  //       print(err.toString());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MediaQuery.of(context).size.width > webScreenSize
          ? webBackgroundColor
          : mobileBackgroundColor,
      appBar: MediaQuery.of(context).size.width > webScreenSize
          ? null
          : AppBar(
        leading: Icon(Icons.add, color: primaryClr,),
              backgroundColor: primaryClr,
              title: Text(userName != null || userName != ""?
                   userName.toString()
                  : 'Loading'),
              centerTitle: false,
            ),
      body: ListView(
        children: [
          Padding(
            padding: MediaQuery.of(context).size.width > webScreenSize
                ? const EdgeInsets.all(15)
                : const EdgeInsets.all(5),
            child: Column(
              children: [
                getProfileDetailsSection(
                    MediaQuery.of(context).size.width > webScreenSize),
                const Divider(),
                // FutureBuilder(
                //   future: FirebaseFirestore.instance
                //       .collection('posts')
                //       .where('uid', isEqualTo: widget.uid)
                //       .get(),
                //   builder: (context, snapshot) {
                //     if (snapshot.connectionState == ConnectionState.waiting) {
                //       return const Center(
                //         child: CircularProgressIndicator(
                //           color: primaryColor,
                //         ),
                //       );
                //     }
                //     return GridView.builder(
                //         shrinkWrap: true,
                //         itemCount: (snapshot.data! as dynamic).docs.length,
                //         gridDelegate:
                //             const SliverGridDelegateWithFixedCrossAxisCount(
                //           crossAxisCount: 3,
                //           crossAxisSpacing: 5,
                //           mainAxisSpacing: 1.5,
                //           childAspectRatio: 1,
                //         ),
                //         itemBuilder: (context, index) {
                //           DocumentSnapshot snap =
                //               (snapshot.data! as dynamic).docs[index];
                //           return Image(
                //             image: NetworkImage(
                //               snap['postUrl'],
                //             ),
                //             fit: BoxFit.cover,
                //           );
                //         });
                //   },
                // )
              ],
            ),
          )
        ],
      ),
    );
  }

  Container getProfileDetailsSection(bool isWeb) {
    return
      // isWeb
      //   ? Container(
      //       margin: EdgeInsets.symmetric(
      //         horizontal: MediaQuery.of(context).size.width * 0.14,
      //         vertical: 10,
      //       ),
      //       child: Column(
      //         children: [
      //           Row(
      //             children: [
      //               CircleAvatar(
      //                 backgroundColor: Colors.grey,
      //                 backgroundImage: NetworkImage(
      //                   profileImage != '' || profileImage != null?
      //                       profileImage.toString()
      //                       : 'https://dreamvilla.life/wp-content/uploads/2017/07/dummy-profile-pic.png',
      //                       // :
      //                       // ? userData['photoUrl']
      //
      //                 ),
      //                 radius: MediaQuery.of(context).size.width * 0.08,
      //               ),
      //               // Expanded(
      //               //   flex: 1,
      //               //   child: Column(
      //               //     children: [
      //               //       Container(
      //               //         padding: const EdgeInsets.all(15),
      //               //         child: Row(
      //               //           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               //           children: [
      //               //             Text(
      //               //               userData.containsKey('username')
      //               //                   ? userData['username']
      //               //                   : 'Loading',
      //               //               style: const TextStyle(
      //               //                 fontWeight: FontWeight.w200,
      //               //                 fontSize: 24,
      //               //               ),
      //               //             ),
      //               //             FirebaseAuth.instance.currentUser!.uid ==
      //               //                     widget.uid
      //               //                 ? FollowButton(
      //               //                     background: mobileBackgroundColor,
      //               //                     borderColor: Colors.grey,
      //               //                     text: "Sign Out",
      //               //                     textColor: primaryColor,
      //               //                     function: () async {
      //               //                       AuthMethods().signOut();
      //               //                       Navigator.of(context).pushReplacement(
      //               //                         MaterialPageRoute(
      //               //                           builder: (context) =>
      //               //                               const SignInScreen()
      //               //                               //LoginScreen(),
      //               //                         ),
      //               //                       );
      //               //                     },
      //               //                   )
      //               //                 : isFollowing
      //               //                     ? FollowButton(
      //               //                         background: Colors.white,
      //               //                         borderColor: Colors.grey,
      //               //                         text: "Unfollow",
      //               //                         textColor: Colors.black,
      //               //                         function: () async {
      //               //                           await FirestoreMethods()
      //               //                               .followUser(
      //               //                                   FirebaseAuth.instance
      //               //                                       .currentUser!.uid,
      //               //                                   userData['uid']);
      //               //                           setState(() {
      //               //                             setState(() {
      //               //                               isFollowing = false;
      //               //                               followerLen--;
      //               //                             });
      //               //                           });
      //               //                         },
      //               //                       )
      //               //                     : FollowButton(
      //               //                         background: Colors.blue,
      //               //                         borderColor: Colors.blue,
      //               //                         text: "Follow",
      //               //                         textColor: Colors.white,
      //               //                         function: () async {
      //               //                           await FirestoreMethods()
      //               //                               .followUser(
      //               //                                   FirebaseAuth.instance
      //               //                                       .currentUser!.uid,
      //               //                                   userData['uid']);
      //               //                           setState(() {
      //               //                             isFollowing = true;
      //               //                             followerLen++;
      //               //                           });
      //               //                         },
      //               //                       )
      //               //           ],
      //               //         ),
      //               //       ),
      //               //       Row(
      //               //         mainAxisSize: MainAxisSize.max,
      //               //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //               //         children: [
      //               //           buildStatColumn(postLen, "Posts"),
      //               //           buildStatColumn(followerLen, "Followers"),
      //               //           buildStatColumn(followingLen, "Following"),
      //               //         ],
      //               //       ),
      //               //       Column(
      //               //         crossAxisAlignment: CrossAxisAlignment.end,
      //               //         mainAxisAlignment: MainAxisAlignment.end,
      //               //         children: [
      //               //           Container(
      //               //             width: double.infinity,
      //               //             padding:
      //               //                 const EdgeInsets.only(left: 15, top: 15),
      //               //             alignment: Alignment.centerLeft,
      //               //             child: Text(
      //               //               userData.containsKey('username')
      //               //                   ? userData['username']
      //               //                   : 'Loading',
      //               //               style: const TextStyle(
      //               //                 fontWeight: FontWeight.bold,
      //               //               ),
      //               //             ),
      //               //           ),
      //               //           Container(
      //               //             width: double.infinity,
      //               //             alignment: Alignment.centerLeft,
      //               //             padding:
      //               //                 const EdgeInsets.only(left: 15, top: 5),
      //               //             child: Text(
      //               //               userData.containsKey('bio')
      //               //                   ? userData['bio']
      //               //                   : 'loading',
      //               //             ),
      //               //           ),
      //               //         ],
      //               //       ),
      //               //     ],
      //               //   ),
      //               // ),
      //             ],
      //           ),
      //         ],
      //       ),
      //     )
      //   :
      Container(
            margin: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width * 0.05,
              vertical: 10,
            ),
            child: Column(
              children: [
                loadingData ?
                    Center(
                      child: CircularProgressIndicator(
                        color: primaryClr,
                      ),
                    )
               :  Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.grey,
                      backgroundImage: NetworkImage(
                        profileImage != '' || profileImage != null?
                             profileImage.toString()
                            : 'https://dreamvilla.life/wp-content/uploads/2017/07/dummy-profile-pic.png',
                      ),
                      radius: 48,
                    ),
                    const SizedBox(width: 10,),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: Text(
                              userName != '' || userName != null ?
                              userName.toString()
                                  : 'Guest',
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.only(
                              top: 15,
                            ),
                            child: Text(
                              email != '' || email != null ?
                              email.toString()
                                  : '',
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),

                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          //   children: [
                          //     FirebaseAuth.instance.currentUser!.uid ==
                          //             widget.uid
                          //         ? FollowButton(
                          //             background: mobileBackgroundColor,
                          //             borderColor: Colors.grey,
                          //             text: "Sign Out",
                          //             textColor: primaryColor,
                          //             function: () async {
                          //               AuthMethods().signOut();
                          //               Navigator.of(context).pushReplacement(
                          //                 MaterialPageRoute(
                          //                   builder: (context) =>
                          //                       const SignInScreen()
                          //                       //LoginScreen(),
                          //                 ),
                          //               );
                          //             },
                          //           )
                          //         : isFollowing
                          //             ? FollowButton(
                          //                 background: Colors.white,
                          //                 borderColor: Colors.grey,
                          //                 text: "Unfollow",
                          //                 textColor: Colors.black,
                          //                 function: () async {
                          //                   await FirestoreMethods().followUser(
                          //                       FirebaseAuth
                          //                           .instance.currentUser!.uid,
                          //                       userData['uid']);
                          //                   setState(() {
                          //                     setState(() {
                          //                       isFollowing = false;
                          //                       followerLen--;
                          //                     });
                          //                   });
                          //                 },
                          //               )
                          //             : FollowButton(
                          //                 background: Colors.blue,
                          //                 borderColor: Colors.blue,
                          //                 text: "Follow",
                          //                 textColor: Colors.white,
                          //                 function: () async {
                          //                   await FirestoreMethods().followUser(
                          //                       FirebaseAuth
                          //                           .instance.currentUser!.uid,
                          //                       userData['uid']);
                          //                   setState(() {
                          //                     isFollowing = true;
                          //                     followerLen++;
                          //                   });
                          //                 },
                          //               )
                          //   ],
                          // )
                        ],
                      ),
                    ),
                    Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primaryClr
                      ),
                        child: IconButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> EditProfileScreen()));
                        }, icon: const Icon(Icons.edit, color: mobileBackgroundColor,)))
                  ],
                ),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   padding: const EdgeInsets.only(
                //     top: 15,
                //   ),
                //   child: Text(
                //     userName != '' || userName != null ?
                //         userName.toString()
                //         : 'Loading',
                //     style: const TextStyle(
                //       fontWeight: FontWeight.bold,
                //     ),
                //   ),
                // ),
                // Container(
                //   alignment: Alignment.centerLeft,
                //   padding: const EdgeInsets.only(
                //     top: 15,
                //   ),
                //   child: Text(
                //     userData.containsKey('bio') ? userData['bio'] : 'loading',
                //   ),
                // ),
              ],
            ),
          );
  }

  Column buildStatColumn(int num, String label) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w400,
              color: Colors.grey,
            ),
          ),
        )
      ],
    );
  }
}
