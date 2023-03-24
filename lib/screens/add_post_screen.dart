import 'dart:convert';
import 'dart:io';
import 'package:CTJan/Helper/api_path.dart';
import 'package:CTJan/Helper/token_strings.dart';
import 'package:CTJan/responsive/mobile_screen_layout.dart';
import 'package:CTJan/utils/colors.dart';
import 'package:CTJan/utils/utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:neopop/neopop.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({Key? key}) : super(key: key);

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desController = TextEditingController();
  TextEditingController startController = TextEditingController();
  TextEditingController endController = TextEditingController();

  Uint8List? _file;
  File? cameraImage;
  final TextEditingController _descriptionController = TextEditingController();
  bool _isLoading = false;
  bool isLoading = false;
  var imagePathList;
  bool isImages = false;
  int selectIndex = 0;

  String? selectedValue;
  String _dateValue = '';
  var dateFormate;

  String convertDateTimeDisplay(String date) {
    final DateFormat displayFormater = DateFormat('yyyy-MM-dd HH:mm:ss.SSS');
    final DateFormat serverFormater = DateFormat('yyyy-MM-dd');
    final DateTime displayDate = displayFormater.parse(date);
    final String formatted = serverFormater.format(displayDate);
    return formatted;
  }

  Future _selectDate(String type) async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2025),
        //firstDate: DateTime.now().subtract(Duration(days: 1)),
        // lastDate: new DateTime(2022),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
                primaryColor: primaryClr,
                accentColor: Colors.black,
                colorScheme: ColorScheme.light(primary: primaryClr),
                // ColorScheme.light(primary: const Color(0xFFEB6C67)),
                buttonTheme:
                    ButtonThemeData(textTheme: ButtonTextTheme.accent)),
            child: child!,
          );
        });
    if (picked != null)
      setState(() {
        String yourDate = picked.toString();
        _dateValue = convertDateTimeDisplay(yourDate);
        print(_dateValue);
        dateFormate =
            DateFormat("dd/MM/yyyy").format(DateTime.parse(_dateValue ?? ""));
      });
    if (type == "1") {
      setState(() {
        startController = TextEditingController(text: _dateValue);
      });
    } else {
      setState(() {
        endController = TextEditingController(text: _dateValue);
      });
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Click Image from Camera'),
                onPressed: () async {
                  Navigator.of(context).pop();
          PickedFile? pickedFile = await ImagePicker().getImage(
          source: ImageSource.camera,
          );
          if (pickedFile != null) {
            setState(() {
              cameraImage = File(pickedFile.path);
              // imagePath = File(pickedFile.path) ;
              // filePath = imagePath!.path.toString();
            });
          }
                  // Uint8List file = await pickImage(
                  //   ImageSource.camera,
                  // );
                  // setState(() {
                  //   cameraImage = file;
                  //   isImages = false;
                  //   imagePathList.clear();
                  // });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose multi images from gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  getFromGallery();
                  // setState(() {
                  //   // _file = file;Start
                  // });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose Video from gallery'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),

              // SimpleDialogOption(
              //   padding: const EdgeInsets.all(20),
              //   child: const Text('Cancel'),
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // ),
            ],
          );
        });
  }

  Future<void> getFromGallery() async {
    var result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: true,
    );
    if (result != null) {
      setState(() {
        isImages = true;
        // servicePic = File(result.files.single.path.toString());
      });
      imagePathList = result.paths.toList();
      // imagePathList.add(result.paths.toString()).toList();
      print("SERVICE PIC === ${imagePathList.length}");
    } else {
      // User canceled the picker
    }
  }

  Widget uploadMultiImage() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectIndex = 0;
                      });
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectIndex == 0 ? primaryClr : Colors.grey),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "Normal",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectIndex = 1;

                      });
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectIndex == 1 ? primaryClr : Colors.grey),
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "Event",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        selectIndex = 2;
                      });
                    },
                    child: Container(
                      height: 35,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: selectIndex == 2 ? primaryClr : Colors.grey),
                      child: const Padding(
                        padding:  EdgeInsets.all(8.0),
                        child: Center(
                            child: Text(
                          "Public",
                          style: TextStyle(color: Colors.white),
                        )),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),

          Column(
            children: [
              Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 5,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextFormField(
                    style: const TextStyle(
                        color: primaryColor
                    ),
                    controller: titleController,
                    decoration: const InputDecoration(
                        contentPadding: EdgeInsets.only(left: 10),
                        hintText: 'Title',
                        hintStyle: TextStyle(color: primaryColor),
                        border: InputBorder.none),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              Card(
                elevation: 5,
                color: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: TextFormField(
                    style: const TextStyle(
                        color: primaryColor
                    ),
                    controller: desController,
                    decoration: const InputDecoration(
                        hintStyle: TextStyle(color: primaryColor),
                        hintText: 'Write a caption..', border: InputBorder.none),
                  ),
                ),
              ),
            ],
          ),
          selectIndex == 1
              ? Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: TextFormField(
                            style: const TextStyle(color: primaryColor),
                            readOnly: true,
                            controller: startController,
                            onTap: () {
                              _selectDate("1");
                            },
                            decoration: const InputDecoration(
                                contentPadding: EdgeInsets.only(left: 10),
                                border: InputBorder.none,
                                hintText: 'Select Date',
                                hintStyle: TextStyle(color: primaryColor)),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 5,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        child: Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: TextFormField(
                            style: const TextStyle(color: primaryColor),
                            readOnly: true,
                            controller: endController,
                            onTap: () {
                              _selectDate("2");
                            },
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.only(left: 10),
                              border: InputBorder.none,
                              hintText: 'End Date',
                              hintStyle: TextStyle(color: primaryColor),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : SizedBox(),
          SizedBox(
            height: 10,
          ),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: InkWell(
          //     onTap: () {
          //       _selectImage(context);
          //     },
          //     child: Container(
          //       decoration: BoxDecoration(
          //           color: primaryColor,
          //           borderRadius: BorderRadius.circular(20)),
          //       child: Center(
          //           child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             "Upload Images",
          //             style: TextStyle(color: Colors.white),
          //           ),
          //           IconButton(
          //               icon: Icon(
          //                 Icons.upload,
          //                 color: primaryClr,
          //               ),
          //               onPressed: () => _selectImage(context)),
          //         ],
          //       )),
          //     ),
          //   ),
          // ),

          Container(
            width: 130,
            height: 65,
            child: NeoPopTiltedButton(
              isFloating: true,
              onTapUp: () {
                _selectImage(context);
                // String groupId = widget.data.id.toString();
                // if(groupJoined == "0"){
                //   joinGroup(groupId);
                // }else{
                //   showSnackbar("Already joined an group!", context);
                // }
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
                  child: Icon(Icons.upload_file_outlined, color: Colors.white,)
                  // Text('Join Group',
                  //     style: TextStyle(
                  //       color: mobileBackgroundColor,
                  //       //ThemeDate.isDark? AppColors.txtPrmyLightColor:AppColors.txtPrmydarkColor,
                  //       fontWeight: FontWeight.bold,
                  //
                  //     )),
                ),
              ),
            ),
          ),

          // InkWell(
          //     onTap: () async {
          //       getFromGallery();
          //       // await pickImages();
          //     },
          //     child: Container(
          //         height: 40,
          //         width: 150,
          //         decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(10),
          //             color: primaryClr),
          //         child: Center(
          //             child: Text(
          //               "Upload Pictures",
          //               style: TextStyle(color:  primaryClr),
          //             )))),
          const SizedBox(
            height: 10,
          ),
          Visibility(
              visible: isImages,
              child:
                  imagePathList != null ? buildGridView() : const SizedBox.shrink()),
          isImages == false ?
          cameraImage != null ?
          Stack(
            children: [
              Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Container(
                    width: 100,
                    height: 100,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: Image.file(File(cameraImage!.path),
                          fit: BoxFit.cover),
                    ),
                  )),
              Positioned(
                top: 5,
                right: 10,
                child: InkWell(
                  onTap: () {
                    setState(() {

                    });
                  },
                  child: Icon(
                    Icons.remove_circle,
                    size: 30,
                    color: Colors.red.withOpacity(0.7),
                  ),
                ),
              )
            ],
          ) :
              const SizedBox.shrink()
              : const SizedBox.shrink(),
          isImages || cameraImage != null ?
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Container(
              width: MediaQuery.of(context).size.width - 40,
              // height: 65,
              child: NeoPopTiltedButton(
                isFloating: true,
                onTapUp: () {

                  setState(() {
                    isLoading = true;
                  });
                  uploadPost();
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
                      child: isLoading ?
                      const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text('Upload Post',
                        style: TextStyle(
                          color: mobileBackgroundColor,
                          //ThemeDate.isDark? AppColors.txtPrmyLightColor:AppColors.txtPrmydarkColor,
                          fontWeight: FontWeight.bold,
                        ))

                  ),
                ),
              ),
            ),
          )
          : const SizedBox.shrink(),

        ],
      ),
    );
  }

  Widget buildGridView() {
    return Container(
      height: MediaQuery.of(context).size.height / 5.0,
      child: ListView.builder(
          physics: AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          // physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
          itemCount: imagePathList.length,
          itemBuilder: (context, index) {
            return Stack(
              children: [
                Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Container(
                      width: 100,
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(15)),
                        child: Image.file(File(imagePathList[index]),
                            fit: BoxFit.cover),
                      ),
                    )),
                Positioned(
                  top: 5,
                  right: 10,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        imagePathList.remove(imagePathList[index]);
                      });
                    },
                    child: Icon(
                      Icons.remove_circle,
                      size: 30,
                      color: Colors.red.withOpacity(0.7),
                    ),
                  ),
                )
              ],
            );
          }),
    );
  }

  // postImage(String uid, String username, String profileImage) async {
  //   setState(() {
  //     _isLoading = true;
  //   });
  //   try {
  //     String response = await FirestoreMethods().uploadPost(
  //       _descriptionController.text,
  //       _file!,
  //       uid,
  //       username,
  //       profileImage,
  //     );
  //     if (!mounted) return;
  //     setState(() {
  //       _isLoading = false;
  //     });
  //     if (response == "Post is successfully created") {
  //       showSnackbar(response, context);
  //     } else {
  //       showSnackbar(response, context);
  //     }
  //     clearImage();
  //   } catch (err) {
  //     showSnackbar(err.toString(), context);
  //   }
  // }


  uploadPost() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? userid = prefs.getString(TokenString.userid);
    var headers = {
      'Cookie': 'ci_session=bcf2871e64e7fec397eaa77e3b6fa2b916b3eade'
    };
    var request =
    http.MultipartRequest('POST', Uri.parse(ApiPath.addPosts));
    request.fields.addAll({
      'start_date': startController.text.toString(),
      'end_date': endController.text.toString(),
      'title': titleController.text.toString(),
      'user_id': userid.toString(),
      'description': _descriptionController.text.toString(),
      'group_id':'5',
      'post_type':'$selectIndex'
    });

    if(isImages) {
      for (var i = 0; i < imagePathList.length; i++) {
        imagePathList == null
            ? null
            : request.files.add(await http.MultipartFile.fromPath(
            'img', imagePathList[i].toString()));
      }
    }else {
      request.files.add(await http.MultipartFile.fromPath(
          'img', cameraImage.toString()));
    }
    request.headers.addAll(headers);
    print("checking request of api here ${request.fields} aand");

    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResponse = await response.stream.bytesToString();
      final jsonResponse = json.decode(finalResponse);
      print("checking result ${jsonResponse}");
      if (jsonResponse['response_code'] == "1") {
        setState(() {
          isLoading = false;
          // isSuccess = true;
        });
        showSnackbar("${jsonResponse['message']}", context);
        Navigator.push(context, MaterialPageRoute(builder: (conetxt)=> BottomBar()));

      } else {
        setState(() {
          isLoading = false;
          // isSuccess = true;
        });
      }
    } else {
      setState(() {
        isLoading = false;
      });
      print(response.reasonPhrase);
    }
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: primaryClr,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: primaryColor,
          ),
          onPressed: clearImage,
        ),
        title: const Text('Add Post'),
        centerTitle: true,
        actions: [
          // TextButton(
          //   onPressed: () => postImage(
          //     user.uid,
          //     user.username,
          //     user.photoUrl,
          //   ),
          //   child: const Text(
          //     'Post',
          //     style: TextStyle(
          //       color: Colors.white,
          //       fontWeight: FontWeight.bold,
          //       fontSize: 16,
          //     ),
          //   ),
          // )
        ],
      ),
      body: _file == null
          ? Center(
              child: Column(
              children: [
                uploadMultiImage(),
              ],
            ))
          // uploadMultiImage()
          : Column(
              children: [
                _isLoading
                    ? const LinearProgressIndicator()
                    : const Padding(
                        padding: EdgeInsets.only(
                          top: 0,
                        ),
                      ),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.45,
                      child: TextField(
                        controller: _descriptionController,
                        decoration: InputDecoration(
                          hintText: 'Write a caption..',
                          hintStyle: TextStyle(color: primaryClr),
                          border: InputBorder.none,
                        ),
                        maxLines: 8,
                      ),
                    ),
                    SizedBox(
                      height: 45,
                      width: 45,
                      child: AspectRatio(
                        aspectRatio: 487 / 451,
                        child: Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: MemoryImage(_file!),
                              fit: BoxFit.fill,
                              alignment: FractionalOffset.topCenter,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const Divider(),
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: primaryClr,
                        fixedSize:
                            Size(MediaQuery.of(context).size.width / 2, 40)),
                    onPressed: () {},
                    child: Text(
                      "Post",
                      style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16),
                    ))
              ],
            ),
    );
  }
}
