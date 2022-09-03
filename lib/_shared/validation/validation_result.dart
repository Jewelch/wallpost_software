class ValidationResult {
  final bool isValid;
  final String? validationErrorMessage;

  ValidationResult.valid()
      : isValid = true,
        validationErrorMessage = null;

  ValidationResult.invalid(String errorMessage)
      : isValid = false,
        validationErrorMessage = errorMessage;
}
