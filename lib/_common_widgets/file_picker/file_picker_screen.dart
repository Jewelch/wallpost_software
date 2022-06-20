import 'dart:io';
import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/file_picker/image_from_camera_pciker.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/extensions/file_extension.dart';
import '../screen_presenter/modal_sheet_presenter.dart';

enum FileTypes { images, videos, documents, audios, camera }

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
  final List<File> files = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.filesType.contains(FileTypes.camera))
            ListTile(
              title: Text("Camera"),
              onTap: () async {
                final cameras = await availableCameras();
                var imagePath = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ImageFromCameraPickerScreen(camera: cameras.first),
                  ),
                );
                if (imagePath != null) {
                  files.add(File(imagePath));
                }
                setState(() {});
              },
            ),
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
          if (files.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Wrap(
                children: [
                  Text("Selected File${widget.allowMultiple ? 's' : ''}:"),
                  ...files.map((file) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          file.name() + '  ',
                        ),
                      )),
                ],
              ),
            ),
          if (files.isNotEmpty)
            SizedBox(
              height: 32,
            ),
          if (files.isNotEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Center(
                child: RoundedIconButton(
                  width: 100,
                  backgroundColor: AppColors.greenButtonColor,
                  iconName: 'assets/icons/check_mark_icon.svg',
                  iconSize: 32,
                  onPressed: () => Navigator.of(context).pop(files),
                ),
              ),
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
