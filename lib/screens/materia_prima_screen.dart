import 'package:flutter/material.dart';

class MateriaPrimaScreen extends StatefulWidget {
  @override
  _MateriaPrimaScreenState createState() => _MateriaPrimaScreenState();
}

class _MateriaPrimaScreenState extends State<MateriaPrimaScreen> {
  final List<Map<String, dynamic>> _materiaPrima = List.generate(
    20,
        (index) => {
      "id": index + 1,
      "nombre": "Material ${index + 1}",
      "descripcion": "Descripción del material ${index + 1}",
      "proveedor": "Proveedor ${index + 1}",
      "cantidad": 1000 + index * 10,
      "unidad": "gramos",
      "precio": 1.50 + index * 0.1,
      "imagenUrl": "https://via.placeholder.com/150"
    },
  );

  final TextEditingController _searchController = TextEditingController();
  int _itemsPerPage = 4;
  int _currentPage = 1;
  bool _isSearchActive = false;
  List<Map<String, dynamic>> _filteredMateriaPrima = [];

  void _activarBusqueda() {
    setState(() {
      _isSearchActive = true;
    });
  }

  void _buscarMateriaPrima(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredMateriaPrima.clear();
        _isSearchActive = false;
      } else {
        _filteredMateriaPrima = _materiaPrima
            .where((item) => item['nombre']
            .toLowerCase()
            .contains(query.toLowerCase()))
            .toList();
        _currentPage = 1; // Reiniciar la paginación al buscar
      }
    });
  }

  List<Map<String, dynamic>> _getItemsToDisplay() {
    final List<Map<String, dynamic>> sourceList =
    _isSearchActive && _filteredMateriaPrima.isNotEmpty
        ? _filteredMateriaPrima
        : _materiaPrima;

    final int startIndex = (_currentPage - 1) * _itemsPerPage;
    final int endIndex = startIndex + _itemsPerPage;

    return sourceList.sublist(
      startIndex,
      endIndex > sourceList.length ? sourceList.length : endIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> currentPageItems = _getItemsToDisplay();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Gestión de Materia Prima'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _activarBusqueda,
                    child: TextField(
                      controller: _searchController,
                      enabled: _isSearchActive,
                      onSubmitted: _buscarMateriaPrima,
                      decoration: InputDecoration(
                        hintText: 'Buscar materia prima',
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 14.0, horizontal: 20.0),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          BorderSide(color: Colors.orange.shade700, width: 1.5),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide:
                          BorderSide(color: Colors.orange.shade900, width: 2.0),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: () => _mostrarFormulario(),
                  icon: Icon(Icons.add, color: Colors.white),
                  label: const Text('Agregar'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange.shade700,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: currentPageItems.length,
              itemBuilder: (context, index) {
                final materia = currentPageItems[index];
                return GestureDetector(
                  onTap: () => _mostrarDetalle(materia),
                  child: Card(
                    margin: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Image.network(
                                materia['imagenUrl'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      materia['nombre'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16.0,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      materia['descripcion'],
                                      style: TextStyle(color: Colors.grey[700]),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Proveedor: ${materia['proveedor']}',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey[600]),
                              ),
                              Text(
                                'Cantidad: ${materia['cantidad']} ${materia['unidad']}',
                                style: TextStyle(
                                    fontSize: 14.0, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Precio: \$${materia['precio'].toStringAsFixed(2)}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.orange.shade700),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () =>
                                        _mostrarFormulario(materiaPrima: materia),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        _materiaPrima.removeAt(index);
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
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
                    Text('Página $_currentPage de ${((_isSearchActive && _filteredMateriaPrima.isNotEmpty ? _filteredMateriaPrima : _materiaPrima).length / _itemsPerPage).ceil()}'),
                    IconButton(
                      onPressed: _currentPage <
                          ((_isSearchActive && _filteredMateriaPrima.isNotEmpty ? _filteredMateriaPrima : _materiaPrima).length / _itemsPerPage).ceil()
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
                Row(
                  children: [
                    Text('Items por página:', style: TextStyle(fontSize: 14.0)),
                    const SizedBox(width: 8),
                    DropdownButton<int>(
                      value: _itemsPerPage,
                      onChanged: (value) {
                        if (value != null) {
                          setState(() {
                            _itemsPerPage = value;
                            _currentPage = 1; // Reiniciar a la primera página
                          });
                        }
                      },
                      items: [2, 4, 6, 8, 10]
                          .map((value) => DropdownMenuItem<int>(
                        value: value,
                        child: Text(value.toString()),
                      ))
                          .toList(),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _mostrarFormulario({Map<String, dynamic>? materiaPrima}) {
    final _nombreController = TextEditingController(text: materiaPrima?['nombre'] ?? '');
    final _descripcionController =
    TextEditingController(text: materiaPrima?['descripcion'] ?? '');
    final _proveedorController =
    TextEditingController(text: materiaPrima?['proveedor'] ?? '');
    final _cantidadController =
    TextEditingController(text: materiaPrima?['cantidad']?.toString() ?? '');
    final _unidadController =
    TextEditingController(text: materiaPrima?['unidad'] ?? '');
    final _precioController =
    TextEditingController(text: materiaPrima?['precio']?.toString() ?? '');
    final _imagenUrlController =
    TextEditingController(text: materiaPrima?['imagenUrl'] ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(materiaPrima == null
              ? 'Agregar Materia Prima'
              : 'Editar Materia Prima'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: _nombreController,
                  decoration: const InputDecoration(labelText: 'Nombre'),
                ),
                TextField(
                  controller: _descripcionController,
                  decoration: const InputDecoration(labelText: 'Descripción'),
                ),
                TextField(
                  controller: _proveedorController,
                  decoration: const InputDecoration(labelText: 'Proveedor'),
                ),
                TextField(
                  controller: _cantidadController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Cantidad'),
                ),
                TextField(
                  controller: _unidadController,
                  decoration: const InputDecoration(labelText: 'Unidad'),
                ),
                TextField(
                  controller: _precioController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Precio'),
                ),
                TextField(
                  controller: _imagenUrlController,
                  decoration: const InputDecoration(labelText: 'URL de Imagen'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  if (materiaPrima == null) {
                    final nuevoMateriaPrima = {
                      "id": _materiaPrima.isNotEmpty
                          ? _materiaPrima.last['id'] + 1
                          : 1,
                      "nombre": _nombreController.text,
                      "descripcion": _descripcionController.text,
                      "proveedor": _proveedorController.text,
                      "cantidad": int.parse(_cantidadController.text),
                      "unidad": _unidadController.text,
                      "precio": double.parse(_precioController.text),
                      "imagenUrl": _imagenUrlController.text,
                    };
                    _materiaPrima.add(nuevoMateriaPrima);
                  } else {
                    materiaPrima['nombre'] = _nombreController.text;
                    materiaPrima['descripcion'] = _descripcionController.text;
                    materiaPrima['proveedor'] = _proveedorController.text;
                    materiaPrima['cantidad'] =
                        int.parse(_cantidadController.text);
                    materiaPrima['unidad'] = _unidadController.text;
                    materiaPrima['precio'] =
                        double.parse(_precioController.text);
                    materiaPrima['imagenUrl'] = _imagenUrlController.text;
                  }
                });
                Navigator.of(context).pop();
              },
              child: Text(materiaPrima == null ? 'Agregar' : 'Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDetalle(Map<String, dynamic> materiaPrima) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: Row(
            children: [
              Expanded(child: Text(materiaPrima['nombre'])),
              IconButton(
                icon: Icon(Icons.close, color: Colors.grey),
                onPressed: () => Navigator.of(context).pop(),
              )
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.network(
                    materiaPrima['imagenUrl'],
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Descripción:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(materiaPrima['descripcion']),
                const SizedBox(height: 8),
                Text(
                  'Proveedor:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(materiaPrima['proveedor']),
                const SizedBox(height: 8),
                Text(
                  'Cantidad:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('${materiaPrima['cantidad']} ${materiaPrima['unidad']}'),
                const SizedBox(height: 8),
                Text(
                  'Precio:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text('\$${materiaPrima['precio']}'),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}
