import 'dart:convert'; // Для utf8
import 'package:crypto/crypto.dart'; // Для хэширования
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Импортируем твой конфиг для стилей
import 'package:car_care/configs/car_config.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  // Контроллеры для полей ввода
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // true - режим Входа, false - режим Регистрации
  bool _isLoginMode = true;
  bool _isLoading = false;

  // --- ЛОГИКА БЕЗОПАСНОСТИ И ХРАНЕНИЯ ---

  // 1. Функция хэширования пароля (SHA-256)
  String _hashPassword(String password) {
    var bytes = utf8.encode(password); // конвертируем в байты
    var digest = sha256.convert(bytes); // хэшируем
    return digest.toString(); // возвращаем хэш-строку
  }

  // 2. Логика Регистрации
  Future<void> _register() async {
    final login = _loginController.text.trim();
    final password = _passwordController.text.trim();

    if (login.isEmpty || password.isEmpty) {
      _showError("Заполните все поля");
      return;
    }

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();

    // Проверка: существует ли пользователь
    if (prefs.containsKey('user_$login')) {
      _showError("Пользователь с таким логином уже существует");
      setState(() => _isLoading = false);
      return;
    }

    // Хэшируем пароль перед сохранением
    final passwordHash = _hashPassword(password);

    // Сохраняем: Ключ = "user_login", Значение = Хэш пароля
    await prefs.setString('user_$login', passwordHash);

    _showSuccess("Регистрация успешна! Теперь войдите.");
    
    // Переключаем на режим входа
    setState(() {
      _isLoginMode = true;
      _isLoading = false;
      _passwordController.clear();
    });
  }

  // 3. Логика Входа
  Future<void> _login() async {
    final login = _loginController.text.trim();
    final password = _passwordController.text.trim();

    if (login.isEmpty || password.isEmpty) {
      _showError("Введите логин и пароль");
      return;
    }

    setState(() => _isLoading = true);

    final prefs = await SharedPreferences.getInstance();

    // Проверяем, есть ли такой логин
    if (!prefs.containsKey('user_$login')) {
      _showError("Пользователь не найден");
      setState(() => _isLoading = false);
      return;
    }

    // Получаем сохраненный хэш
    final savedHash = prefs.getString('user_$login');
    
    // Хэшируем введенный пароль
    final inputHash = _hashPassword(password);

    // Сравниваем хэши
    if (savedHash == inputHash) {
      // УСПЕХ!
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/home');
      }
    } else {
      _showError("Неверный пароль");
    }

    setState(() => _isLoading = false);
  }

  // --- ВСПОМОГАТЕЛЬНЫЕ МЕТОДЫ UI ---

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.redAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: CarConfig.accentNeon,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CarConfig.primaryDark,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Логотип или иконка
              const Icon(Icons.security, size: 80, color: CarConfig.accentBlue),
              const SizedBox(height: 20),
              Text(
                _isLoginMode ? "ВХОД" : "РЕГИСТРАЦИЯ",
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 40),

              // Карточка с полями
              Container(
                padding: const EdgeInsets.all(20),
                decoration: CarConfig.premiumCard,
                child: Column(
                  children: [
                    // Поле Логина
                    TextField(
                      controller: _loginController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Логин",
                        labelStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.person, color: CarConfig.accentBlue),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white24),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: CarConfig.accentNeon),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Поле Пароля
                    TextField(
                      controller: _passwordController,
                      obscureText: true, // Скрываем текст точками
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: "Пароль",
                        labelStyle: const TextStyle(color: Colors.white54),
                        prefixIcon: const Icon(Icons.lock, color: CarConfig.accentBlue),
                        enabledBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.white24),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: CarConfig.accentNeon),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Кнопка действия
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading 
                            ? null 
                            : (_isLoginMode ? _login : _register),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: CarConfig.accentBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : Text(
                                _isLoginMode ? "ВОЙТИ" : "ЗАРЕГИСТРИРОВАТЬСЯ",
                                style: const TextStyle(
                                    color: Colors.white, 
                                    fontWeight: FontWeight.bold, 
                                    fontSize: 16
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Переключатель режима
              TextButton(
                onPressed: () {
                  setState(() {
                    _isLoginMode = !_isLoginMode;
                    // Очищаем поля при переключении, чтобы не путать
                    _loginController.clear();
                    _passwordController.clear();
                  });
                },
                child: Text(
                  _isLoginMode
                      ? "Нет аккаунта? Зарегистрироваться"
                      : "Уже есть аккаунт? Войти",
                  style: const TextStyle(color: CarConfig.accentNeon),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}