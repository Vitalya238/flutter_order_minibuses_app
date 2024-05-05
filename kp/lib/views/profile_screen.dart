import 'package:flutter/material.dart';
import 'package:kp/services/auth_notifier.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:provider/provider.dart';
import 'package:kp/models/Client.dart';
import 'package:kp/services/client_handler.dart';
import 'login_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
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

  void _error() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
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
              'Profile',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          body: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (authNotifier.isAuthenticated)
                  Text(
                    'Welcome, ${authNotifier.isAuthenticated ? authNotifier.currentUser!.username : ''}!',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                else
                  Text(
                    'Registration',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(height: 10),
                if (!authNotifier.isAuthenticated)
                  TextField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                SizedBox(height: 10),
                if (!authNotifier.isAuthenticated)
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                SizedBox(height: 10),
                if (!authNotifier.isAuthenticated)
                  TextFormField(
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      labelText: 'Confirm Password',
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                  ),
                SizedBox(height: 10),
                if (!authNotifier.isAuthenticated)
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(),
                    ),
                  ),
                SizedBox(height: 10,),
                if (!authNotifier.isAuthenticated)
                  TextFormField(
                    controller: _lastnameController,
                    decoration: InputDecoration(
                      labelText: 'Lastname',
                      border: OutlineInputBorder(),
                    ),
                  ),
                SizedBox(height: 10,),
                if (!authNotifier.isAuthenticated)
                  TextFormField(
                    controller: _phoneNumberController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      border: OutlineInputBorder(),
                    ),
                  ),
                SizedBox(height: 20),
                if (!authNotifier.isAuthenticated)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      if (!authNotifier.isAuthenticated)
                        ElevatedButton(
                          onPressed: () {
                            if (_usernameController.text.isEmpty ||
                                _passwordController.text.isEmpty ||
                                _confirmPasswordController.text.isEmpty ||
                                _emailController.text.isEmpty ||
                                _lastnameController.text.isEmpty ||
                                _phoneNumberController.text.isEmpty) {
                              _error();
                              return;
                            }
                            if (_passwordController.text != _confirmPasswordController.text) {
                              _error();
                              return;
                            }
                            _signUp(context);
                          },
                          child: Text('Submit'),
                        ),
                      if (!authNotifier.isAuthenticated)
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => LoginScreen()),
                            );
                          },
                          child: const Text('Already have an account?'),
                        ),
                    ],
                  ),
                if (authNotifier.isAuthenticated)
                  ElevatedButton(
                    onPressed: () {
                      authNotifier.logout();
                    },
                    child: Text('Logout'),
                  ),
                SizedBox(height: 10),
                Expanded(
                  child: Visibility(
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
                            itemCount: clients!.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                title: Text(
                                    'ID: ${clients[index].userId}, Name: ${clients[index].username}, Phone: ${clients[index].telephone}, Email: ${clients[index].userEmail}'),
                                subtitle: Text(
                                    'Password: ${clients[index].userPassword}, LastName: ${clients[index].userLastname}, Role: ${clients[index].roleId}'),
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ),

              ],
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
      _showErrorDialog('Username already exists');
      return;
    }

    bool phoneNumberExists = await checkPhoneNumberExists(_phoneNumberController.text);
    if (phoneNumberExists) {
      _showErrorDialog('Phone number already exists');
      return;
    }
    bool emailExist = await checkEmailExists(_emailController.text);
    if (emailExist) {
      _showErrorDialog('Email already exists');
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
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
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

}
