import 'package:flutter/material.dart';

import '../models/vehicle.dart';
import '../services/api_service.dart';
import 'rent_screen.dart';

// DUMMY DATA: to be replaced by ApiService.getVehicles() once the backend adds GET /api/vehicles
final List<Vehicle> sampleVehicles = [
  Vehicle(id: 1, make: 'Toyota', model: 'Corolla', year: 2022,
      registrationNumber: 'KPG 745 GP', dailyRate: 450, status: 'AVAILABLE'),
  Vehicle(id: 2, make: 'VW', model: 'Polo', year: 2021,
      registrationNumber: 'LFT 009 ZN', dailyRate: 380, status: 'RENTED'),
  Vehicle(id: 3, make: 'Ford', model: 'Ranger', year: 2023,
      registrationNumber: 'FRH 797 L', dailyRate: 720.50, status: 'AVAILABLE'),
];

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ApiService.clearSession();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: sampleVehicles.length,
        itemBuilder: (context, index) {
          final v = sampleVehicles[index];
          final isAvailable = v.status == 'AVAILABLE';
          return ListTile(
            title: Text('${v.make} ${v.model} ${v.year}'),
            subtitle: Text(
                'R${v.dailyRate.toStringAsFixed(2)} per day · ${v.registrationNumber}'),
            trailing: ElevatedButton(
              onPressed: isAvailable
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => RentScreen(vehicle: v),
                        ),
                      );
                    }
                  : null,
              child: Text(isAvailable ? 'Rent' : 'Rented'),
            ),
          );
        },
      ),
    );
  }
}
