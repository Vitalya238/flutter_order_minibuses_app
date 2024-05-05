import 'package:flutter/material.dart';

class FindMinibusScreen extends StatefulWidget{
  const FindMinibusScreen({super.key,});

  @override
  State<FindMinibusScreen> createState() => _FindMinibusScreenState();
}
class _FindMinibusScreenState extends State<FindMinibusScreen> {
  String? _dropdownValue = '1';
  TextEditingController _dateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30,vertical: 200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            TextFormField(
              decoration: const InputDecoration(
                  label: Text(
                    'Откуда',
                    style: TextStyle(fontSize: 18),
                  )
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                label: Text(
                  'Куда',
                  style: TextStyle(fontSize: 18, ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _dateController,
                    decoration: const InputDecoration(
                      labelText: 'Date',
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
                    DropdownMenuItem(value: '5', child: Text('5 пассажира')),
                  ],
                  onChanged: (String? newValue) {
                    setState(() {
                      _dropdownValue = newValue;
                    });
                  },
                ),
                const SizedBox(width: 0)
              ],
            ),

            ElevatedButton(
              onPressed: () {
                // Выполните необходимую логику при нажатии кнопки
              },
              child: const Text('Заказать'),
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
}