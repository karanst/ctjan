import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:CTJan/Helper/api_path.dart';
import 'package:CTJan/models/group_list_model.dart';
import 'package:CTJan/utils/colors.dart';
import 'package:CTJan/widgets/group_card.dart';
import 'package:CTJan/widgets/post_card.dart';

class GroupScreen extends StatefulWidget {
  const GroupScreen({Key? key}) : super(key: key);

  @override
  State<GroupScreen> createState() => _GroupScreenState();
}

class _GroupScreenState extends State<GroupScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getGroupList();
  }


  List<GroupList> list = [];
  getGroupList()async{

    var headers = {
      'Cookie': 'ci_session=21ebc11f1bb101ac0f04e6fa13ac04dc55609d2e'
    };
    var request = http.MultipartRequest('GET', Uri.parse(ApiPath.groupList));
    request.fields.addAll({
      // 'user_id': userid.toString()
      // 'seeker_email': '$userid'
    });
    print("this is profile request ${request.fields.toString()}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = GroupListModel.fromJson(json.decode(finalResponse));
      if(jsonResponse.responseCode == "1") {

        // setState(() {
          list = jsonResponse.data!;
        // });

      }else{

      }
      // print("select qualification here ${selectedQualification}");
    }
    else {
      print(response.reasonPhrase);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.arrow_back_ios, color:  primaryClr,),
        backgroundColor: primaryClr,
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsets.only(right: 50),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/applogo.png' ,height: 50, width: 50,),
              const Text("CTJan", style: TextStyle(
                  color: mobileBackgroundColor
              ),)
            ],
          ),
        ),
        // actions: [
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.add_box_outlined,
        //     ),
        //   ),
        //   IconButton(
        //     onPressed: () {},
        //     icon: const Icon(
        //       Icons.send_outlined,
        //     ),
        //   )
        // ],
      ),
      body: ListView.builder(
        itemCount: list.length,
          itemBuilder: (context, index){
        return GroupCard(
          data: list[index],
        );
      }),
    );
  }
}
