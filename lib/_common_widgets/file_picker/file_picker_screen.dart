import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../screen_presenter/modal_sheet_presenter.dart';

class FilePickerScreen extends StatelessWidget {
  static Future<dynamic> present(BuildContext context) {
    return ModalSheetPresenter.present(
      context: context,
      title: "Pick File",
      content: FilePickerScreen(),
      controller: ModalSheetController(),
    );
  }

  const FilePickerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          ListTile(
            title: Text("Image"),
            onTap: () async {
              var images = await _pickFiles(FileType.image);
            },
          ),
          ListTile(
            title: Text("Video"),
            onTap: () async {
              var videos = await _pickFiles(FileType.video);
            },
          ),
          ListTile(
            title: Text("Document"),
            onTap: () async {
              var document = await _pickFiles(FileType.custom, allowedExtensions: ['pdf', 'doc']);
            },
          ),
          ListTile(
            title: Text("Audio"),
            onTap: () async {
              var audios = await _pickFiles(FileType.audio);
            },
          ),
        ],
      ),
    );
  }

  Future<List<File>?> _pickFiles(FileType filesType, {List<String>? allowedExtensions}) async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(allowMultiple: true, type: filesType, allowedExtensions: allowedExtensions);
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        return files;
      }
    } catch (e) {
      //ignore: usually, error is not thrown
    }
  }
}
