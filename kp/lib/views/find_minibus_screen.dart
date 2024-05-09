import 'package:flutter/material.dart';
import 'city_selection_screen.dart';
import 'found_minibuses_screen.dart';

class FindMinibusScreen extends StatefulWidget {
  const FindMinibusScreen({Key? key}) : super(key: key);

  @override
  State<FindMinibusScreen> createState() => _FindMinibusScreenState();
}

class _FindMinibusScreenState extends State<FindMinibusScreen> {
  String? _dropdownValue = '1';
  TextEditingController _dateController = TextEditingController();
  TextEditingController _fromController = TextEditingController();
  TextEditingController _toController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _fromController,
              onTap: () async {
                String? selectedCity = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CitySelectionScreen(title: 'Выберите город отправления'),
                  ),
                );
                if (selectedCity != null) {
                  setState(() {
                    _fromController.text = selectedCity;
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: 'Откуда',
                labelStyle: TextStyle(fontSize: 18),
              ),
            ),
            TextFormField(
              controller: _toController,
              onTap: () async {
                String? selectedCity = await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CitySelectionScreen(title: 'Выберите город назначения'),
                  ),
                );
                if (selectedCity != null) {
                  setState(() {
                    _toController.text = selectedCity;
                  });
                }
              },
              decoration: const InputDecoration(
                labelText: 'Куда',
                labelStyle: TextStyle(fontSize: 18),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Дата',
                      prefixIcon: Icon(Icons.calendar_today),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                    ),
                    readOnly: true,
                    onTap: () {
                      _selectDate();
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _dropdownValue,
                  items: const [
                    DropdownMenuItem(value: '1', child: Text('1 пассажир')),
                    DropdownMenuItem(value: '2', child: Text('2 пассажира')),
                    DropdownMenuItem(value: '3', child: Text('3 пассажира')),
                    DropdownMenuItem(value: '4', child: Text('4 пассажира')),
                    DropdownMenuItem(value: '5', child: Text('5 пассажиров')),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropdownValue = newValue;
                    });
                  },
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                _findMinibuses();
              },
              child: const Text('Find'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (_picked != null) {
      setState(() {
        _dateController.text = _picked.toString().split(" ")[0];
      });
    }
  }

  void _findMinibuses() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FoundMinibusesScreen(
          from: _fromController.text,
          to: _toController.text,
          date: _dateController.text,
          passengers: _dropdownValue!,
        ),
      ),
    );
  }
}
