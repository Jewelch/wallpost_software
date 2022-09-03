import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/_shared/validation/email_validation.dart';
import 'package:wallpost/_shared/validation/validation_result.dart';

import '../../../_shared/exceptions/input_validation_exception.dart';
import '../../leave_create/entities/leave_type.dart';

class LeaveRequestForm implements JSONConvertible {
  LeaveType? leaveType;
  DateTime? startDate;
  DateTime? endDate;
  String? phoneNumber;
  String? email;
  String? leaveReason;
  String? attachedFileName;
  bool isExitRequired = false;
  bool isTicketRequired = false;

  //MARK: Functions to validate input

  ValidationResult validateLeaveType() {
    if (leaveType == null) {
      return ValidationResult.invalid("Please select a leave type");
    }

    return ValidationResult.valid();
  }

  ValidationResult validateStartDate() {
    if (startDate == null) {
      return ValidationResult.invalid("Please select a start date");
    }

    return ValidationResult.valid();
  }

  ValidationResult validateEndDate() {
    if (endDate == null) {
      return ValidationResult.invalid("Please select an end date");
    }

    if (startDate != null && startDate!.isDateAfter(endDate!)) {
      return ValidationResult.invalid("End date cannot be before start date");
    }

    if (leaveType != null && leaveType!.requiredMinimumPeriod > 0) {
      var daysBetweenStartAndEndDate = startDate!.daysBetween(endDate!);
      if (daysBetweenStartAndEndDate < leaveType!.requiredMinimumPeriod) {
        return ValidationResult.invalid(
            "Required minimum period for ${leaveType!.name} is ${leaveType!.requiredMinimumPeriod}");
      }
    }

    return ValidationResult.valid();
  }

  ValidationResult validatePhoneNumber() {
    if (phoneNumber == null || phoneNumber!.isEmpty) {
      return ValidationResult.invalid("Please enter a phone number");
    }

    return ValidationResult.valid();
  }

  ValidationResult validateEmail() {
    if (email == null || email!.isEmpty) {
      return ValidationResult.invalid("Please enter an email");
    }

    if (!EmailValidator.isEmailValid(email!)) {
      return ValidationResult.invalid("Please enter a valid email");
    }

    return ValidationResult.valid();
  }

  ValidationResult validateLeaveReason() {
    if (leaveReason == null || leaveReason!.isEmpty) {
      return ValidationResult.invalid("Please enter a reason");
    }

    return ValidationResult.valid();
  }

  ValidationResult validateFileAttachment() {
    if (leaveType != null && leaveType!.requiresCertificate && attachedFileName == null) {
      return ValidationResult.invalid("Please upload a supporting document");
    }

    return ValidationResult.valid();
  }

  ValidationResult _isFormInputValid() {
    if (!validateLeaveType().isValid) return validateLeaveType();
    if (!validateStartDate().isValid) return validateStartDate();
    if (!validateEndDate().isValid) return validateEndDate();
    if (!validatePhoneNumber().isValid) return validatePhoneNumber();
    if (!validatePhoneNumber().isValid) return validatePhoneNumber();
    if (!validateLeaveReason().isValid) return validateLeaveReason();
    if (!validateFileAttachment().isValid) return validateFileAttachment();

    return ValidationResult.valid();
  }

  //MARK: Function to convert to json

  @override
  Map<String, dynamic> toJson() {
    var validation = _isFormInputValid();
    if (!validation.isValid) throw InputValidationException(validation.validationErrorMessage!);

    return {
      "leave_type_id": leaveType!.id,
      "leave_from": startDate!.yyyyMMddString(),
      "leave_to": endDate!.yyyyMMddString(),
      "leave_reason": leaveReason,
      "contact_on_leave": phoneNumber,
      "contact_email": email,
      "file_name": [attachedFileName],
      "exit_required": isExitRequired,
      "ticket": isTicketRequired ? "Yes" : "No",
    };
  }
}
