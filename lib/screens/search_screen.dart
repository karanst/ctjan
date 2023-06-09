import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:CTJan/screens/profile_screen.dart';
import 'package:CTJan/utils/colors.dart';
import 'package:CTJan/utils/global_variables.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool _isShowUser = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Padding(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.18),
          child: TextFormField(
            maxLines: 1,
            controller: _searchController,
            decoration: const InputDecoration(
              hintText: 'Search for a user',
              icon: Icon(Icons.search_outlined),
            ),
            onFieldSubmitted: (String _) {
              setState(() {
                _isShowUser = true;
              });
            },
          ),
        ),
      ),
      body: Container(
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width >= webScreenSize
              ? MediaQuery.of(context).size.width * 0.14
              : 0,
          vertical: 10,
        ),
        child:
        // _isShowUser
        //     ?
        FutureBuilder(
                future: FirebaseFirestore.instance
                    .collection('users')
                    .where(
                      'username',
                      isGreaterThanOrEqualTo: _searchController.text,
                    )
                    .get(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(
                        color: primaryColor,
                      ),
                    );
                  }
                  return ListView.builder(
                    itemCount: (snapshot.data! as dynamic).docs.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ProfileScreen(
                              // uid: (snapshot.data! as dynamic).docs[index]
                              //     ['uid'],
                            ),
                          ),
                        ),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundImage: NetworkImage(
                              (snapshot.data! as dynamic)
                                      .docs[index]
                                      .data()
                                      .containsKey('photoUrl')
                                  ? (snapshot.data! as dynamic).docs[index]
                                      ['photoUrl']
                                  : 'https://dreamvilla.life/wp-content/uploads/2017/07/dummy-profile-pic.png',
                            ),
                          ),
                          title: Text(
                            (snapshot.data! as dynamic).docs[index]['username'],
                          ),
                        ),
                      );
                    },
                  );
                },
              )
            // : FutureBuilder(
            //     future: FirebaseFirestore.instance.collection('posts').get(),
            //     builder: (context, snapshot) {
            //       if (!snapshot.hasData) {
            //         return const Center(
            //           child: CircularProgressIndicator(
            //             color: primaryColor,
            //           ),
            //         );
            //       }
            //       return StaggeredGridView.countBuilder(
            //         crossAxisCount: 3,
            //         itemCount: (snapshot.data! as dynamic).docs.length,
            //         itemBuilder: (context, index) => Image.network(
            //           (snapshot.data! as dynamic).docs[index]['postUrl'],
            //           fit: BoxFit.cover,
            //         ),
            //         staggeredTileBuilder: (index) => StaggeredTile.count(
            //           (index % 7 == 0) ? 2 : 1,
            //           (index % 7 == 0) ? 2 : 1,
            //         ),
            //         mainAxisSpacing: 20,
            //         crossAxisSpacing: 20,
            //       );
            //     },
            //   ),
      ),
    );
  }
}
