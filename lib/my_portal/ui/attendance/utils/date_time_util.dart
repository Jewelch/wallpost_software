class DateTimeUtil {

 static String convertMilliSecondsToReadableTime( double duration) {

   double secondsInMilli = 1000;
   double minutesInMilli = secondsInMilli * 60;
   double hoursInMilli = minutesInMilli * 60;
   double daysInMilli = hoursInMilli * 24;

     int elapsedDays =( duration / daysInMilli).toInt();
     duration = duration % daysInMilli;


     int elapsedHours = (duration / hoursInMilli).toInt();
     duration = duration % hoursInMilli;


   int elapsedMinutes = (duration / minutesInMilli).toInt();
     duration = duration % minutesInMilli;


   int elapsedSeconds = (duration / secondsInMilli).toInt();



   String daysPart = "", hourPart = "", minPart = "", secPart = "";
     if (elapsedDays > 0)
        daysPart = elapsedDays > 1 ? elapsedDays.toString() + " days" : elapsedDays.toString() + "day";

     if (elapsedHours > 0)
        hourPart = elapsedHours.toString() + "h ";

     if (elapsedMinutes > 0)
        minPart = elapsedMinutes .toString()+ "m ";

     if (elapsedSeconds > 0)
        secPart = elapsedSeconds.toString() + "s";

     return daysPart.isEmpty ? hourPart + minPart + secPart : daysPart;


   }

}