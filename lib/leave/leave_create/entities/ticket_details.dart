import 'package:sift/Sift.dart';

import '../../../_shared/exceptions/mapping_exception.dart';
import '../../../_shared/json_serialization_base/json_initializable.dart';
import 'leave_airport.dart';

class TicketDetails extends JSONInitializable {
  late final String airClassType;
  late final String wayType;
  late final int numberOfAdultTickets;
  late final int numberOfChildTickets;
  late final LeaveAirport? originAirport;
  late final LeaveAirport? destinationAirport;

  TicketDetails.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var ticketDetailsMap = sift.readMapFromMap(jsonMap, "ticketDetails");
      var airportDetailsMap = sift.readMapFromMapWithDefaultValue(jsonMap, "airportDetails");
      var originAirportMap = sift.readMapFromMapWithDefaultValue(airportDetailsMap, "origin_detail", null);
      var destinationAirportMap = sift.readMapFromMapWithDefaultValue(airportDetailsMap, "destination_detail", null);
      airClassType = sift.readStringFromMap(ticketDetailsMap, "air_class_type");
      wayType = sift.readStringFromMap(ticketDetailsMap, "way_type");
      numberOfAdultTickets = sift.readNumberFromMap(ticketDetailsMap, "no_ticket_adult").toInt();
      numberOfChildTickets = sift.readNumberFromMap(ticketDetailsMap, "no_ticket_children").toInt();
      if (originAirportMap != null) originAirport = LeaveAirport.fromJson(originAirportMap);
      if (destinationAirportMap != null) destinationAirport = LeaveAirport.fromJson(destinationAirportMap);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast TicketDetails response. Error message - ${e.errorMessage}');
    }
  }
}
