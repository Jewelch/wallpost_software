class HourlySalesItem {
  final String hour;
  final String ticketsCount;
  final String ticketsRevenue;

  const HourlySalesItem._({
    required this.hour,
    required this.ticketsCount,
    required this.ticketsRevenue,
  });

  factory HourlySalesItem.fromJson(Map<String, dynamic> json) => HourlySalesItem._(
        hour: json["hour"],
        ticketsCount: json["tickets"].toString(),
        ticketsRevenue: (json["ticket_total"] ?? 0).toString(),
      );
}
