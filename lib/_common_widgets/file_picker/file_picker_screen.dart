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
            onTap: () {},
          ),
          ListTile(
            title: Text("Video"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Document"),
            onTap: () {},
          ),
          ListTile(
            title: Text("Audio"),
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
