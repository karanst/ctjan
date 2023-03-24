import 'package:flutter/material.dart';

import 'package:flutter/material.dart';
import 'package:CTJan/utils/colors.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPassword;
  final String hintText;
  final String? title;
  final TextInputType textInputType;
  const CustomTextField(
      {Key? key,
        required this.textEditingController,
        this.isPassword = false,
        required this.hintText,
        required this.title,
        required this.textInputType})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final inputBorder =
    //     OutlineInputBorder(borderSide: Divider.createBorderSide(context));
    return Padding(
      padding: const EdgeInsets.only(top: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(title.toString(), style: TextStyle(
              color: primaryClr,
              fontSize: 18,
              fontWeight: FontWeight.w600,

            ),),
          ),
          Container(
              padding: EdgeInsets.only(left: 5),
              width: MediaQuery.of(context).size.width -20,
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
              child: TextField(
                keyboardType: textInputType,
                decoration:  InputDecoration(
                  hintText: hintText,
                    hintStyle: TextStyle(
                      color: greyColor
                    ),
                    border: InputBorder.none
                ),
                style: const TextStyle(
                    color: primaryColor
                ),
                controller: textEditingController,
              )
          ),
        ],
      ),
    );
  }
}
