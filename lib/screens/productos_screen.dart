import 'package:flutter/material.dart';

class ProductosScreen extends StatefulWidget {
  @override
  State<ProductosScreen> createState() => _ProductosScreenState();
}

class _ProductosScreenState extends State<ProductosScreen> {
  final List<Map<String, dynamic>> _productos = List.generate(
    20,
        (index) => {
      "id": index + 1,
      "nombre": "Producto ${index + 1}",
      "precio": (index + 1) * 1.5,
      "stock": (index + 1) * 10,
      "imagen": "https://via.placeholder.com/150?text=Producto+${index + 1}",
    },
  );


  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  int _itemsPerPage = 5;

  List<Map<String, dynamic>> get _filteredProductos {
    if (_searchController.text.isEmpty) return _productos;
    return _productos
        .where((producto) =>
    producto['nombre']
        .toLowerCase()
        .contains(_searchController.text.toLowerCase()) ||
        producto['id'].toString().contains(_searchController.text))
        .toList();
  }

  List<Map<String, dynamic>> get _paginatedProductos {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredProductos.sublist(
        startIndex, endIndex > _filteredProductos.length ? _filteredProductos.length : endIndex);
  }

  void _mostrarFormulario({Map<String, dynamic>? producto}) {
    final _nombreController = TextEditingController(text: producto?['nombre'] ?? '');
    final _precioController = TextEditingController(text: producto != null ? producto['precio'].toString() : '');
    final _stockController = TextEditingController(text: producto != null ? producto['stock'].toString() : '');
    final _imagenController = TextEditingController(text: producto?['imagen'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(producto == null ? 'Agregar Producto' : 'Editar Producto'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nombreController,
                decoration: const InputDecoration(labelText: 'Nombre'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _precioController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Precio'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _stockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Stock'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _imagenController,
                decoration: const InputDecoration(labelText: 'URL de Imagen'),
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
                // Validación de la URL de la imagen
                if (_imagenController.text.isNotEmpty && !_isValidImageUrl(_imagenController.text)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Por favor, ingrese una URL de imagen válida')),
                  );
                  return;
                }

                setState(() {
                  if (producto == null) {
                    final nuevoProducto = {
                      "id": _productos.isNotEmpty ? _productos.last['id'] + 1 : 1,
                      "nombre": _nombreController.text,
                      "precio": double.parse(_precioController.text),
                      "stock": int.parse(_stockController.text),
                      "imagen": _imagenController.text,
                    };
                    _productos.add(nuevoProducto);
                  } else {
                    producto['nombre'] = _nombreController.text;
                    producto['precio'] = double.parse(_precioController.text);
                    producto['stock'] = int.parse(_stockController.text);
                    producto['imagen'] = _imagenController.text;
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text(producto == null ? 'Agregar' : 'Guardar'),
            ),
          ],
        );
      },
    );
  }
  // Validación de URL (una verificación simple para URLs de imágenes)
  bool _isValidImageUrl(String url) {
    final RegExp regex = RegExp(r"^(https?|ftp)://[^\s/$.?#].[^\s]*$");
    return regex.hasMatch(url) && (url.endsWith('.png') || url.endsWith('.jpg') || url.endsWith('.jpeg'));
  }

  void _eliminarProducto(Map<String, dynamic> producto) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Eliminar Producto'),
          content: Text(
              '¿Estás seguro de que deseas eliminar el producto "${producto['nombre']}"?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _productos.remove(producto);
                });
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Producto "${producto['nombre']}" eliminado')),
                );
              },
              child: const Text('Eliminar'),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: const Text('Gestión de Productos'),
          backgroundColor: Color(0xFFF4A259),
          elevation: 5,
          foregroundColor: Colors.white,

    ),

    body: Container(
    // Agregar una imagen de fondo desde los assets
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage('assets/images/Fondosregistros.png'), // Cargar desde los assets
    fit: BoxFit.cover, // Ajusta la imagen al tamaño del contenedor
    ),
    ),

        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de búsqueda
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar por nombre o ID',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => _mostrarFormulario(),
                  icon: const Icon(Icons.add),
                  label: const Text('Nuevo Producto'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Lista de productos con espacio para imágenes
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 0.63, // Aumento la proporción para hacer los cards más grandes
                ),
                itemCount: _paginatedProductos.length,
                itemBuilder: (context, index) {
                  final producto = _paginatedProductos[index];
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    elevation: 8,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: 110,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.grey.shade300,
                            ),

                            child: producto['imagen'] != null && producto['imagen'].isNotEmpty
                                ? ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                producto['imagen'],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(child: Text('Error al cargar imagen'));
                                },
                              ),
                            )
                                : const Center(
                              child: Text(
                                'Sin imagen',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            producto['nombre'],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 6),
                          Text('Precio: \$${producto['precio'].toStringAsFixed(2)}'),
                          Text('Stock: ${producto['stock']}'),
                          const Spacer(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _mostrarFormulario(producto: producto),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _eliminarProducto(producto),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            // Paginación
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                DropdownButton<int>(
                  value: _itemsPerPage,
                  onChanged: (value) {
                    setState(() {
                      _itemsPerPage = value!;
                      _currentPage = 1;
                    });
                  },
                  items: [3, 5, 10, 15].map((int value) {
                    return DropdownMenuItem<int>(
                      value: value,
                      child: Text('$value por página'),
                    );
                  }).toList(),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _currentPage > 1
                          ? () {
                        setState(() {
                          _currentPage--;
                        });
                      }
                          : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text('Página $_currentPage de ${(_filteredProductos.length / _itemsPerPage).ceil()}'),
                    IconButton(
                      onPressed: _currentPage <
                          (_filteredProductos.length / _itemsPerPage).ceil()
                          ? () {
                        setState(() {
                          _currentPage++;
                        });
                      }
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
