import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';

import '../../../_shared/exceptions/input_validation_exception.dart';
import '../../../_shared/money/money.dart';
import '../../../_shared/validation/validation_result.dart';
import 'expense_category.dart';

class ExpenseRequestForm implements JSONConvertible {
  DateTime? date;
  ExpenseCategory? mainCategory;
  ExpenseCategory? subCategory;
  ExpenseCategory? project;
  Money? rate;
  int? quantity;
  String? description;
  String? attachedFileName;

  //MARK: Functions to validate input

  ValidationResult validateDate() {
    if (date == null) {
      return ValidationResult.invalid("Please select a date");
    }

    return ValidationResult.valid();
  }

  ValidationResult validateCategory() {
    if (mainCategory == null) {
      return ValidationResult.invalid("Please select a main category");
    }

    if (mainCategory!.projects.isNotEmpty && project == null) {
      return ValidationResult.invalid("Please select a project");
    }

    if (mainCategory!.subCategories.isNotEmpty && subCategory == null) {
      return ValidationResult.invalid("Please select a sub category");
    }

    return ValidationResult.valid();
  }

  ValidationResult validateRate() {
    if (rate == null) {
      return ValidationResult.invalid("Please set a rate");
    }

    if (rate == Money.zero()) {
      return ValidationResult.invalid("Rate cannot be zero");
    }

    return ValidationResult.valid();
  }

  ValidationResult validateQuantity() {
    if (quantity == null) {
      return ValidationResult.invalid("Please set a quantity");
    }

    if (quantity == 0) {
      return ValidationResult.invalid("Quantity cannot be zero");
    }

    return ValidationResult.valid();
  }

  ValidationResult _isFormInputValid() {
    if (!validateDate().isValid) return validateDate();
    if (!validateCategory().isValid) return validateCategory();
    if (!validateRate().isValid) return validateRate();
    if (!validateQuantity().isValid) return validateQuantity();

    return ValidationResult.valid();
  }

  //MARK: Function to convert to json

  @override
  Map<String, dynamic> toJson() {
    var validation = _isFormInputValid();
    if (!validation.isValid) throw InputValidationException(validation.validationErrorMessage!);

    return {
      "parentCategory": "${mainCategory!.id}",
      "category": subCategory != null ? "${subCategory!.id}" : null,
      "project": project != null ? "${project!.id}" : null,
      "expense_date": date!.yyyyMMddString(),
      "description": description,
      "quantity": "$quantity",
      "rate": "${rate.toString()}",
      "amount": "${rate!.multiply(quantity!).toString()}",
      "file": attachedFileName,
      "total": "${rate!.multiply(quantity!).toString()}",
    };
  }
}
