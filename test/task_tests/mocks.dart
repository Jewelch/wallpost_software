import 'package:random_string/random_string.dart';

class Mocks {
  static Map<String, dynamic> taskCountResponse = {
    "all": randomBetween(1000, 5000),
    "approvals": randomBetween(1000, 5000),
    "awaiting_deadline": randomBetween(1000, 5000),
    "cancelled": randomBetween(1000, 5000),
    "completed": randomBetween(1000, 5000),
    "default": randomBetween(1000, 5000),
    "draft": randomBetween(1000, 5000),
    "due_cancelled": randomBetween(1000, 5000),
    "due_completed": randomBetween(1000, 5000),
    "due_in_week": randomBetween(1000, 5000),
    "due_onhold": randomBetween(1000, 5000),
    "due_today": randomBetween(1000, 5000),
    "escalated": randomBetween(1000, 5000),
    "inprogress": randomBetween(1000, 5000),
    "new": randomBetween(1000, 5000),
    "onhold": randomBetween(1000, 5000),
    "overdue": randomBetween(1000, 5000),
    "pending": randomBetween(1000, 5000),
    "private": randomBetween(1000, 5000),
    "rejected": randomBetween(1000, 5000),
    "repeating": randomBetween(1000, 5000),
    "up_comming_dues": randomBetween(1000, 5000),
  };
}
