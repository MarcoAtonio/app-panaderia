import 'package:flutter/material.dart';
import 'package:nuevo_crudpan/screens/productos_screen.dart';
import 'package:nuevo_crudpan/screens/ventas_screen.dart'; // Importa VentasScreen
import 'package:nuevo_crudpan/screens/pedidos_screen.dart'; // Importa PedidosScreen
import 'login_screen.dart'; // Importa LoginScreen para navegación al cerrar sesión
import 'usuarios_screen.dart'; // Importa UsuariosScreen para navegar a la vista de usuarios
import 'materia_prima_screen.dart'; // Importa MateriaPrimaScreen para la vista de Materia Prima

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menú Principal'),
        backgroundColor: Colors.orange.shade700,
        elevation: 0,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.orange.shade50,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              _buildDrawerHeader(),
              _buildDrawerItem(
                context,
                icon: Icons.home,
                title: 'Inicio',
                onTap: () => Navigator.pop(context),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.person,
                title: 'Usuarios',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UsuariosScreen()),
                ),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.shopping_bag,
                title: 'Productos',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ProductosScreen()),
                ),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.inventory,
                title: 'Materia Prima',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MateriaPrimaScreen()),
                ),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.dinner_dining,
                title: 'Ventas',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => VentasScreen()),
                ),
              ),
              _buildDrawerItem(
                context,
                icon: Icons.receipt_long,
                title: 'Pedidos',
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PedidosScreen()),
                ),
              ),
              const Divider(),
              _buildDrawerItem(
                context,
                icon: Icons.logout,
                title: 'Cerrar Sesión',
                onTap: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => LoginScreen()),
                ),
                textColor: Colors.redAccent.shade700,
              ),
            ],
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.orange.shade100, Colors.orange.shade300],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  color: Colors.yellow.shade200,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        const Text(
                          'Bienvenido al Sistema de la Panadería "El Triunfo"',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Image.asset(
                          'assets/images/panadero.png', // Ruta de la imagen del panadero
                          height: 120,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Ing De Software © 2024',
                  style: TextStyle(color: Colors.brown, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.orange.shade800, Colors.brown.shade700],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      accountName: const Text(
        'Juan Pérez',
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      accountEmail: const Text('juan.perez@example.com'),
      currentAccountPicture: CircleAvatar(
        backgroundColor: Colors.white,
        child: Image.asset(
          'assets/images/user_avatar.png', // Ruta de la imagen de usuario
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildDrawerItem(
      BuildContext context, {
        required IconData icon,
        required String title,
        required Function() onTap,
        Color textColor = Colors.brown,
      }) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.orange.shade100,
        child: Icon(icon, color: textColor, size: 20),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: textColor,
        ),
      ),
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      trailing: Icon(Icons.chevron_right, color: textColor),
    );
  }
}
