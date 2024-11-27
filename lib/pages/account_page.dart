import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart'; 

class AccountPage extends StatefulWidget {
  const AccountPage({super.key});

  @override
  AccountPageState createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
  String? _loggedInUser;
  String? _userRole;

  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  List<Map<String, String>> _users = [];

  // Загрузка пользователей из JSON
  Future<void> _loadUsers() async {
    final List<Map<String, String>> users = await loadUsers();
    setState(() {
      _users = users;
    });
  }

  // Загружаем пользователей из JSON
  Future<List<Map<String, String>>> loadUsers() async {
    final String response = await rootBundle.loadString('/users.json');
    final List<dynamic> data = jsonDecode(response);
    return data.map((user) => Map<String, String>.from(user)).toList();
  }

  // Сохранение сессионных данных
  Future<void> _saveSession(String username, String role) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username);
    prefs.setString('role', role);
  }

  // Загрузка сессионных данных
  Future<void> _loadSession() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _loggedInUser = prefs.getString('username');
      _userRole = prefs.getString('role');
    });
  }

  // Авторизация пользователя
  void _login(String username, String password) {
    final user = _users.firstWhere(
      (user) =>
          user['username'] == username && user['password'] == password,
      orElse: () => {},
    );

    if (user.isNotEmpty) {
      setState(() {
        _loggedInUser = user['username'];
        _userRole = user['role'];
      });
      _saveSession(user['username']!, user['role']!); // Сохраняем сессию
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Неверные данные для входа')),
      );
    }
  }

  // Выход из системы
  void _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('username');
    prefs.remove('role');

    setState(() {
      _loggedInUser = null;
      _userRole = null;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUsers(); // Загружаем пользователей
    _loadSession(); // Загружаем сессию при запуске приложения
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Аккаунт'),
      ),
      body: Center(
        child: _loggedInUser == null ? _buildLoginForm() : _buildProfile(),
      ),
    );
  }

  Widget _buildLoginForm() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: InputDecoration(labelText: 'Имя пользователя'),
          ),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(labelText: 'Пароль'),
            obscureText: true,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _login(_usernameController.text, _passwordController.text);
            },
            child: Text('Войти'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfile() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Добро пожаловать, $_loggedInUser!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Роль: $_userRole',
          style: TextStyle(fontSize: 16),
        ),
        if (_userRole == 'admin') ...[
          SizedBox(height: 20),
          Text(
            'У вас есть права администратора.',
            style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
          ),
        ],
        SizedBox(height: 30),
        ElevatedButton(
          onPressed: _logout,
          child: Text('Выйти'),
        ),
      ],
    );
  }
}
