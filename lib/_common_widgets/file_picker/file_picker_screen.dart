import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import '../screen_presenter/modal_sheet_presenter.dart';

enum FileTypes { images, videos, documents, audios }

class FilePickerScreen extends StatelessWidget {
  final bool allowMultiple;
  final List<File> files = const [];
  final List<FileTypes> filesType;

  static Future<dynamic> present(BuildContext context) {
    return ModalSheetPresenter.present(
      context: context,
      title: "Pick File",
      content: FilePickerScreen(),
      controller: ModalSheetController(),
    );
  }

  const FilePickerScreen({Key? key, this.allowMultiple = false, this.filesType = FileTypes.values})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          if (filesType.contains(FileTypes.images))
            ListTile(
              title: Text("Image"),
              onTap: () async {
                var images = await _pickFiles(FileType.image);
                _addFiles(images);
              },
            ),
          if (filesType.contains(FileTypes.videos))
            ListTile(
              title: Text("Video"),
              onTap: () async {
                var videos = await _pickFiles(FileType.video);
                _addFiles(videos);
              },
            ),
          if (filesType.contains(FileTypes.documents))
            ListTile(
              title: Text("Document"),
              onTap: () async {
                var document = await _pickFiles(FileType.custom, allowedExtensions: ['pdf', 'doc']);
                _addFiles(document);
              },
            ),
          if (filesType.contains(FileTypes.audios))
            ListTile(
              title: Text("Audio"),
              onTap: () async {
                var audios = await _pickFiles(FileType.audio);
                _addFiles(audios);
              },
            ),

          ListTile(
            title: Text("finish"),
            onTap: () => Navigator.of(context).pop(files),
          ),
        ],
      ),
    );
  }

  Future<List<File>?> _pickFiles(FileType filesType, {List<String>? allowedExtensions}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
          allowMultiple: allowMultiple, type: filesType, allowedExtensions: allowedExtensions);
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        return files;
      }
    } catch (e) {
      //ignore: usually, error is not thrown
    }
  }

  void _addFiles(List<File>? files) {
    if (files == null) return;
    if (allowMultiple) files.addAll(files);
    if (!allowMultiple) {
      files.clear();
      files.addAll(files);
    }
  }
}
