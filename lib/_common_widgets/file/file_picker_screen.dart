import 'dart:io';

import 'package:camera/camera.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../screen_presenter/modal_sheet_presenter.dart';
import 'image_from_camera_picker.dart';

enum FileTypes { images, videos, documents, audios, camera }

class FilePickerScreen extends StatefulWidget {
  final bool allowMultiple;
  final List<FileTypes> filesType;
  final ModalSheetController modalSheetController;

  FilePickerScreen._({
    required this.allowMultiple,
    required this.filesType,
    required this.modalSheetController,
  });

  static Future<dynamic> show(
    BuildContext context, {
    bool allowMultiple = false,
    List<FileTypes> filesType = FileTypes.values,
  }) {
    var modalSheetController = ModalSheetController();
    return ModalSheetPresenter.present(
      context: context,
      content: FilePickerScreen._(
        allowMultiple: allowMultiple,
        filesType: filesType,
        modalSheetController: modalSheetController,
      ),
      controller: modalSheetController,
    );
  }

  @override
  State<FilePickerScreen> createState() => _FilePickerScreenState();
}

class _FilePickerScreenState extends State<FilePickerScreen> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.filesType.contains(FileTypes.camera))
          ListTile(
            title: Row(
              children: [
                Icon(Icons.camera_alt_outlined, color: AppColors.textColorBlack),
                SizedBox(width: 12),
                Text("Camera", style: TextStyles.titleTextStyle),
              ],
            ),
            onTap: () async {
              final cameras = await availableCameras();
              var imagePath = await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => ImageFromCameraPickerScreen(camera: cameras.first),
                ),
              );
              if (imagePath != null) _didSelectFiles([File(imagePath)]);
            },
          ),
        if (widget.filesType.contains(FileTypes.images))
          ListTile(
            title: Row(
              children: [
                Icon(Icons.image_outlined, color: AppColors.textColorBlack),
                SizedBox(width: 12),
                Text("Image", style: TextStyles.titleTextStyle),
              ],
            ),
            onTap: () => _pickFiles(FileType.image),
          ),
        if (widget.filesType.contains(FileTypes.videos))
          ListTile(
            title: Row(
              children: [
                Icon(Icons.video_camera_back_outlined, color: AppColors.textColorBlack),
                SizedBox(width: 12),
                Text("Video", style: TextStyles.titleTextStyle),
              ],
            ),
            onTap: () => _pickFiles(FileType.video),
          ),
        if (widget.filesType.contains(FileTypes.documents))
          ListTile(
            title: Row(
              children: [
                Icon(Icons.insert_drive_file_outlined, color: AppColors.textColorBlack),
                SizedBox(width: 12),
                Text("Document", style: TextStyles.titleTextStyle),
              ],
            ),
            onTap: () => _pickFiles(FileType.custom, allowedExtensions: [
              'pdf',
              'doc',
              'docx',
              'xls',
              'xlsx',
              'txt',
            ]),
          ),
        if (widget.filesType.contains(FileTypes.audios))
          ListTile(
            title: Row(
              children: [
                Icon(Icons.audio_file_outlined, color: AppColors.textColorBlack),
                SizedBox(width: 12),
                Text("Audio", style: TextStyles.titleTextStyle),
              ],
            ),
            onTap: () => _pickFiles(FileType.audio),
          ),
        SizedBox(height: 70),
      ],
    );
  }

  Future<List<File>?> _pickFiles(FileType filesType, {List<String>? allowedExtensions}) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: widget.allowMultiple,
        type: filesType,
        allowedExtensions: allowedExtensions,
      );

      if (result != null) {
        List<File> files = result.paths.map((path) => File(path!)).toList();
        _didSelectFiles(files);
      }
    } catch (e) {
      //ignore: usually, error is not thrown
    }
    return null;
  }

  void _didSelectFiles(List<File>? selectedFiles) {
    if (selectedFiles == null) return;
    widget.modalSheetController.close(result: selectedFiles);
  }
}
