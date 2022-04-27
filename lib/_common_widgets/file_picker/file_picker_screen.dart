import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_shared/extensions/file_extension.dart';
import '../screen_presenter/modal_sheet_presenter.dart';

enum FileTypes { images, videos, documents, audios }

class FilePickerScreen extends StatefulWidget {
  final bool allowMultiple;
  final List<FileTypes> filesType;

  static Future<dynamic> present(BuildContext context,
      {bool allowMultiple = false, List<FileTypes> filesType = FileTypes.values}) {
    return ModalSheetPresenter.present(
      context: context,
      title: "Pick File",
      content: FilePickerScreen(
        allowMultiple: allowMultiple,
        filesType: filesType,
      ),
      controller: ModalSheetController(),
    );
  }

  const FilePickerScreen({Key? key, required this.allowMultiple, required this.filesType})
      : super(key: key);

  @override
  State<FilePickerScreen> createState() => _FilePickerScreenState();
}

class _FilePickerScreenState extends State<FilePickerScreen> {
  final List<File> files =  [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.filesType.contains(FileTypes.images))
            ListTile(
              title: Text("Image"),
              onTap: () async {
                var images = await _pickFiles(FileType.image);
                _addFiles(images);
              },
            ),
          if (widget.filesType.contains(FileTypes.videos))
            ListTile(
              title: Text("Video"),
              onTap: () async {
                var videos = await _pickFiles(FileType.video);
                _addFiles(videos);
              },
            ),
          if (widget.filesType.contains(FileTypes.documents))
            ListTile(
              title: Text("Document"),
              onTap: () async {
                var document = await _pickFiles(FileType.custom, allowedExtensions: ['pdf', 'doc']);
                _addFiles(document);
              },
            ),
          if (widget.filesType.contains(FileTypes.audios))
            ListTile(
              title: Text("Audio"),
              onTap: () async {
                var audios = await _pickFiles(FileType.audio);
                _addFiles(audios);
              },
            ),
          if(files.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text("Selected Files:"),
            ),
          ...files.map((file) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(file.name(),),
          )),
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
          allowMultiple: widget.allowMultiple,
          type: filesType,
          allowedExtensions: allowedExtensions);
      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        return files;
      }
    } catch (e) {
      //ignore: usually, error is not thrown
    }
    return null;
  }

  void _addFiles(List<File>? newFiles) {
    if (newFiles == null) return;
    if (widget.allowMultiple) files.addAll(newFiles);
    if (!widget.allowMultiple) {
      files.clear();
      files.addAll(newFiles);
    }
    setState(() {});
  }
}
