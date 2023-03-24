import 'dart:convert';
import 'package:CTJan/Helper/api_path.dart';
import 'package:CTJan/Helper/token_strings.dart';
import 'package:CTJan/models/comments_model.dart';
import 'package:CTJan/models/like_status_model.dart';
import 'package:CTJan/models/posts_model.dart';
import 'package:CTJan/screens/comments_screen.dart';
import 'package:CTJan/utils/utils.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:CTJan/providers/user_provider.dart';
import 'package:CTJan/utils/colors.dart';
import 'package:CTJan/widgets/like_animation.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../models/User.dart';

class PostCard extends StatefulWidget {
  final PostList? data;
  const PostCard({Key? key, required this.data}) : super(key: key);

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLikeAnimating = false;
  User? user;
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    getLikeStatus();
    // getComments();
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

  String? userid;
  List<Comments> commentList = [];
  String likeStats = '';
  bool isLiked = false;

  likeUnlike()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=0eaf4ebac75de632de1c0763f08419b4a3c1bdec'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse(ApiPath.likeUnlike));
    request.fields.addAll({
      'like_status':'1',
      'user_id': userid.toString(),
      'post_id':widget.data!.id.toString(),
      'group_id': widget.data!.groupId.toString()
    });

    print("this is login request ${request.fields.toString()}");

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {

      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      if(jsonResponse['response_code'] == '1'){

        // showSnackbar("${jsonResponse['message']}", context);

      }
      else{

      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  getLikeStatus() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=0eaf4ebac75de632de1c0763f08419b4a3c1bdec'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse(ApiPath.getPostLikes));

    request.fields.addAll({
      'user_id': '2',
      //userid.toString(),
      'post_id': '7'
    //widget.data!.id!.toString(),
    });

    print("this is like status request ${request.fields.toString()}");

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {

      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = LikeStatusModel.fromJson(json.decode(finalResponse));

      if(jsonResponse.responseCode == '1'){
        setState(() {
          likeStats = jsonResponse.data![0].likeStatus.toString();
        });
       print("this is like status =====>>>  ${likeStats.toString()}");
        if(likeStats == "1"){
          setState(() {
            isLiked = true;
          });
        }else{
          setState(() {
            isLiked = false;
          });
        }
      }
      else{

      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  getComments()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=0eaf4ebac75de632de1c0763f08419b4a3c1bdec'
    };
    var request = http.MultipartRequest('POST',
        Uri.parse(ApiPath.getComments));
    request.fields.addAll({
      'post_id':widget.data!.id.toString(),
    });

    print("this is login request ${request.fields.toString()}");

    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = CommentsModel.fromJson(json.decode(finalResponse));
      if(jsonResponse.responseCode == '1'){
        setState(() {
          commentList = jsonResponse.data!;
        });

        // showSnackbar("${jsonResponse['message']}", context);

      }
      else{

      }
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserProvider>(context).getUser;
    return user == null
        ? Container()
        : Container(
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
                      CircleAvatar(
                        radius: 16,
                        backgroundImage: NetworkImage(
                          widget.data!.img.toString(),
                        ),
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
                              Text(
                                widget.data!.name.toString(),
                                style: const TextStyle(
                                  color: primaryColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => Dialog(
                              child: ListView(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                                shrinkWrap: true,
                                children: ['Delete']
                                    .map(
                                      (e) => InkWell(
                                        onTap: () async {
                                          // FirestoreMethods().deletePost(
                                          //     widget.snap['postId']);
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            vertical: 12,
                                            horizontal: 16,
                                          ),
                                          child: Text(e),
                                        ),
                                      ),
                                    )
                                    .toList(),
                              ),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.more_vert,
                          color: primaryColor,
                        ),
                      )
                    ],
                  ),
                ),
                //Image Section
                GestureDetector(
                  onDoubleTap: () async {
                    setState(() {
                      isLiked = !isLiked;
                    });
                    likeUnlike();
                    // await FirestoreMethods().likePost(
                    //   widget.snap['postId'],
                    //   user!.uid,
                    //   widget.snap['likes'],
                    // );
                    setState(() {
                      isLikeAnimating = true;
                    });
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        width: double.infinity,
                        child: Image.network(
                          widget.data!.img.toString(),
                          // widget.snap['postUrl'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 200),
                        opacity: isLikeAnimating ? 1 : 0,
                        child: LikeAnimation(
                          isAnimating: isLikeAnimating,
                          duration: const Duration(
                            milliseconds: 400,
                          ),
                          child: const Icon(
                            Icons.favorite,
                            color: primaryColor,
                            size: 120,
                          ),
                          onEnd: () {
                            setState(() {
                              isLikeAnimating = false;
                            });
                          },
                        ),
                      )
                    ],
                  ),
                ),
                // Action section
                Row(
                  children: [
                    LikeAnimation(
                      isAnimating: isLiked,
                      //widget.snap['likes'].contains(user!.uid),
                      smallLike: isLiked,
                      child: IconButton(
                        onPressed: () async {
                          setState(() {
                            isLiked = !isLiked;
                          });
                          likeUnlike();
                          // await FirestoreMethods().likePost(
                          //   widget.snap['postId'],
                          //   user!.uid,
                          //   widget.snap['likes'],
                          // );
                        },
                        icon: isLiked
                            ? const Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : const Icon(
                                Icons.favorite_outline_outlined,
                                color: primaryColor,
                              ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CommentsScreen(
                              postId: widget.data!.id,
                              groupId: widget.data!.groupId,

                              // data: commentList[i],
                            ),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.comment_outlined,
                        color: primaryColor,
                      ),
                    ),
                    // IconButton(
                    //   onPressed: () {},
                    //   icon: const Icon(
                    //     Icons.send_outlined,
                    //     color: primaryColor,
                    //   ),
                    // ),
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomRight,
                        child: IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.bookmark_border,
                            color: primaryColor,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                //Description and comment count
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      DefaultTextStyle(
                        style: Theme.of(context).textTheme.subtitle2!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                        child: Text('${widget.data!.totalLike} likes',
                            style: const TextStyle(
                              color: primaryColor,
                            )
                            //Theme.of(context).textTheme.bodyText2,
                            ),
                      ),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.only(
                          top: 8,
                        ),
                        child: RichText(
                            text: TextSpan(
                                style: const TextStyle(color: primaryColor),
                                children: [
                              TextSpan(
                                text: widget.data!.name.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: primaryColor,
                                ),
                              ),
                              TextSpan(
                                  text: '  ${widget.data!.description.toString()}',
                                  style: const TextStyle(
                                    color: primaryColor,
                                  )),
                            ])),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: GestureDetector(
                            onTap: () {
                            //   Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => CommentsScreen(
                            //       snap: widget.snap,
                            //     ),
                            //   ),
                            // );
  },
                            child: commentLen > 0
                                ? Text(
                                    'View all $commentLen comments',
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: secondaryColor,
                                    ),
                                  )
                                : Container(),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 4),
                        child: Text(
                          widget.data!.date.toString(),
                          // DateFormat.yMMMd().format(
                          //   widget.data!.date.
                          //  // widget.snap['datePublished'].toDate(),
                          // ),
                          style: const TextStyle(
                            fontSize: 12,
                            color: secondaryColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          );
  }
}
