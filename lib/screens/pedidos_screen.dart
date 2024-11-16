import 'package:flutter/material.dart';

class PedidosScreen extends StatefulWidget {
  @override
  _PedidosScreenState createState() => _PedidosScreenState();
}

class _PedidosScreenState extends State<PedidosScreen> {
  final List<Map<String, dynamic>> _pedidos = List.generate(
    15,
        (index) => {
      "id": index + 1,
      "pedido": "Pedido ${index + 1}",
      "fecha": "2024-11-${(index % 30) + 1}",
      "total": (index + 1) * 100.0,
    },
  );

  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  int _itemsPerPage = 3;

  List<Map<String, dynamic>> get _paginatedPedidos {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _pedidos.sublist(
        startIndex, endIndex > _pedidos.length ? _pedidos.length : endIndex);
  }

  void _mostrarFormulario({Map<String, dynamic>? pedido}) {
    final TextEditingController _pedidoController = TextEditingController(
        text: pedido != null ? pedido['pedido'] : '');
    final TextEditingController _fechaController = TextEditingController(
        text: pedido != null ? pedido['fecha'] : '');
    final TextEditingController _totalController = TextEditingController(
        text: pedido != null ? pedido['total'].toString() : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(pedido == null ? 'Agregar Pedido' : 'Editar Pedido'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _pedidoController,
                decoration: const InputDecoration(labelText: 'Pedido'),
              ),
              TextField(
                controller: _fechaController,
                decoration: const InputDecoration(labelText: 'Fecha'),
              ),
              TextField(
                controller: _totalController,
                decoration: const InputDecoration(labelText: 'Total'),
                keyboardType: TextInputType.number,
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
                if (_pedidoController.text.isNotEmpty &&
                    _fechaController.text.isNotEmpty &&
                    _totalController.text.isNotEmpty) {
                  setState(() {
                    if (pedido == null) {
                      final nuevoPedido = {
                        "id": _pedidos.isNotEmpty
                            ? _pedidos.last['id'] + 1
                            : 1,
                        "pedido": _pedidoController.text,
                        "fecha": _fechaController.text,
                        "total": double.parse(_totalController.text),
                      };
                      _pedidos.add(nuevoPedido);
                    } else {
                      pedido['pedido'] = _pedidoController.text;
                      pedido['fecha'] = _fechaController.text;
                      pedido['total'] = double.parse(_totalController.text);
                    }
                  });
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _eliminarPedido(Map<String, dynamic> pedido) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Está seguro de que desea eliminar el pedido?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _pedidos.remove(pedido);
                });
                Navigator.of(context).pop();
              },
              child: const Text('Eliminar'),
            ),
          ],
        );
      },
    );
  }

  void _mostrarDetallesPedido(Map<String, dynamic> pedido) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Detalles de Pedido: ${pedido['pedido']}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('ID: ${pedido['id']}'),
              Text('Pedido: ${pedido['pedido']}'),
              Text('Fecha: ${pedido['fecha']}'),
              Text('Total: \$${pedido['total'].toStringAsFixed(2)}'),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }

  void _generarPdfPedido(Map<String, dynamic> pedido) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Generar PDF'),
          content: Text(
            'Se ha generado un archivo PDF con los detalles del pedido: "${pedido['pedido']}". (Simulación)',
          ),
          actions: [
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cerrar'),
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
        title: const Text('Gestión de Pedidos'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar por ID o Pedido',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 12.0, horizontal: 16.0),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.green.shade400, Colors.green.shade700],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        offset: Offset(2, 4),
                        blurRadius: 6,
                      ),
                    ],
                  ),
                  child: ElevatedButton.icon(
                    onPressed: () => _mostrarFormulario(),
                    icon: Icon(Icons.add, color: Colors.white),
                    label: const Text(
                      'Nuevo',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          vertical: 14.0, horizontal: 20.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: _paginatedPedidos.length,
                itemBuilder: (context, index) {
                  final pedido = _paginatedPedidos[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'ID: ${pedido['id']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.brown.shade700,
                                ),
                              ),
                              Text(
                                '\$${pedido['total'].toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8.0),
                          Text(
                            'Pedido: ${pedido['pedido']}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                          Text(
                            'Fecha: ${pedido['fecha']}',
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black54,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton.icon(
                                onPressed: () => _mostrarFormulario(pedido: pedido),
                                icon: Icon(Icons.edit, color: Colors.white),
                                label: const Text('Editar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue.shade600,
                                  shadowColor: Colors.blue.shade200,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () => _eliminarPedido(pedido),
                                icon: Icon(Icons.delete, color: Colors.white),
                                label: const Text('Eliminar'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red.shade600,
                                  shadowColor: Colors.red.shade200,
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8.0),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              PopupMenuButton<String>(
                                onSelected: (option) {
                                  if (option == 'Detalles') {
                                    _mostrarDetallesPedido(pedido);
                                  } else if (option == 'Generar PDF') {
                                    _generarPdfPedido(pedido);
                                  }
                                },
                                icon: Icon(Icons.more_vert,
                                    size: 24, color: Colors.grey.shade700),
                                itemBuilder: (BuildContext context) {
                                  return [
                                    PopupMenuItem(
                                      value: 'Detalles',
                                      child: Row(
                                        children: [
                                          Icon(Icons.visibility,
                                              color: Colors.green.shade600),
                                          const SizedBox(width: 8),
                                          const Text('Detalles'),
                                        ],
                                      ),
                                    ),
                                    PopupMenuItem(
                                      value: 'Generar PDF',
                                      child: Row(
                                        children: [
                                          Icon(Icons.picture_as_pdf,
                                              color: Colors.red.shade400),
                                          const SizedBox(width: 8),
                                          const Text('Generar PDF'),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
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
                      icon: Icon(Icons.chevron_left),
                    ),
                    Text(
                        'Página $_currentPage de ${(_pedidos.length / _itemsPerPage).ceil()}'),
                    IconButton(
                      onPressed: _currentPage <
                          (_pedidos.length / _itemsPerPage).ceil()
                          ? () {
                        setState(() {
                          _currentPage++;
                        });
                      }
                          : null,
                      icon: Icon(Icons.chevron_right),
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
