import 'package:flutter/material.dart';
import 'package:vehicle_rental/screens/vehicles_page.dart'; 

class RentScreen extends StatefulWidget {
  final Vehicle vehicle;
  const RentScreen({super.key, required this.vehicle});
  @override
  State<RentScreen> createState() => _RentScreenState();
}

class _RentScreenState extends State<RentScreen> {
  DateTimeRange? chosenRange;

  Future<void> chooseDates() async {
    final now = DateTime.now();
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year, now.month, now.day),
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => chosenRange = picked);
  }

  int get days {
    final range = chosenRange!;
    final d = range.end.difference(range.start).inDays;
    return d < 1 ? 1 : d; // same-day pick counts as 1 day for now
  }

  // API wants YYYY-MM-DD
  String fmt(DateTime d) => d.toIso8601String().substring(0, 10);

  void confirm() {
    final range = chosenRange!;
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rental requested')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final v = widget.vehicle;
    final range = chosenRange;
    return Scaffold(
      appBar: AppBar(title: Text('Rent ${v.make} ${v.model}')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${v.make} ${v.model} (${v.year})',
                style: Theme.of(context).textTheme.headlineSmall),
            Text('R${v.dailyRate.toStringAsFixed(2)} per day'),
            const SizedBox(height: 24),
            OutlinedButton.icon(
              onPressed: chooseDates,
              icon: const Icon(Icons.date_range),
              label: Text(range == null
                  ? 'Choose dates'
                  : '${fmt(range.start)} to ${fmt(range.end)}'),
            ),
            const SizedBox(height: 16),
            if (range != null)
              Text('$days day(s) · estimated total '
                  'R${(days * v.dailyRate).toStringAsFixed(2)}'),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: range == null ? null : confirm,
                child: const Text('Confirm rental'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}