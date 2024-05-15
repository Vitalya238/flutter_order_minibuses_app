

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:kp/services/application_handler.dart';
import 'package:kp/services/auth_notifier.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:provider/provider.dart';

import '../models/Application.dart';

class BecomeADriverForm extends StatefulWidget {
  @override
  _BecomeADriverFormState createState() => _BecomeADriverFormState();
}

class _BecomeADriverFormState extends State<BecomeADriverForm> {
  final _formKey = GlobalKey<FormState>();
  late int _experience;
  late Uint8List _licensePhoto = Uint8List(0);


  late int currentUserId;
  @override
  void initState() {
    super.initState();
    currentUserId = Provider.of<AuthNotifier>(context, listen: false).currentUser.userId;
  }

  Future<void> _getImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final imageBytes = await pickedFile.readAsBytes();
      setState(() {
        _licensePhoto = Uint8List.fromList(imageBytes);
      });
    }
  }

  void _addApplication() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    DriverApplicationHandler driverApplicationHandler = DriverApplicationHandler(dbHelper.db);

    if (_licensePhoto.isNotEmpty && _experience > 0) {
      DriverApplication newApplication = DriverApplication(_experience, _licensePhoto, currentUserId);
      await driverApplicationHandler.insert(newApplication);
      Navigator.pop(context);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Ошибка"),
            content: Text("Пожалуйста, добавьте фото водительского удостоверения и укажите опыт вождения"),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("OK"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
        builder: (context, authNotifier, child)
    {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.amberAccent,
          title: const Text(
            'Стать водителем',
            style: TextStyle(fontWeight: FontWeight.w600),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                TextFormField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      labelText: 'Опыт вождения (в годах)'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Пожалуйста, введите ваш опыт вождения';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _experience = int.parse(value!);
                  },
                ),
                SizedBox(height: 16),
                _licensePhoto.isEmpty
                    ? ElevatedButton(
                  onPressed: _getImage,
                  child: Text('Добавить фото водительского удостоверения'),
                )
                    : Image.memory(_licensePhoto),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      _addApplication();
                    }
                  },
                  child: Text('Отправить заявление'),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
