import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:CTJan/Helper/api_path.dart';
import 'package:CTJan/models/get_profile_model.dart';
import 'package:CTJan/models/group_list_model.dart';
import 'package:CTJan/screens/feed_screen.dart';
import 'package:CTJan/utils/colors.dart';
import 'package:CTJan/utils/utils.dart';
import 'package:neopop/widgets/buttons/neopop_tilted_button/neopop_tilted_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../Helper/token_strings.dart';
import '../models/User.dart';

class GroupCard extends StatefulWidget {
  final GroupList data;
  const GroupCard({Key? key, required this.data}) : super(key: key);

  @override
  State<GroupCard> createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  bool isLikeAnimating = false;
  User? user;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getProfileData();
    // getComments();
  }
  bool loadingData = false;
  String? userid;
  String? groupJoined;


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
          groupJoined = jsonResponse.userId!.groupId.toString();
          // loadingData = false;
          // profileImage = jsonResponse.userId!.profilePic.toString();
          // userName = jsonResponse.userId!.username.toString();
          // email = jsonResponse.userId!.email.toString();
          // seekerProfileModel = jsonResponse;
          // firstNameController = TextEditingController(text: seekerProfileModel!.data![0].name);
          // emailController = TextEditingController(text: seekerProfileModel!.data![0].email);
          // mobileController = TextEditingController(text: seekerProfileModel!.data![0].mobile);
          // profileImage = '${seekerProfileModel!.data![0].image}';
        });
        print("this is group status $groupJoined");
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

  joinGroup(String groupId)async{
    setState(() {
      loadingData = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('POST', Uri.parse(ApiPath.joinGroup));
    request.fields.addAll({
      'user_id': userid.toString(),
      'group_id': groupId.toString()
      // 'seeker_email': '$userid'
    });
    print("this is group join request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      if(jsonResponse['response_code'] == "1") {
        Navigator.push(context, MaterialPageRoute(builder: (context)=> const FeedScreen()));
        showSnackbar("${jsonResponse['message']}", context);
      }else{
        showSnackbar("${jsonResponse['message']}", context);
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

  // void getComments() async {
  //   try {
  //     QuerySnapshot snap = await FirebaseFirestore.instance
  //         .collection('posts')
  //         .doc(widget.snap['postId'])
  //         .collection('comments')
  //         .get();
  //     commentLen = snap.docs.length;
  //   } catch (err) {
  //     if (kDebugMode) {
  //       print(err.toString());
  //     }
  //   }
  //   setState(() {});
  // }

  @override
  Widget build(BuildContext context) {
   return Card(
     elevation: 15,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20)
      ),
          child: Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(
          vertical: 10,
      ),
      child: Column(
          children: [
            // Header Section
            Container(
              padding: const EdgeInsets.symmetric(
                vertical: 4,
                horizontal: 16,
              ).copyWith(right: 0),
              child: Row(
                children: [
                  widget.data.image.toString() != '' || widget.data.image.toString() != null ?
                  CircleAvatar(
                    radius: 60,
                    backgroundImage:
                    NetworkImage(
                      widget.data.image.toString(),
                    ),
                  )
                  : const CircleAvatar(
                    radius: 60,
                    child: Icon(Icons.groups, color: Colors.white,),
                  ),

                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 8,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              widget.data.name.toString(),
                              style: const TextStyle(
                                color: primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: const [
                                 Text("Date added : ",
                                  // DateFormat.yMMMd().format(
                                  //   // widget.snap['datePublished'].toDate(),
                                  // ),
                                  style:  TextStyle(
                                    fontSize: 12,
                                    color: secondaryColor,
                                  ),
                                ),
                                Text("22-3-2023")
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Row(
                              children: [
                                const Text("No. of users : ",
                                  // DateFormat.yMMMd().format(
                                  //   // widget.snap['datePublished'].toDate(),
                                  // ),
                                  style:  TextStyle(
                                    fontSize: 12,
                                    color: secondaryColor,
                                  ),
                                ),
                                Text("28")
                              ],
                            ),
                          ),
                          Container(
                            width: 130,
                            height: 65,
                            child: NeoPopTiltedButton(
                              isFloating: true,
                              onTapUp: () {
                                String groupId = widget.data.id.toString();
                                if(groupJoined == "0"){
                                  joinGroup(groupId);
                                }else{
                                  showSnackbar("Already joined an group!", context);
                                }
                              },
                              decoration:  NeoPopTiltedButtonDecoration(
                                  color: primaryClr,
                                  plunkColor: Colors.black,
                                  shadowColor: Colors.grey,
                                  showShimmer: true,
                                  shimmerColor: Colors.white,
                                  shimmerWidth: 10),
                              child: const  Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 30.0,
                                    vertical: 15,
                                  ),
                                  child: Text('Join Group',
                                      style: TextStyle(
                                        color: mobileBackgroundColor,
                                        //ThemeDate.isDark? AppColors.txtPrmyLightColor:AppColors.txtPrmydarkColor,
                                        fontWeight: FontWeight.bold,

                                      )),
                                ),
                              ),
                            ),
                          ),
                          // ElevatedButton(
                          //     onPressed: (){
                          //   Navigator.push(context, MaterialPageRoute(builder: (context)=> FeedScreen()));
                          // },
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: primaryClr
                          //     ),
                          //     child: Text("Join Group"))
                        ],
                      ),
                    ),
                  ),
                  // IconButton(
                  //   onPressed: () {
                  //     showDialog(
                  //       context: context,
                  //       builder: (context) => Dialog(
                  //         child: ListView(
                  //           padding: const EdgeInsets.symmetric(
                  //             vertical: 16,
                  //           ),
                  //           shrinkWrap: true,
                  //           children: ['Delete']
                  //               .map(
                  //                 (e) => InkWell(
                  //               onTap: () async {
                  //                 FirestoreMethods().deletePost(
                  //                     widget.snap['postId']);
                  //                 Navigator.of(context).pop();
                  //               },
                  //               child: Container(
                  //                 padding: const EdgeInsets.symmetric(
                  //                   vertical: 12,
                  //                   horizontal: 16,
                  //                 ),
                  //                 child: Text(e),
                  //               ),
                  //             ),
                  //           )
                  //               .toList(),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  //   icon: const Icon(
                  //     Icons.more_vert,
                  //     color: primaryColor,
                  //   ),
                  // )
                ],
              ),
            ),
            //Image Section
            // GestureDetector(
            //   onDoubleTap: () async {
            //     await FirestoreMethods().likePost(
            //       widget.snap['postId'],
            //       user!.uid,
            //       widget.snap['likes'],
            //     );
            //     setState(() {
            //       isLikeAnimating = true;
            //     });
            //   },
            //   child: Stack(
            //     alignment: Alignment.center,
            //     children: [
            //       SizedBox(
            //         height: MediaQuery.of(context).size.height * 0.35,
            //         width: double.infinity,
            //         child: Image.network(
            //           widget.snap['postUrl'],
            //           fit: BoxFit.cover,
            //         ),
            //       ),
            //       AnimatedOpacity(
            //         duration: const Duration(milliseconds: 200),
            //         opacity: isLikeAnimating ? 1 : 0,
            //         child: LikeAnimation(
            //           isAnimating: isLikeAnimating,
            //           duration: const Duration(
            //             milliseconds: 400,
            //           ),
            //           child: const Icon(
            //             Icons.favorite,
            //             color: primaryColor,
            //             size: 120,
            //           ),
            //           onEnd: () {
            //             setState(() {
            //               isLikeAnimating = false;
            //             });
            //           },
            //         ),
            //       )
            //     ],
            //   ),
            // ),
            // // Action section
            // Row(
            //   children: [
            //     LikeAnimation(
            //       isAnimating: widget.snap['likes'].contains(user!.uid),
            //       smallLike: true,
            //       child: IconButton(
            //         onPressed: () async {
            //           await FirestoreMethods().likePost(
            //             widget.snap['postId'],
            //             user!.uid,
            //             widget.snap['likes'],
            //           );
            //         },
            //         icon: widget.snap['likes'].contains(user!.uid)
            //             ? const Icon(
            //           Icons.favorite,
            //           color: Colors.red,
            //         )
            //             : const Icon(
            //           Icons.favorite_outline_outlined,
            //           color: primaryColor,
            //         ),
            //       ),
            //     ),
            //     IconButton(
            //       onPressed: () => Navigator.push(
            //         context,
            //         MaterialPageRoute(
            //           builder: (context) => CommentsScreen(
            //             snap: widget.snap,
            //           ),
            //         ),
            //       ),
            //       icon: const Icon(
            //         Icons.comment_outlined,
            //         color: primaryColor,
            //       ),
            //     ),
            //     IconButton(
            //       onPressed: () {},
            //       icon: const Icon(
            //         Icons.send_outlined,
            //         color: primaryColor,
            //       ),
            //     ),
            //     Expanded(
            //       child: Align(
            //         alignment: Alignment.bottomRight,
            //         child: IconButton(
            //           onPressed: () {},
            //           icon: const Icon(
            //             Icons.bookmark_border,
            //             color: primaryColor,
            //           ),
            //         ),
            //       ),
            //     )
            //   ],
            // ),
            //Description and comment count
            // Container(
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 16,
            //   ),
            //   child: Column(
            //     mainAxisSize: MainAxisSize.min,
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // DefaultTextStyle(
            //       //   style: Theme.of(context).textTheme.subtitle2!.copyWith(
            //       //     fontWeight: FontWeight.bold,
            //       //   ),
            //       //   child: const Text(
            //       //       'likes',
            //       //       style: TextStyle(
            //       //         color: primaryColor,
            //       //       )
            //       //     //Theme.of(context).textTheme.bodyText2,
            //       //   ),
            //       // ),
            //       // Container(
            //       //   width: double.infinity,
            //       //   padding: const EdgeInsets.only(
            //       //     top: 8,
            //       //   ),
            //       //   child: RichText(
            //       //       text: TextSpan(
            //       //           style: const TextStyle(color: primaryColor),
            //       //           children: [
            //       //             TextSpan(
            //       //               text: widget.data.name.toString(),
            //       //               style: const TextStyle(
            //       //                 fontWeight: FontWeight.bold,
            //       //                 color: primaryColor,
            //       //               ),
            //       //             ),
            //       //             TextSpan(
            //       //                 text: '  ${widget.data.description.toString()}',
            //       //                 style: const TextStyle(
            //       //                   color: primaryColor,
            //       //                 )
            //       //             ),
            //       //           ])),
            //       // ),
            //       InkWell(
            //         onTap: () {},
            //         child: Container(
            //           padding: const EdgeInsets.symmetric(vertical: 4),
            //           child: GestureDetector(
            //             // onTap: () => Navigator.push(
            //             //   context,
            //             //   MaterialPageRoute(
            //             //     builder: (context) => CommentsScreen(
            //             //       snap: widget.snap,
            //             //     ),
            //             //   ),
            //             // ),
            //             child: commentLen > 0
            //                 ? Text(
            //               'View all $commentLen comments',
            //               style: const TextStyle(
            //                 fontSize: 16,
            //                 color: secondaryColor,
            //               ),
            //             )
            //                 : Container(),
            //           ),
            //         ),
            //       ),
            //
            //     ],
            //   ),
            // )
          ],
      ),
    ),
        );
  }
}
