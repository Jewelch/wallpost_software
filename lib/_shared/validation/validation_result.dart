class ValidationResult {
  final String fieldName;
  final bool isValid;
  final String? validationErrorMessage;

  ValidationResult.valid(this.fieldName)
      : isValid = true,
        validationErrorMessage = null;

  ValidationResult.invalid(this.fieldName, String errorMessage)
      : isValid = false,
        validationErrorMessage = errorMessage;
}
