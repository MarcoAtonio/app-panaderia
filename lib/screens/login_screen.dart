import 'package:flutter/material.dart';
import 'main_menu_screen.dart'; // Asegúrate de ajustar la ruta según sea necesario

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _obscureText = true;

  // Validación del correo electrónico
  bool isValidEmail(String email) {
    final regex = RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$");
    return regex.hasMatch(email);
  }

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text;

    // Validación de campos vacíos
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, complete todos los campos.')),
      );
      return;
    }

    // Validación del formato del correo electrónico
    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor, ingrese un correo electrónico válido.')),
      );
      return;
    }

    // Validación de las credenciales
    if (email == "hola@gmail.com" && password == "hola0123") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainMenuScreen()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Correo o contraseña incorrectos')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Fondopanaderia.jpg'), // Ruta de la imagen de fondo
            fit: BoxFit.cover, // Esto ajusta la imagen al tamaño de la pantalla
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(20.0),
              width: MediaQuery.of(context).size.width * 0.85,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.9), // Fondo semi-transparente para que se vea la imagen
                borderRadius: BorderRadius.circular(20.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo circular con margen
                  Container(
                    padding: const EdgeInsets.all(8.0), // Margen alrededor de la imagen
                    decoration: BoxDecoration(
                      shape: BoxShape.circle, // Forma circular
                      color: Colors.white, // Fondo blanco alrededor del logo
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 10,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/images/LogoFinal.png',
                        width: 150.0,  // Tamaño del logo
                        height: 150.0, // Tamaño del logo
                        fit: BoxFit.cover, // Ajuste para cubrir el área circular
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  const Text(
                    'Iniciar Sesión',
                    style: TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown,
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: 'Correo Electrónico',
                      prefixIcon: Icon(Icons.email, color: Colors.brown[300]),
                      filled: true,
                      fillColor: Colors.brown[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16.0),
                  TextField(
                    controller: _passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      labelText: 'Contraseña',
                      prefixIcon: Icon(Icons.lock, color: Colors.brown[300]),
                      filled: true,
                      fillColor: Colors.brown[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30.0),
                        borderSide: BorderSide.none,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                          color: Colors.brown[300],
                        ),
                        onPressed: _togglePasswordVisibility,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: _login,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.brown[300],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: const Text(
                      'Iniciar Sesión',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextButton(
                    onPressed: () {
                      // Acción de crear cuenta
                    },
                    child: const Text(
                      'Crear una cuenta',
                      style: TextStyle(color: Colors.brown, fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  const Text(
                    '- O -',
                    style: TextStyle(fontSize: 14.0, color: Colors.brown),
                  ),
                  const SizedBox(height: 8.0),
                  OutlinedButton.icon(
                    onPressed: () {
                      // Acción de inicio de sesión con Google
                    },
                    icon: Icon(Icons.g_mobiledata, color: Colors.brown, size: 24.0),
                    label: const Text(
                      'Iniciar sesión con Google',
                      style: TextStyle(color: Colors.brown, fontSize: 16),
                    ),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30.0),
                      ),
                      side: BorderSide(color: Colors.brown.shade300),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
