import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:CTJan/utils/colors.dart';

pickImage(ImageSource source) async {
  final ImagePicker imagePicker = ImagePicker();

  XFile? file = await imagePicker.pickImage(source: source);

  if (file != null) {
    return await file.readAsBytes();
  }
  if (kDebugMode) {
    print('No Image Selected');
  }
}

showSnackbar(String content, BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      backgroundColor: primaryClr,
      content: Text(content,
        style: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600
      ),),
    ),
  );
}
