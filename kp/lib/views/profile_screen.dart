import 'package:flutter/material.dart';
import 'package:kp/services/auth_notifier.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:kp/views/become_a_driver_form.dart';
import 'package:provider/provider.dart';
import 'package:kp/models/Client.dart';
import 'package:kp/services/client_handler.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _lastnameController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();

  late Future<List<Client>> _clientsFuture;

  @override
  void initState() {
    super.initState();
    _clientsFuture = _getAllClients();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _clientsFuture = _getAllClients();
  }

  Future<List<Client>> _getAllClients() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    ClientHandler clientHandler = ClientHandler(dbHelper.db);

    return clientHandler.getAllClients();
  }

  void _error(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ошибка'),
        content: Text(message),
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

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthNotifier>(
      builder: (context, authNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.amberAccent,
            title: const Text(
              'Профиль',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (authNotifier.isAuthenticated)
                      Text(
                        'Приветствуем, ${authNotifier.isAuthenticated ? authNotifier.currentUser!.userLastname  : ''}!',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    else
                      Text(
                        'Регистрация',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    SizedBox(height: 10),
                    if (!authNotifier.isAuthenticated)
                      TextFormField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          labelText: 'Username',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста введите ваш username';
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 10),
                    if (!authNotifier.isAuthenticated)
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Пароль',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста введите ваш пароль';
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 10),
                    if (!authNotifier.isAuthenticated)
                      TextFormField(
                        controller: _confirmPasswordController,
                        decoration: InputDecoration(
                          labelText: 'Подтвердить пароль',
                          border: OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста введите ваш пароль';
                          }
                          if (value != _passwordController.text) {
                            return 'Пароли не совпадают';
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 10),
                    if (!authNotifier.isAuthenticated)
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста введите ваш email';
                          }
                          if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                            return 'Пожалуйста введите валидный email';
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 10),
                    if (!authNotifier.isAuthenticated)
                      TextFormField(
                        controller: _lastnameController,
                        decoration: InputDecoration(
                          labelText: 'Фамилия',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста введите вашу фамилию';
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 10),
                    if (!authNotifier.isAuthenticated)
                      TextFormField(
                        controller: _phoneNumberController,
                        decoration: InputDecoration(
                          labelText: 'Номер телефона',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Пожалуйста введите ваш номер телефона';
                          }
                          if (!RegExp(r'^\+375[0-9]{9}$').hasMatch(value)) {
                            return 'Пример валидного номера +375256615859';
                          }
                          return null;
                        },
                      ),
                    SizedBox(height: 20),
                    if (!authNotifier.isAuthenticated)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (!authNotifier.isAuthenticated)
                            ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _signUp(context);
                                }
                              },
                              child: Text('Зарегистрироваться'),
                            ),
                          if (!authNotifier.isAuthenticated)
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen()),
                                );
                              },
                              child: const Text('Войти'),
                            ),
                        ],
                      ),
                    if (authNotifier.currentUser.roleId == 2)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => BecomeADriverForm()),
                          );
                        },
                        child: Text('Стать водителем'),
                      ),
                    if (authNotifier.isAuthenticated)
                      ElevatedButton(
                        onPressed: () {
                          authNotifier.logout();
                        },
                        child: Text('Выйти из аккаунта'),
                      ),
                    SizedBox(height: 10),
                    Visibility(
                      visible: authNotifier.currentUser.roleId == 1,
                      child: FutureBuilder<List<Client>>(
                        future: _clientsFuture,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return CircularProgressIndicator();
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            List<Client>? clients = snapshot.data;
                            return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: clients!.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(
                                      'ID: ${clients[index].userId}, Name: ${clients[index].username}, Phone: ${clients[index].telephone}, Email: ${clients[index].userEmail}'
                                  ),
                                  subtitle: Text(
                                      'Password: ${clients[index].userPassword}, LastName: ${clients[index].userLastname}, Role: ${clients[index].roleId}'
                                  ),
                                );
                              },
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _signUp(BuildContext context) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    ClientHandler clientHandler = ClientHandler(dbHelper.db);

    bool usernameExists = await checkUsernameExists(_usernameController.text);
    if (usernameExists) {
      _error('Username already exists');
      return;
    }

    bool phoneNumberExists = await checkPhoneNumberExists(_phoneNumberController.text);
    if (phoneNumberExists) {
      _error('Phone number already exists');
      return;
    }
    bool emailExist = await checkEmailExists(_emailController.text);
    if (emailExist) {
      _error('Email already exists');      return;
    }
    if (_passwordController.text != _confirmPasswordController.text) {
      _error('Passwords do not match');
      return;
    }

    Client newClient = Client(
      _emailController.text,
      _passwordController.text,
      _usernameController.text,
      _lastnameController.text,
      _phoneNumberController.text,
      2,
      "REGISTERED",
    );

    await clientHandler.insert(newClient);
    _passwordController.clear();
    _usernameController.clear();
    _confirmPasswordController.clear();
    _emailController.clear();
    _lastnameController.clear();
    _phoneNumberController.clear();

    setState(() {
      _clientsFuture = _getAllClients();
    });
  }

  Future<bool> checkPhoneNumberExists(String phoneNumber) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    ClientHandler clientHandler = ClientHandler(dbHelper.db);
    final allClients = await clientHandler.getAllClients();
    return allClients.any((client) => client.telephone == phoneNumber);
  }

  Future<bool> checkUsernameExists(String username) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    ClientHandler clientHandler = ClientHandler(dbHelper.db);
    final allClients = await clientHandler.getAllClients();
    return allClients.any((client) => client.username == username);
  }

  Future<bool> checkEmailExists(String userEmail) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    ClientHandler clientHandler = ClientHandler(dbHelper.db);
    final allClients = await clientHandler.getAllClients();
    return allClients.any((client) => client.userEmail == userEmail);
  }
}
