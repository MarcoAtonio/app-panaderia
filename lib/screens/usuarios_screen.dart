import 'package:flutter/material.dart';

class UsuariosScreen extends StatefulWidget {
  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final List<Map<String, dynamic>> _usuarios = [
    {"id": 1, "nombre": "Juan Pérez", "correo": "juan.perez@example.com", "rol": "Admin"},
    {"id": 2, "nombre": "Ana Gómez", "correo": "ana.gomez@example.com", "rol": "Editor"},
    {"id": 3, "nombre": "Carlos Díaz", "correo": "carlos.diaz@example.com", "rol": "Usuario"},
  ];

  void _eliminarUsuario(int id) {
    setState(() {
      _usuarios.removeWhere((usuario) => usuario['id'] == id);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario eliminado')),
    );
  }

  void _mostrarFormulario({Map<String, dynamic>? usuario}) {
    final _nombreController = TextEditingController(text: usuario?['nombre'] ?? '');
    final _correoController = TextEditingController(text: usuario?['correo'] ?? '');
    final _rolController = TextEditingController(text: usuario?['rol'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(usuario == null ? 'Agregar Usuario' : 'Editar Usuario'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _correoController,
                decoration: const InputDecoration(labelText: 'Correo Electrónico'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _rolController,
                decoration: const InputDecoration(labelText: 'Rol'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (usuario == null) {
                    // Agregar un nuevo usuario
                    final nuevoUsuario = {
                      "id": _usuarios.isNotEmpty
                          ? _usuarios.last['id'] + 1
                          : 1, // Calcula un nuevo ID
                      "nombre": _nombreController.text,
                      "correo": _correoController.text,
                      "rol": _rolController.text,
                    };
                    _usuarios.add(nuevoUsuario);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuario agregado')),
                    );
                  } else {
                    // Editar usuario existente
                    usuario['nombre'] = _nombreController.text;
                    usuario['correo'] = _correoController.text;
                    usuario['rol'] = _rolController.text;
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Usuario actualizado')),
                    );
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text(usuario == null ? 'Agregar' : 'Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarModalUsuario(BuildContext context, Map<String, dynamic> usuario) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            top: 16,
            left: 16,
            right: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Información del Usuario',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.brown.shade800,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const Divider(thickness: 1, color: Colors.grey),
              const SizedBox(height: 16),
              Row(
                children: [
                  const Icon(Icons.badge, color: Colors.brown),
                  const SizedBox(width: 8),
                  Text(
                    'ID: ${usuario['id']}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.person, color: Colors.brown),
                  const SizedBox(width: 8),
                  Text(
                    'Nombre: ${usuario['nombre']}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.email, color: Colors.brown),
                  const SizedBox(width: 8),
                  Text(
                    'Correo: ${usuario['correo']}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(Icons.assignment_ind, color: Colors.brown),
                  const SizedBox(width: 8),
                  Text(
                    'Rol: ${usuario['rol']}',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.brown,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                  ),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Usuarios'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.brown.shade800,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.brown),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF3E0), // Crema
              Color(0xFFF9A825), // Dorado
              Color(0xFF8D6E63), // Marrón suave
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () => _mostrarFormulario(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shadowColor: Colors.black54,
                    elevation: 5,
                  ),
                  icon: const Icon(Icons.add, color: Colors.white, size: 24),
                  label: const Text(
                    'Agregar Usuario',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _usuarios.length,
                    itemBuilder: (context, index) {
                      final usuario = _usuarios[index];
                      return Card(
                        elevation: 6,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: ListTile(
                          onTap: () => _mostrarModalUsuario(context, usuario),
                          leading: CircleAvatar(
                            backgroundColor: Colors.amber.shade700,
                            child: Text(
                              usuario['id'].toString(),
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                          title: Text(
                            usuario['nombre'],
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Correo: ${usuario['correo']}'),
                              Text('Rol: ${usuario['rol']}'),
                            ],
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  _mostrarFormulario(usuario: usuario);
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  _eliminarUsuario(usuario['id']);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
