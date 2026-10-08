class Rental {
  final int id;
  final int userId;
  final int vehicleId;
  final String startDate;
  final String endDate;
  final double totalCost;
  final String status;

  const Rental({
    required this.id,
    required this.userId,
    required this.vehicleId,
    required this.startDate,
    required this.endDate,
    required this.totalCost,
    required this.status,
  });

  factory Rental.fromJson(Map<String, dynamic> json) {
    return Rental(
      id: json['id'] as int,
      userId: json['userId'] as int,
      vehicleId: json['vehicleId'] as int,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      totalCost: (json['totalCost'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'vehicleId': vehicleId,
      'startDate': startDate,
      'endDate': endDate,
      'totalCost': totalCost,
      'status': status,
    };
  }
}
