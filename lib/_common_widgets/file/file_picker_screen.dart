import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../screen_presenter/modal_sheet_presenter.dart';

enum PickerFileType { image, video, document, audio, camera }

class FilePickerScreen extends StatefulWidget {
  final bool allowMultiple;
  final List<PickerFileType> fileTypes;
  final ModalSheetController modalSheetController;

  FilePickerScreen._({
    required this.allowMultiple,
    required this.fileTypes,
    required this.modalSheetController,
  });

  static Future<dynamic> show(
    BuildContext context, {
    bool allowMultiple = false,
    List<PickerFileType> fileTypes = PickerFileType.values,
  }) {
    var modalSheetController = ModalSheetController();
    return ModalSheetPresenter.present(
      context: context,
      content: FilePickerScreen._(
        allowMultiple: allowMultiple,
        fileTypes: fileTypes,
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
        if (widget.fileTypes.contains(PickerFileType.camera))
          ListTile(
            title: Row(
              children: [
                Icon(Icons.camera_alt_outlined, color: AppColors.textColorBlack),
                SizedBox(width: 12),
                Text("Camera", style: TextStyles.titleTextStyle),
              ],
            ),
            onTap: () async {
              final XFile? photo = await ImagePicker().pickImage(
                source: ImageSource.camera,
                maxWidth: 800,
                maxHeight: 800,
              );
              if (photo != null) _didSelectFiles([File(photo.path)]);
            },
          ),
        if (widget.fileTypes.contains(PickerFileType.image))
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
        if (widget.fileTypes.contains(PickerFileType.video))
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
        if (widget.fileTypes.contains(PickerFileType.document))
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
        if (widget.fileTypes.contains(PickerFileType.audio))
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
