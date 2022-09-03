import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/input_validation_exception.dart';
import 'package:wallpost/leave/leave_create/entities/leave_request_form.dart';
import 'package:wallpost/leave/leave_create/entities/leave_type.dart';

class MockLeaveType extends Mock implements LeaveType {}

void main() {
  test("leave type validation fails when no leave type is selected", () {
    var form = LeaveRequestForm();

    var validationResult = form.validateLeaveType();

    expect(validationResult.isValid, false);
    expect(validationResult.validationErrorMessage, "Please select a leave type");
  });

  test("leave type validation passes when a leave type is selected", () {
    var form = LeaveRequestForm();
    form.leaveType = MockLeaveType();

    var validationResult = form.validateLeaveType();

    expect(validationResult.isValid, true);
  });

  test("start date validation fails when no start date is selected", () {
    var form = LeaveRequestForm();

    var validationResult = form.validateStartDate();

    expect(validationResult.isValid, false);
    expect(validationResult.validationErrorMessage, "Please select a start date");
  });

  test("start date validation passes when a start date is selected", () {
    var form = LeaveRequestForm();
    form.startDate = DateTime.now();

    var validationResult = form.validateStartDate();

    expect(validationResult.isValid, true);
  });

  test("end date validation fails when end date is null", () {
    var form = LeaveRequestForm();

    var validationResult = form.validateEndDate();

    expect(validationResult.isValid, false);
    expect(validationResult.validationErrorMessage, "Please select an end date");
  });

  test("end date validation fails when end date is before start date", () {
    var form = LeaveRequestForm();
    form.startDate = DateTime(2022, 8, 20);
    form.endDate = DateTime(2022, 8, 19);

    var validationResult = form.validateEndDate();

    expect(validationResult.isValid, false);
    expect(validationResult.validationErrorMessage, "End date cannot be before start date");
  });

  test(
      "end date validation fails when the difference between start date and end date"
      "is less that the selected leave type required minimum period", () {
    var form = LeaveRequestForm();
    var leaveType = MockLeaveType();
    when(() => leaveType.name).thenReturn("Leave Type 1");
    when(() => leaveType.requiredMinimumPeriod).thenReturn(5);
    form.leaveType = leaveType;
    form.startDate = DateTime(2022, 8, 20);
    form.endDate = DateTime(2022, 8, 23);

    var validationResult = form.validateEndDate();

    expect(validationResult.isValid, false);
    expect(validationResult.validationErrorMessage, "Required minimum period for Leave Type 1 is 5");
  });

  test(
      "end date validation passes when end date is after start date and"
      "the difference between start and end date is not less than required minimum period", () {
    var form = LeaveRequestForm();
    var leaveType = MockLeaveType();
    when(() => leaveType.name).thenReturn("Leave Type 1");
    when(() => leaveType.requiredMinimumPeriod).thenReturn(5);
    form.leaveType = leaveType;
    form.startDate = DateTime(2022, 8, 20);
    form.endDate = DateTime(2022, 8, 25);

    var validationResult = form.validateEndDate();

    expect(validationResult.isValid, true);
  });

  test("phone number validation fails when phone number is null", () {
    var form = LeaveRequestForm();

    var validationResult = form.validatePhoneNumber();

    expect(validationResult.isValid, false);
    expect(validationResult.validationErrorMessage, "Please enter a phone number");
  });

  test("phone number validation fails when phone number is empty", () {
    var form = LeaveRequestForm();
    form.phoneNumber = "";

    var validationResult = form.validatePhoneNumber();

    expect(validationResult.isValid, false);
    expect(validationResult.validationErrorMessage, "Please enter a phone number");
  });

  test("phone number validation passes when a phone number is entered", () {
    var form = LeaveRequestForm();
    form.phoneNumber = "111222333";
    var validationResult = form.validatePhoneNumber();

    expect(validationResult.isValid, true);
  });

  test("email validation fails when email is null", () {
    var form = LeaveRequestForm();

    var validationResult = form.validateEmail();

    expect(validationResult.isValid, false);
    expect(validationResult.validationErrorMessage, "Please enter an email");
  });

  test("email validation fails when email is invalid", () {
    var form = LeaveRequestForm();
    form.email = "wrong email";

    var validationResult = form.validateEmail();

    expect(validationResult.isValid, false);
    expect(validationResult.validationErrorMessage, "Please enter a valid email");
  });

  test("email validation passes when email is valid", () {
    var form = LeaveRequestForm();
    form.email = "someemail@email.com";

    var validationResult = form.validateEmail();

    expect(validationResult.isValid, true);
  });

  test("leave reason validation fails when leave reason is null", () {
    var form = LeaveRequestForm();

    var validationResult = form.validateLeaveReason();

    expect(validationResult.isValid, false);
    expect(validationResult.validationErrorMessage, "Please enter a reason");
  });

  test("leave reason validation fails when leave reason is empty", () {
    var form = LeaveRequestForm();
    form.leaveReason = "";

    var validationResult = form.validateLeaveReason();

    expect(validationResult.isValid, false);
    expect(validationResult.validationErrorMessage, "Please enter a reason");
  });

  test("leave reason validation passes when there is a leave reason", () {
    var form = LeaveRequestForm();
    form.leaveReason = "some reason";

    var validationResult = form.validateLeaveReason();

    expect(validationResult.isValid, true);
  });

  test(
      "file attachment validation fails when the selected leave type requires an attachment"
      "and no file is attached", () {
    var form = LeaveRequestForm();
    var leaveType = MockLeaveType();
    form.leaveType = leaveType;
    when(() => leaveType.requiresCertificate).thenReturn(true);

    var validationResult = form.validateFileAttachment();

    expect(validationResult.isValid, false);
    expect(validationResult.validationErrorMessage, "Please upload a supporting document");
  });

  test(
      "file attachment validation passes when the selected leave type requires an attachment"
      "and a file is attached", () {
    var form = LeaveRequestForm();
    var leaveType = MockLeaveType();
    when(() => leaveType.requiresCertificate).thenReturn(true);
    form.attachedFileName = "SomeFileName";

    var validationResult = form.validateFileAttachment();

    expect(validationResult.isValid, true);
  });

  test(
      "file attachment validation passes when the selected leave type does not"
      "require an attachment", () {
    var form = LeaveRequestForm();
    var leaveType = MockLeaveType();
    when(() => leaveType.requiresCertificate).thenReturn(false);

    var validationResult = form.validateFileAttachment();

    expect(validationResult.isValid, true);
  });

  test("file attachment validation passes when no leave type is selected", () {
    var form = LeaveRequestForm();

    var validationResult = form.validateFileAttachment();

    expect(validationResult.isValid, true);
  });

  test("converting to json throws InputValidationException when validation fails", () {
    var form = LeaveRequestForm();

    try {
      form.toJson();
      fail("expected to throw InputValidationException but did not");
    } catch (e) {
      expect(e is InputValidationException, true);
    }
  });

  test("successfully converting to json", () {
    var form = LeaveRequestForm();
    var leaveType = MockLeaveType();
    when(() => leaveType.id).thenReturn("id1");
    when(() => leaveType.name).thenReturn("Leave Type 1");
    when(() => leaveType.requiredMinimumPeriod).thenReturn(5);
    when(() => leaveType.requiresCertificate).thenReturn(true);
    form.leaveType = leaveType;
    form.startDate = DateTime(2022, 8, 20);
    form.endDate = DateTime(2022, 8, 25);
    form.phoneNumber = "111222333";
    form.email = "someemail@email.com";
    form.leaveReason = "some reason";
    form.attachedFileName = "someFileName.png";
    form.isExitRequired = true;
    form.isTicketRequired = true;

    expect(form.toJson(), {
      "leave_type_id": "id1",
      "leave_from": "2022-08-20",
      "leave_to": "2022-08-25",
      "leave_reason": "some reason",
      "contact_on_leave": "111222333",
      "contact_email": "someemail@email.com",
      "file_name": ["someFileName.png"],
      "exit_required": true,
      "ticket": "Yes",
    });
  });
}
