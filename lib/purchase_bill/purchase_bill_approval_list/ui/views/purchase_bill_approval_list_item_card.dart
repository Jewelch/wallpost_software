import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/ui/views/purchase_bill_approval_alert.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/ui/views/purchase_bill_rejection_alert.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/entities/purchase_bill_approval_list_item.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/ui/presenters/purchase_bill_approval_list_presenter.dart';
import '../../../../_common_widgets/buttons/rounded_action_button.dart';

class PurchaseBillApprovalListItemCard extends StatefulWidget {
  final PurchaseBillApprovalListPresenter listPresenter;
  final PurchaseBillApprovalListItem approval;

  PurchaseBillApprovalListItemCard({
    required this.listPresenter,
    required this.approval,
  });

  @override
  State<PurchaseBillApprovalListItemCard> createState() => _PurchaseBillApprovalListItemCardState();
}

class _PurchaseBillApprovalListItemCardState extends State<PurchaseBillApprovalListItemCard> {
  final _loadingNotifier = ItemNotifier<bool>(defaultValue: false);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: AppColors.listItemBorderColor),
      ),
      child: InkWell(
        onTap: () => widget.listPresenter.showDetail(widget.approval),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedCrossFade(
                alignment: Alignment.topRight,
                sizeCurve: Curves.easeIn,
                duration: const Duration(milliseconds: 200),
                firstChild: Container(
                  color: Colors.white,
                  child: Checkbox(
                    value: widget.listPresenter.isItemSelected(widget.approval),
                    onChanged: (_) {
                      widget.listPresenter.toggleSelection(widget.approval);
                      setState(() {});
                    },
                  ),
                ),
                secondChild: Container(),
                crossFadeState:
                    widget.listPresenter.isSelectionInProgress ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                             widget.listPresenter.getSupplierName(widget.approval)!,
                            style: TextStyles.titleTextStyleBold.copyWith(color: AppColors.textColorBlueGray),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(width: 16),
                        Wrap(
                          children: [
                            Text(
                              widget.listPresenter.getTotalAmount(widget.approval),
                              style: TextStyles.largeTitleTextStyleBold,
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 1),
                              child: Text(widget.listPresenter.getCurrency(widget.approval)!,
                                  style: TextStyles.smallLabelTextStyle.copyWith(color: AppColors.textColorBlueGray)),
                            ),
                            SizedBox(width: 8),
                            Icon(
                              Icons.arrow_forward,
                              color: AppColors.defaultColor,
                              size: 16,
                            )
                          ],
                        )
                        ,
                      ],
                    ),
                    SizedBox(height: 12),
                    _labelAndValue(
                      "Requested No - ",
                      widget.listPresenter.getBillNumber(widget.approval),
                    ),
                    SizedBox(height: 12),
                    _labelAndValue(
                      "Due on - ",
                      widget.listPresenter.getDueDate(widget.approval),
                    ),
                    if (!widget.listPresenter.isSelectionInProgress) SizedBox(height: 8),
                    if (!widget.listPresenter.isSelectionInProgress)
                      ItemNotifiable<bool>(
                        notifier: _loadingNotifier,
                        builder: (context, isLoading) {
                          return Row(
                            children: [
                              Expanded(
                                child: RoundedRectangleActionButton(
                                  title: "Approve",
                                  backgroundColor: AppColors.lightGreen,
                                  textColor: AppColors.green,
                                  height: 40,
                                  borderRadiusCircular: 14,
                                  onPressed: () => _approve(),
                                  showLoader: isLoading,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: RoundedRectangleActionButton(
                                  title: "Reject",
                                  backgroundColor: AppColors.lightRed,
                                  textColor: AppColors.red,
                                  height: 40,
                                  borderRadiusCircular: 14,
                                  onPressed: () => _reject(),
                                  disabled: isLoading ? true : false,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelAndValue(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyles.labelTextStyleBold.copyWith(color: AppColors.textColorBlueGrayLight),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: TextStyles.labelTextStyle.copyWith(
            color: AppColors.textColorBlack,
            overflow: TextOverflow.ellipsis,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  void _approve() async {
    var didApprove = await showDialog(
      context: context,
      builder: (_) => PurchaseBillApprovalAlert(
        billId: widget.approval.id,
        companyId:widget.approval.companyId,
          supplierName:widget.approval.supplierName!
      ),
    );
    if (didApprove)
      widget.listPresenter.onDidProcessApprovalOrRejection(
        didApprove,
        [widget.approval.id],
      );
  }

  void _reject() async {
    var didReject = await showDialog(
      context: context,
      builder: (_) => PurchaseBillRejectionAlert(
        billId: widget.approval.id,
        companyId:widget.approval.companyId,
        supplierName: widget.approval.supplierName!,
      ),
    );
    if (didReject)
      widget.listPresenter.onDidProcessApprovalOrRejection(
        didReject,
        [widget.approval.id],
      );
  }
}
