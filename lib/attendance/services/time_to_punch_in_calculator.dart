class TimeToPunchInCalculator {
  static String timeTillPunchIn(int durationInSeconds) {
    int aMinuteInSeconds = 60;
    int anHourInSeconds = 3600;
    int aDayInSeconds = 86400;

    int remainingDuration = durationInSeconds;

    int elapsedDays = remainingDuration ~/ aDayInSeconds;
    remainingDuration = remainingDuration % aDayInSeconds;

    int elapsedHours = remainingDuration ~/ anHourInSeconds;
    remainingDuration = remainingDuration % anHourInSeconds;

    int elapsedMinutes = remainingDuration ~/ aMinuteInSeconds;
    remainingDuration = remainingDuration % aMinuteInSeconds;

    int elapsedSeconds = remainingDuration;

    if (elapsedDays > 0) {
      return elapsedDays > 1 ? '$elapsedDays days' : '$elapsedDays day';
    } else {
      var hourPart = '';
      var minPart = '';
      var secPart = '';
      if (elapsedHours > 0) hourPart = '${elapsedHours}h ';
      if (elapsedMinutes > 0) minPart = '${elapsedMinutes}m ';
      if (elapsedSeconds >= 0) secPart = '${elapsedSeconds}s';

      return '$hourPart$minPart$secPart';
    }
  }
}
