import 'package:flutter/material.dart';
import 'package:nuevo_crudpan/screens/productos_screen.dart';
import 'package:nuevo_crudpan/screens/ventas_screen.dart';
import 'package:nuevo_crudpan/screens/pedidos_screen.dart';
import 'login_screen.dart';
import 'usuarios_screen.dart';
import 'materia_prima_screen.dart';

class MainMenuScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start, // Cambiado de center a start
          children: [
            // Logo circular
            Container(
              width: 40, // Tamaño del contenedor circular
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle, // Forma circular
                color: Colors.white, // Fondo blanco para resaltar la imagen
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26, // Sombra sutil
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipOval(
                child: Image.asset(
                  'assets/images/Logogalleta.png', // Ruta de la imagen
                  fit: BoxFit.cover, // Ajuste para que la imagen cubra el área circular
                ),
              ),
            ),
            SizedBox(width: 10), // Espacio entre el logo y el texto
            const Text(
              'Menú Principal',
              style: TextStyle(fontSize: 22),
            ),
          ],
        ),
        backgroundColor: Color(0xFFF4A259), // Amarillo cálido
        elevation: 0,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.brown.shade50, // Beige claro
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
      body: Stack(
        children: [
          // Imagen de fondo
          Positioned.fill(
            child: Image.asset(
              'assets/images/Fondodashborad.png', // Ruta de la imagen de fondo
              fit: BoxFit.cover, // Ajuste para que la imagen cubra toda el área
            ),
          ),
          // Contenido principal de la pantalla
          Padding(
            padding: const EdgeInsets.only(top: 90.0), // Añadir espacio arriba
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start, // Alineamos hacia arriba
                  children: [
                    Card(
                      elevation: 10, // Sombra más marcada
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      color: Colors.brown.shade50, // Color suave para el fondo del card
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          children: [
                            Text(
                              'Bienvenido al Sistema de la Panadería: "Los Suavicremas"',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.brown.shade800, // Color más oscuro para el texto
                                fontFamily: 'Montserrat', // Cambié la fuente a una más formal
                              ),
                              textAlign: TextAlign.center,
                            ),
                            const SizedBox(height: 16),
                            // Imagen dentro de un círculo con margen y estilo formal
                            Container(
                              padding: const EdgeInsets.all(12.0), // Margen interno del círculo
                              decoration: BoxDecoration(
                                shape: BoxShape.circle, // Forma circular
                                color: Colors.white, // Fondo blanco para resaltar la imagen
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.1), // Sombra suave
                                    blurRadius: 8, // Sombras sutiles para darle profundidad
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'assets/images/panblanco.png',
                                  height: 140, // Ajusta el tamaño de la imagen
                                  width: 140,  // Ajusta el tamaño de la imagen
                                  fit: BoxFit.cover, // Ajuste de la imagen dentro del círculo
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Servicios web © 2024',
                      style: TextStyle(
                        color: Colors.brown,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat', // Fuente formal
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return DrawerHeader(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFF4A259), Color(0xFFF1D0A4)], // Usando el mismo color de 'Menu Principal' y uno más suave
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center, // Centra el contenido verticalmente
        crossAxisAlignment: CrossAxisAlignment.center, // Centra el contenido horizontalmente
        children: [
          // Imagen del logo centrada
          Container(
            padding: const EdgeInsets.all(8.0), // Margen más suave entre la imagen y el borde
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white, // Fondo blanco para resaltar la imagen
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2), // Sombra sutil para darle profundidad
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                'assets/images/LogoFinal.png', // Ruta de la imagen del logo
                fit: BoxFit.cover,
                width: 70,  // Aumento el tamaño para hacerlo más prominente
                height: 70, // Aumento el tamaño
              ),
            ),
          ),
          const SizedBox(height: 12), // Espacio entre la imagen y el texto "Panadería Los Suavicremas"
          // Texto "Panadería Los Suavicremas" centrado
          const Text(
            'Panadería "Los Suavicremas"',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 19, // Tamaño más grande para hacerlo más visible
              color: Colors.white, // Un tono blanco más suave para el texto
              fontFamily: 'Montserrat', // Mantener la misma fuente para la coherencia
            ),
          ),
        ],
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
        backgroundColor: Colors.brown.shade100,
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
