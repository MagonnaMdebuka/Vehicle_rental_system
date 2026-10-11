import 'package:flutter/material.dart';

import '../models/vehicle.dart';
import '../services/api_service.dart';
import 'rent_screen.dart';

class VehiclesPage extends StatefulWidget {
  const VehiclesPage({super.key});

  @override
  State<VehiclesPage> createState() => _VehiclesPageState();
}

class _VehiclesPageState extends State<VehiclesPage> {
  List<Vehicle> _vehicles = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadVehicles();
  }

  Future<void> _loadVehicles() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await ApiService.getVehicles();
    if (!mounted) return;

    setState(() {
      _isLoading = false;
      if (result.success) {
        _vehicles = result.data!;
      } else {
        _errorMessage = result.error;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicles'),
        backgroundColor: Colors.blueAccent,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadVehicles,
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ApiService.clearSession();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _loadVehicles,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_vehicles.isEmpty) {
      return const Center(child: Text('No vehicles found.'));
    }

    return ListView.builder(
      itemCount: _vehicles.length,
      itemBuilder: (context, index) {
        final v = _vehicles[index];
        final isAvailable = v.status == 'AVAILABLE';
        return ListTile(
          title: Text('${v.make} ${v.model} ${v.year}'),
          subtitle: Text(
              'R${v.dailyRate.toStringAsFixed(2)} per day · ${v.registrationNumber}'),
          trailing: ElevatedButton(
            onPressed: isAvailable
                ? () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RentScreen(vehicle: v),
                      ),
                    );
                    _loadVehicles(); // refresh statuses after renting
                  }
                : null,
            child: Text(isAvailable ? 'Rent' : 'Rented'),
          ),
        );
      },
    );
  }
}