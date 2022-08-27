import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

import '../../../_common_widgets/buttons/capsule_action_button.dart';
import '../../../_common_widgets/form_widgets/form_text_field.dart';
import '../../../_shared/constants/app_colors.dart';
import '../presenters/expense_approval_presenter.dart';

class ExpenseApprovalRejectionView extends StatelessWidget {
  final String id;
  final String companyId;
  final String requestedBy;
  final ExpenseApprovalPresenter approvalPresenter;
  final ModalSheetController modalSheetController;
  final _reasonTextController = TextEditingController();
  final _reasonErrorNotifier = ItemNotifier<String?>(defaultValue: null);
  final _loadingNotifier = ItemNotifier<bool>(defaultValue: false);

  ExpenseApprovalRejectionView({
    required this.id,
    required this.companyId,
    required this.requestedBy,
    required this.approvalPresenter,
    required this.modalSheetController,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: ItemNotifiable<bool>(
        notifier: _loadingNotifier,
        builder: (context, isLoading) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Are you sure?", style: TextStyles.extraLargeTitleTextStyleBold),
              SizedBox(height: 16),
              Text("You want to reject $requestedBy's expense request?", style: TextStyles.titleTextStyleBold),
              SizedBox(height: 16),
              ItemNotifiable<String?>(
                notifier: _reasonErrorNotifier,
                builder: (context, errorText) {
                  return FormTextField(
                    hint: 'Write your reason here',
                    controller: _reasonTextController,
                    autoFocus: true,
                    errorText: errorText,
                    minLines: 3,
                    maxLines: 8,
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.done,
                    isEnabled: isLoading ? false : true,
                  );
                },
              ),
              SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: CapsuleActionButton(
                      title: "Submit",
                      color: AppColors.green,
                      onPressed: () => _reject(),
                      showLoader: isLoading,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: CapsuleActionButton(
                      title: "Cancel",
                      color: AppColors.red,
                      onPressed: () => modalSheetController.close(),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  void _reject() async {
    if (_reasonTextController.text.isEmpty) {
      _reasonErrorNotifier.notify("Please enter a reason");
      return;
    } else {
      _reasonErrorNotifier.notify(null);
    }

    _loadingNotifier.notify(true);
    var didReject = await approvalPresenter.reject(companyId, id, _reasonTextController.text);
    _loadingNotifier.notify(false);
    if (didReject) modalSheetController.close(result: true);
  }
}
