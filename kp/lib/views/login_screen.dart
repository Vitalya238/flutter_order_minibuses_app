import 'package:flutter/material.dart';
import 'package:kp/models/Client.dart';
import 'package:kp/services/auth_notifier.dart';
import 'package:kp/services/client_handler.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:kp/views/view.dart';
import 'package:provider/provider.dart';
import 'package:collection/collection.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  late Future<List<Client>> _clientsFuture;

  @override
  void initState() {
    super.initState();
    _clientsFuture = _getAllClients();
  }

  Future<List<Client>> _getAllClients() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    ClientHandler clientHandler = ClientHandler(dbHelper.db);

    return clientHandler.getAllClients();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: Text('Страница для входа в аккаунт'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(
                labelText: 'Пароль',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _login(context);
              },
              child: Text('Войти'),
            ),
          ],
        ),
      ),
    );
  }

  void _login(BuildContext context) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    ClientHandler clientHandler = ClientHandler(dbHelper.db);

    List<Client> clients = await clientHandler.getAllClients();
    String username = _usernameController.text;
    String password = _passwordController.text;

    Client? currentUser = clients.firstWhereOrNull(
          (client) => client.username == username && client.userPassword == password,
    );

    if (currentUser != null) {
      Provider.of<AuthNotifier>(context, listen: false).login(currentUser);
      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(),
        ),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Ошибка'),
          content: Text('Неправильный username или пароль.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        ),
      );
    }
  }
}
