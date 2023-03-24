import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:CTJan/Helper/token_strings.dart';
import 'package:CTJan/screens/add_post_screen.dart';
import 'package:CTJan/screens/feed_screen.dart';
import 'package:CTJan/screens/group_screen.dart';
import 'package:CTJan/screens/profile_screen.dart';
import 'package:CTJan/screens/search_screen.dart';
import 'package:CTJan/utils/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MobileScreenLayout extends StatefulWidget {
  const MobileScreenLayout({Key? key}) : super(key: key);

  @override
  State<MobileScreenLayout> createState() => _MobileScreenLayoutState();
}

class _MobileScreenLayoutState extends State<MobileScreenLayout> {
  int _page = 0;
  late PageController pageController;

  @override
  void initState() {
    pageController = PageController();
    super.initState();
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }

  void navigationTapped(int page) {
    pageController.jumpToPage(page);
  }

  void onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        physics: const NeverScrollableScrollPhysics(),
        controller: pageController,
        onPageChanged: onPageChanged,
        children: [
          const GroupScreen(),
          // const FeedScreen(),
          // const SearchScreen(),
          const AddPostScreen(),
          const Text(
            "notification",
          ),
          ProfileScreen(
            // uid: FirebaseAuth.instance.currentUser!.uid,
          ),
        ],
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: mobileBackgroundColor,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: _page == 0 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(
          //     Icons.search,
          //     color: _page == 1 ? primaryColor : secondaryColor,
          //   ),
          //   label: '',
          //   backgroundColor: primaryColor,
          // ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.add_circle,
              color: _page == 2 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: _page == 3 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: _page == 4 ? primaryColor : secondaryColor,
            ),
            label: '',
            backgroundColor: primaryColor,
          ),
        ],
        onTap: navigationTapped,
      ),
    );
  }
}




class BottomBar extends StatefulWidget {
  final String? type, bookingId;
  const BottomBar({Key? key, this.type, this.bookingId}) : super(key: key);

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {

  int _currentIndex = 0;
  var _selBottom = 0;
  String? bookID;


  @override
  void initState() {
    // getUserDataFromPrefs();
    super.initState();
    getUserDataFromPrefs();
  }

  String? userId ;
  String? isGroupJoined;


  getUserDataFromPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    userId = preferences.getString(TokenString.userid);
    isGroupJoined = preferences.getString(TokenString.groupJoined);
    setState(() {
      // userID = userData['user_id'];
    });
  }

  int currentIndex = 0;
  bool isLoading = false;

  Widget _getBottomNavigator() {
    return Material(
      // color: AppColor().colorTextSecondary(),
      //elevation: 2,
      child: CurvedNavigationBar(
        index: currentIndex,
        height: 50,
        buttonBackgroundColor: primaryClr,
        backgroundColor: primaryColor,
        // backgroundColor: Color(0xfff4f4f4),
        items: <Widget>[
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              Icons.home_filled,
              color: _currentIndex == 0 ? whiteColor : blackClr,
            )
            // ImageIcon(
            //   AssetImage(
            //       _currentIndex == 0 ?
            //       'images/icons/home_fill.png'
            //           : 'images/icons/home_fill.png'),
            //   color: AppColor().colorPrimary(),
            // ),
          ),

          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              Icons.add,
              color: _currentIndex == 1 ? whiteColor : blackClr,
            )
            // ImageIcon(
            //   AssetImage(
            //       _currentIndex == 1?
            //       'images/icons/product_fill.png'
            //           : 'images/icons/product_fill.png'),
            //   color: AppColor().colorPrimary(),
            // ),
          ),

          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              _currentIndex == 2 ?
              Icons.favorite
              : Icons.favorite_border,
              color: _currentIndex == 2 ? whiteColor : blackClr,
            )
            // ImageIcon(
            //   AssetImage(
            //       _currentIndex == 2?
            //       'images/icons/booking_fill.png'
            //           : 'images/icons/booking_fill.png'),
            //   color: AppColor().colorPrimary(),
            // ),
          ),

          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              // _currentIndex == 3 ?
              Icons.person,
                  // : Icons.person_3_outlined,
              color: _currentIndex == 3 ? whiteColor : blackClr,
            ),
            // child:
            // ImageIcon(
            //   AssetImage(
            //       _currentIndex == 3 ?
            //       'images/icons/profile_fill.png'
            //           : 'images/icons/profile_fill.png'),
            //   color: AppColor().colorPrimary(),
            // ),
          ),

        ],
        onTap: (index) {
          print("current index here ${index}");
          setState(() {
            _currentIndex = index;
            _selBottom = _currentIndex;
            print("sel bottom ${_selBottom}");
            //_pageController.jumpToPage(index);
          });
          // if (currentIndex == 3 ) {
          // if (CUR_USERID == null) {
          //   Navigator.push(
          //     context,
          //     MaterialPageRoute(
          //       builder: (context) => Login(),
          //     ),
          //   );
          //   // _pageController.jumpToPage(2);
          // }
          // }
        },
      ),
    );
  }
  List<dynamic> _handlePages = [
    const GroupScreen(),
   // const FeedScreen(),
    // const SearchScreen(),
    const AddPostScreen(),
    const Text(
      "notification",
    ),
    const ProfileScreen(
      // uid: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];
  List<dynamic> _handlePages1 = [
    const FeedScreen(),
    // const SearchScreen(),
    const AddPostScreen(),
    const Text(
      "notification",
    ),
    const ProfileScreen(
      // uid: FirebaseAuth.instance.currentUser!.uid,
    ),
  ];

  @override
  Widget build(BuildContext context) {

    // [
    //   HomeScreen(bookingId: widget.bookingId,), ProductsServicesScreen(),  ManageService(index: 0, isIcon: false,), Profile() ];
    return
      WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context,
                barrierDismissible: false,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Confirm Exit"),
                    content: Text("Are you sure you want to exit?"),
                    actions: <Widget>[
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: secondaryClr
                        ),
                        child: Text("YES"),
                        onPressed: () {

                          // SystemNavigator.pop();
                        },
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: secondaryClr
                        ),
                        child: Text("NO"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  );
                }
            );
            return true;
          },
          child: Scaffold(
              body: isGroupJoined == "0" ?
                  _handlePages1[_currentIndex]
             :  _handlePages[_currentIndex],
              bottomNavigationBar:

              _getBottomNavigator()
          )
      );
  }
}
