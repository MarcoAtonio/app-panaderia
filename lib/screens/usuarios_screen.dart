import 'package:flutter/material.dart';

class UsuariosScreen extends StatefulWidget {
  @override
  State<UsuariosScreen> createState() => _UsuariosScreenState();
}

class _UsuariosScreenState extends State<UsuariosScreen> {
  final List<Map<String, dynamic>> _usuarios = [
    {
      "id": 1,
      "nombre": "Juan Pérez",
      "correo": "juan.perez@example.com",
      "rol": "Admin"
    },
    {
      "id": 2,
      "nombre": "Ana Gómez",
      "correo": "ana.gomez@example.com",
      "rol": "Editor"
    },
    {
      "id": 3,
      "nombre": "Carlos Díaz",
      "correo": "carlos.diaz@example.com",
      "rol": "Usuario"
    },
    {
      "id": 4,
      "nombre": "María López",
      "correo": "maria.lopez@example.com",
      "rol": "Admin"
    },
    {
      "id": 5,
      "nombre": "Pedro Martínez",
      "correo": "pedro.martinez@example.com",
      "rol": "Editor"
    },
    {
      "id": 6,
      "nombre": "Luisa Rodríguez",
      "correo": "luisa.rodriguez@example.com",
      "rol": "Usuario"
    },
    {
      "id": 7,
      "nombre": "José García",
      "correo": "jose.garcia@example.com",
      "rol": "Admin"
    },
    {
      "id": 8,
      "nombre": "Laura Sánchez",
      "correo": "laura.sanchez@example.com",
      "rol": "Editor"
    },
    {
      "id": 9,
      "nombre": "Raúl Pérez",
      "correo": "raul.perez@example.com",
      "rol": "Usuario"
    },
    {
      "id": 10,
      "nombre": "Sofía Díaz",
      "correo": "sofia.diaz@example.com",
      "rol": "Admin"
    },
  ];

  List<Map<String, dynamic>> _usuariosFiltrados = [];
  TextEditingController _buscadorController = TextEditingController();

  // Paginación
  int _paginaActual = 1;
  int _usuariosPorPagina = 5; // Cantidad de usuarios por página
  int _totalPaginas = 0;


  @override
  void initState() {
    super.initState();
    // Inicializa los usuarios filtrados y el número de páginas
    _usuariosFiltrados = _usuarios;
    _totalPaginas = (_usuariosFiltrados.length / _usuariosPorPagina).ceil();
  }

  void _filtrarUsuarios() {
    setState(() {
      _usuariosFiltrados = _usuarios
          .where((usuario) =>
      usuario['nombre'].toLowerCase().contains(
          _buscadorController.text.toLowerCase()) ||
          usuario['correo'].toLowerCase().contains(
              _buscadorController.text.toLowerCase()))
          .toList();

      // Recalcular el total de páginas después de filtrar
      _totalPaginas = (_usuariosFiltrados.length / _usuariosPorPagina).ceil();
      _paginaActual = 1; // Volver a la primera página después de filtrar
    });
  }

  List<Map<String, dynamic>> _usuariosPorPaginaActual() {
    int inicio = (_paginaActual - 1) * _usuariosPorPagina;
    int fin = inicio + _usuariosPorPagina;
    return _usuariosFiltrados.sublist(inicio,
        fin > _usuariosFiltrados.length ? _usuariosFiltrados.length : fin);
  }

  void _cambiarPagina(int pagina) {
    setState(() {
      _paginaActual = pagina;
    });
  }

  void _eliminarUsuario(int id) {
    setState(() {
      _usuarios.removeWhere((usuario) => usuario['id'] == id);
      _filtrarUsuarios(); // Refiltra después de eliminar
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Usuario eliminado')),
    );
  }


  void _mostrarFormulario({Map<String, dynamic>? usuario}) {
    final _nombreController = TextEditingController(
        text: usuario?['nombre'] ?? '');
    final _correoController = TextEditingController(
        text: usuario?['correo'] ?? '');
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
                decoration: const InputDecoration(
                    labelText: 'Correo Electrónico'),
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

  void _mostrarModalUsuario(BuildContext context,
      Map<String, dynamic> usuario) {
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
            bottom: MediaQuery
                .of(context)
                .viewInsets
                .bottom + 16,
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
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
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
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
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
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
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
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600),
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
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 12),
                  ),
                  child: const Text(
                    'Cerrar',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 20),
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
        backgroundColor: Color(0xFFF4A259),
        elevation: 5,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/Fondosregistros.png'),
            // Aquí cargamos la imagen desde los activos
            fit: BoxFit.cover, // Hace que la imagen cubra toda la pantalla
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _buscadorController,
                        decoration: InputDecoration(
                          hintText: 'Buscar usuario...',
                          prefixIcon: const Icon(Icons.search),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30),
                            borderSide: BorderSide(
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ),
                        onChanged: (value) {
                          _filtrarUsuarios();
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      onPressed: () => _mostrarFormulario(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber.shade700,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        shadowColor: Colors.black54,
                        elevation: 5,
                      ),
                      icon: const Icon(
                          Icons.add, color: Colors.white, size: 20),
                      label: const Text(
                        'Agregar Usuario',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.builder(
                    itemCount: _usuariosPorPaginaActual().length,
                    itemBuilder: (context, index) {
                      final usuario = _usuariosPorPaginaActual()[index];
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
                              style: const TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold),
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
                                icon: const Icon(
                                    Icons.edit, color: Colors.blue),
                                onPressed: () =>
                                    _mostrarFormulario(usuario: usuario),
                              ),
                              IconButton(
                                icon: const Icon(
                                    Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _eliminarUsuario(usuario['id']),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back),
                      onPressed: _paginaActual > 1
                          ? () => _cambiarPagina(_paginaActual - 1)
                          : null,
                    ),
                    Text('Página $_paginaActual de $_totalPaginas'),
                    IconButton(
                      icon: const Icon(Icons.arrow_forward),
                      onPressed: _paginaActual < _totalPaginas
                          ? () => _cambiarPagina(_paginaActual + 1)
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}