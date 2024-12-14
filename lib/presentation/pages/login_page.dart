import 'package:flutter/material.dart';
import 'package:pkk/data/api/auth_function.dart';
import 'package:pkk/data/preferences.dart';
import 'package:pkk/presentation/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Column(
            children: [
              Icon(
                Icons.cancel_outlined,
                size: 75,
              ),
              Text(
                'Maaf',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Color(0xFF404C61),
                ),
              ),
            ],
          ),
          content: const Text(
            'No. Telepon atau kata sandi yang anda masukkan salah!',
            textAlign: TextAlign.center,
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AuthFunction.login(payload: {
        "phone": _phoneController.text,
        "password": _passwordController.text,
        // User
        // "phone": "081246267118",
        // "password": "123456",
        // Admin
        // "phone": "00000002",
        // "password": "123",
      });

      if (result) {
        await Preferences.init().then((_) {
          // final user = Preferences.getUser();
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (_) => const HomePage(),
            ),
          );
        });
      } else {
        _showConfirmationDialog();
      }
    } catch (e) {
      debugPrint('Error when hitting login button ${e.toString()}');
      _showConfirmationDialog();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeContext = Theme.of(context);

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  color: themeContext.colorScheme.secondary,
                ),
              ),
              Expanded(
                child: Container(
                  color: themeContext.primaryColor,
                ),
              ),
            ],
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Spacer(flex: 2),
                  const Text(
                    'Selamat Datang',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Login ke akun Anda menggunakan No. telepon dan kata sandi',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(flex: 1),
                  SizedBox(
                    child: Stack(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: const Color(0x99FFFFFF),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            children: [
                              TextField(
                                keyboardType: TextInputType.number,
                                controller: _phoneController,
                                cursorColor: themeContext.primaryColorDark,
                                decoration: InputDecoration(
                                  hintText: 'No. Telepon',
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: themeContext.primaryColorDark,
                                    ),
                                  ),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              TextField(
                                obscureText: true,
                                controller: _passwordController,
                                cursorColor: themeContext.primaryColorDark,
                                decoration: InputDecoration(
                                  hintText: 'Kata Sandi',
                                  enabledBorder: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: themeContext.primaryColorDark,
                                    ),
                                  ),
                                  border: const UnderlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 30),
                            ],
                          ),
                        ),
                        Positioned(
                          // bottom: -25,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: _isLoading
                                ? const CircularProgressIndicator()
                                : FilledButton(
                                    onPressed: _login,
                                    child: const Text('Login'),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(flex: 4),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
