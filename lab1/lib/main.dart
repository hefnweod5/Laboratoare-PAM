// Laborator 1 - Varianta 1: Calculator de reducere
// Autor: Enachi Lucian
// Input: pret initial, procentul reducerii - doua TextField
// UI controls: DropdownButton (reduceri predefinite), ElevatedButton, OutlinedButton (reset)
// Output: valoarea reducerii si pretul final afisate in Text
import 'package:flutter/material.dart';

void main() => runApp(const DiscountApp());

class DiscountApp extends StatelessWidget {
  const DiscountApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator de reducere',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.indigo, useMaterial3: true),
      home: const DiscountPage(),
    );
  }
}

class DiscountPage extends StatefulWidget {
  const DiscountPage({super.key});

  @override
  State<DiscountPage> createState() => _DiscountPageState();
}

class _DiscountPageState extends State<DiscountPage> {
  static const List<int> _presets = [5, 10, 15, 20, 30, 50];

  final _priceController = TextEditingController();
  final _percentController = TextEditingController();

  int? _selectedPreset;
  double? _discount;
  double? _finalPrice;
  String? _error;

  @override
  void dispose() {
    _priceController.dispose();
    _percentController.dispose();
    super.dispose();
  }

  void _onPresetChanged(int? value) {
    setState(() {
      _selectedPreset = value;
      if (value != null) {
        _percentController.text = value.toString();
      }
    });
  }

  void _calculate() {
    final price =
    double.tryParse(_priceController.text.replaceAll(',', '.'));
    final percent =
    double.tryParse(_percentController.text.replaceAll(',', '.'));

    setState(() {
      if (price == null || price < 0) {
        _error = 'Introdu un preț inițial valid.';
        _discount = null;
        _finalPrice = null;
      } else if (percent == null || percent < 0 || percent > 100) {
        _error = 'Procentul trebuie să fie între 0 și 100.';
        _discount = null;
        _finalPrice = null;
      } else {
        _error = null;
        _discount = price * percent / 100;
        _finalPrice = price - _discount!;
      }
    });
  }

  void _reset() {
    _priceController.clear();
    _percentController.clear();
    setState(() {
      _selectedPreset = null;
      _discount = null;
      _finalPrice = null;
      _error = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator de reducere'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextField(
                      controller: _priceController,
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Preț inițial',
                        suffixText: 'lei',
                        prefixIcon: Icon(Icons.sell),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _percentController,
                      keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                      decoration: const InputDecoration(
                        labelText: 'Procentul reducerii',
                        suffixText: '%',
                        prefixIcon: Icon(Icons.percent),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<int>(
                      initialValue: _selectedPreset,
                      decoration: const InputDecoration(
                        labelText: 'Reduceri predefinite',
                        prefixIcon: Icon(Icons.local_offer),
                        border: OutlineInputBorder(),
                      ),
                      hint: const Text('Alege o reducere'),
                      items: _presets
                          .map((p) =>
                          DropdownMenuItem(value: p, child: Text('$p %')))
                          .toList(),
                      onChanged: _onPresetChanged,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _calculate,
                      icon: const Icon(Icons.calculate),
                      label: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12),
                        child: Text('Calculează'),
                      ),
                    ),
                    const SizedBox(height: 8),
                    OutlinedButton(
                      onPressed: _reset,
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Text('Resetează'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            if (_error != null)
              Text(
                _error!,
                textAlign: TextAlign.center,
                style: TextStyle(color: theme.colorScheme.error, fontSize: 16),
              ),
            if (_finalPrice != null)
              Card(
                color: theme.colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        'Valoarea reducerii: ${_discount!.toStringAsFixed(2)} lei',
                        style: theme.textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      const Text('Prețul final', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 4),
                      Text(
                        '${_finalPrice!.toStringAsFixed(2)} lei',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
 