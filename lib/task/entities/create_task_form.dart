import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/_shared/json_serialization_base/json_convertible.dart';
import 'package:wallpost/task/entities/task_employee.dart';

class CreateTaskForm implements JSONConvertible {
  final String name;
  final String description;
  final DateTime startDate;
  final DateTime startTime;
  final DateTime endDate;
  final DateTime endTime;
  final List<TaskEmployee> assignees;
  final List<String> attachedFileNames;
  final bool isAttachmentRequiredOnCompletion;
  final String timezone;

  CreateTaskForm({
    this.name,
    this.description,
    this.startDate,
    this.startTime,
    this.endDate,
    this.endTime,
    this.assignees,
    this.attachedFileNames,
    this.isAttachmentRequiredOnCompletion,
    this.timezone,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'start_date': startDate.yyyyMMddString(),
      'start_time': startTime.HHmmssString(),
      'end_date': endDate.yyyyMMddString(),
      'end_time': endTime.HHmmssString(),
      'assignees': _readAssigneesList(assignees),
      'filenames': attachedFileNames,
      'attachment_req': isAttachmentRequiredOnCompletion,
      'timezone': timezone,
      'status': 'new',
      'is_draft': false,
      'is_private': false,
      'no_time_conversion': false,
      'rrule': null,
    };
  }

  List<Map<String, dynamic>> _readAssigneesList(List<TaskEmployee> customList) {
    if (customList == null) {
      return [];
    }

    var maps = <Map<String, dynamic>>[];
    for (var item in customList) {
      maps.add({'employment_id': item.v2Id});
    }
    return maps;
  }
}
