import 'package:flutter/material.dart';
import 'package:open_filex/open_filex.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';

import '../../../../_shared/constants/app_colors.dart';
import '../../_wp_core/wpapi/services/wp_file_downloader.dart';

class FileDownloadScreen extends StatefulWidget {
  final String url;
  final ModalSheetController modalSheetController;

  FileDownloadScreen._({
    required this.url,
    required this.modalSheetController,
  });

  static Future<dynamic> show({
    required BuildContext context,
    required String url,
  }) {
    var modalSheetController = ModalSheetController();
    return ModalSheetPresenter.present(
      context: context,
      content: FileDownloadScreen._(
        url: url,
        modalSheetController: modalSheetController,
      ),
      controller: modalSheetController,
      shouldDismissOnTap: true,
    );
  }

  @override
  State<FileDownloadScreen> createState() => _FileDownloadScreenState();
}

class _FileDownloadScreenState extends State<FileDownloadScreen> {
  int progress = 0;
  bool didCompleteDownload = false;
  String? _errorMessage;

  @override
  void initState() {
    _initiateDownload();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(_getTitle(), style: TextStyles.extraLargeTitleTextStyleBold),
          SizedBox(height: 60),
          Container(
            height: 60,
            margin: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12.0),
              border: Border.all(color: AppColors.listItemBorderColor),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  offset: Offset(0, 0),
                  blurRadius: 10,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Material(
                color: Colors.white,
                child: InkWell(
                  onTap: () => widget.modalSheetController.close(),
                  child: Container(
                      color: Colors.transparent,
                      child: Center(
                        child: Text(
                          "Close",
                          style: TextStyles.titleTextStyleBold,
                        ),
                      )),
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  String _getTitle() {
    if (_errorMessage != null) return _errorMessage!;

    return !didCompleteDownload ? "Downloading File $progress%" : "Download Complete";
  }

  Future<void> _initiateDownload() async {
    try {
      var file = await WPFileDownloader().download(widget.url, onDownloadProgress: (progress) {
        if (mounted) setState(() => this.progress = progress.toInt());
      });
      if (mounted) {
        setState(() {});
        OpenFilex.open(file.path);
        widget.modalSheetController.close();
      }
    } on WPException catch (e) {
      if (mounted) {
        setState(() => _errorMessage = e.userReadableMessage);
      }
    }
  }
}
