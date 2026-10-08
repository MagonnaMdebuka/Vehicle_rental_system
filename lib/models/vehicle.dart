class Vehicle {
  final int id;
  final String make;
  final String model;
  final int year;
  final String registrationNumber;
  final double dailyRate;
  final String status;

  const Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.dailyRate,
    required this.status,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as int,
      make: json['make'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      registrationNumber: json['registrationNumber'] as String,
      dailyRate: (json['dailyRate'] as num).toDouble(),
      status: json['status'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'make': make,
      'model': model,
      'year': year,
      'registrationNumber': registrationNumber,
      'dailyRate': dailyRate,
      'status': status,
    };
  }
}
