import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' as image_picker_library;
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class ImagePicker {
  static void show({BuildContext context, ValueChanged<File> onImageSelected}) {
    showMaterialModalBottomSheet(
      context: context,
      builder: (context, scrollController) => Container(
        height: 200,
        child: ListView(
          padding: EdgeInsets.all(0),
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
            ListTile(
              title: Text(
                'Choose profile picture from',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            ListTile(
              title: Text('Gallery'),
              leading: Icon(Icons.photo_album, color: AppColors.defaultColor),
              onTap: () {
                _launchImageSelection(
                  source: image_picker_library.ImageSource.gallery,
                  context: context,
                  onImageSelected: onImageSelected,
                );
              },
            ),
            Divider(),
            ListTile(
              title: Text('Camera'),
              leading: Icon(Icons.photo_camera, color: AppColors.defaultColor),
              onTap: () {
                _launchImageSelection(
                  source: image_picker_library.ImageSource.camera,
                  context: context,
                  onImageSelected: onImageSelected,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  static void _launchImageSelection({
    image_picker_library.ImageSource source,
    BuildContext context,
    ValueChanged<File> onImageSelected,
  }) async {
    image_picker_library.ImagePicker _picker = image_picker_library.ImagePicker();
    try {
      final pickedFile = await _picker.getImage(source: source);
      if (pickedFile != null) {
        var imageFile = File(pickedFile.path);
        onImageSelected(imageFile);
        Navigator.pop(context, imageFile);
      }
    } catch (e) {
      //ignore: usually, error is not thrown
    }
  }
}
