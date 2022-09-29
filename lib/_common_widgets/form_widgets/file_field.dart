import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';

import '../../_shared/constants/app_colors.dart';
import '../file/file_picker_screen.dart';
import '../keyboard_dismisser/keyboard_dismisser.dart';
import '../text_styles/text_styles.dart';

class FileField extends StatelessWidget {
  final String? hint;
  final File? selectedFile;
  final Function(File) onFileSelected;
  final VoidCallback onRemoveButtonPress;
  final String? errorText;

  FileField({
    this.hint,
    this.selectedFile,
    required this.onFileSelected,
    required this.onRemoveButtonPress,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GestureDetector(
          onTap: () async {
            KeyboardDismisser.dismissKeyboard();
            var files = await FilePickerScreen.show(context, fileTypes: [
              PickerFileType.image,
              PickerFileType.camera,
              PickerFileType.document,
            ]);
            if (files != null && files is List && files.isNotEmpty) onFileSelected(files[0]);
          },
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: AppColors.textFieldBackgroundColor,
              borderRadius: BorderRadius.circular(8),
            ),
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                Expanded(
                    child: Text(
                  _getTitle(),
                  style: TextStyles.titleTextStyle,
                  overflow: TextOverflow.ellipsis,
                )),
                _icon(),
              ],
            ),
          ),
        ),
        SizedBox(height: 4),
        if (errorText != null && errorText!.isNotEmpty)
          Text("    ${errorText!}", style: TextStyle(fontSize: 14, color: AppColors.red))
      ],
    );
  }

  String _getTitle() {
    if (selectedFile != null) return basename(selectedFile!.path);
    if (hint != null) return hint!;
    return "";
  }

  Widget _icon() {
    if (selectedFile == null) {
      return Container(
        height: 50,
        width: 40,
        child: Center(
          child: Icon(Icons.attachment, color: AppColors.textColorGray),
        ),
      );
    } else {
      return GestureDetector(
        onTap: onRemoveButtonPress,
        child: Container(
          height: 50,
          width: 40,
          child: Center(
            child: Icon(Icons.delete_outline, color: AppColors.textColorGray),
          ),
        ),
      );
    }
  }
}
