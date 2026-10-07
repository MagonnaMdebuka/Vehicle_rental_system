import 'package:flutter/material.dart';
import 'package:vehicle_rental/screens/rent_screen.dart';

class Vehicle {
  final int id;
  final String make;
  final String model;
  final int year;
  final String registrationNumber;
  final double dailyRate;
  final String status;

  Vehicle({
    required this.id,
    required this.make,
    required this.model,
    required this.year,
    required this.registrationNumber,
    required this.dailyRate,
    required this.status,
  });

  bool get isAvailable => status == 'AVAILABLE';
}

// DUMMY DATA: to be replaced by the real API call later
final List<Vehicle> sampleVehicles = [
  Vehicle(id: 1, make: 'Toyota', model: 'Corolla', year: 2022,
      registrationNumber: 'KPG 745 GP', dailyRate: 450, status: 'AVAILABLE'),
  Vehicle(id: 2, make: 'VW', model: 'Polo', year: 2021,
      registrationNumber: 'LFT 009 ZN', dailyRate: 380, status: 'RENTED'),
  Vehicle(id: 3, make: 'Ford', model: 'Ranger', year: 2023,
      registrationNumber: 'FRH 797 L', dailyRate: 720.50, status: 'AVAILABLE'),
];


class VehiclesPage extends StatelessWidget{
  const VehiclesPage ({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vehicles'),),
      body: ListView.builder(
        itemCount: sampleVehicles.length,
        itemBuilder: (context, index) {
          final v = sampleVehicles[index];
          return ListTile(
            title: Text('${v.make} ${v.model} ${v.year}'),
            subtitle: Text('R${v.dailyRate.toStringAsFixed(2)} per day * ${v.registrationNumber}'),
            trailing: ElevatedButton(onPressed: v.isAvailable ? () {Navigator.push(context, MaterialPageRoute(builder: (context)=> RentScreen(vehicle: v)));}: null, child: Text(v.isAvailable ? 'Rent': 'Rented')),
          );
        }),
    );
  }
}