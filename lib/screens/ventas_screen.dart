import 'package:flutter/material.dart';

class VentasScreen extends StatefulWidget {
  @override
  _VentasScreenState createState() => _VentasScreenState();
}

class _VentasScreenState extends State<VentasScreen> {
  final List<Map<String, dynamic>> _ventas = List.generate(
    15,
        (index) => {
      "id": index + 1,
      "concepto": "Punto de Venta ${index + 1}",
      "total": (index + 1) * 100.0,
    },
  );

  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  int _itemsPerPage = 3;

  // Obtener ventas paginadas
  List<Map<String, dynamic>> get _paginatedVentas {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _ventas.sublist(
        startIndex, endIndex > _ventas.length ? _ventas.length : endIndex);
  }

  void _mostrarFormulario({Map<String, dynamic>? venta}) {
    final TextEditingController _conceptoController = TextEditingController(
        text: venta != null ? venta['concepto'] : '');
    final TextEditingController _totalController = TextEditingController(
        text: venta != null ? venta['total'].toString() : '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(venta == null ? 'Agregar Venta' : 'Editar Venta'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _conceptoController,
                decoration: const InputDecoration(labelText: 'Concepto'),
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
                if (_conceptoController.text.isNotEmpty &&
                    _totalController.text.isNotEmpty) {
                  setState(() {
                    if (venta == null) {
                      final nuevaVenta = {
                        "id": _ventas.isNotEmpty
                            ? _ventas.last['id'] + 1
                            : 1,
                        "concepto": _conceptoController.text,
                        "total": double.parse(_totalController.text),
                      };
                      _ventas.add(nuevaVenta);
                    } else {
                      venta['concepto'] = _conceptoController.text;
                      venta['total'] = double.parse(_totalController.text);
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

  void _eliminarVenta(Map<String, dynamic> venta) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirmar Eliminación'),
          content: const Text('¿Está seguro de que desea eliminar esta venta?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _ventas.remove(venta);
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

  void _mostrarCorteDeCaja() {
    final totalVentas = _ventas.fold(0.0, (sum, venta) => sum + venta['total']);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Corte de Caja'),
          content: Text('El total acumulado de ventas es: \$${totalVentas.toStringAsFixed(2)}'),
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

  void _mostrarReporteDelDia() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reporte del Día'),
          content: const Text('Mostrando las ventas realizadas en el día actual (simulado).'),
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

  void _mostrarReportePorRango() {
    final TextEditingController _fechaInicioController = TextEditingController();
    final TextEditingController _fechaFinController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Reporte por Rango'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _fechaInicioController,
                decoration: const InputDecoration(labelText: 'Fecha Inicio'),
              ),
              TextField(
                controller: _fechaFinController,
                decoration: const InputDecoration(labelText: 'Fecha Fin'),
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
                Navigator.of(context).pop();
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Reporte Generado'),
                      content: Text(
                          'Mostrando las ventas entre ${_fechaInicioController.text} y ${_fechaFinController.text} (simulado).'),
                      actions: [
                        ElevatedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Cerrar'),
                        ),
                      ],
                    );
                  },
                );
              },
              child: const Text('Generar'),
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
        title: const Text('Gestión de Ventas'),
        backgroundColor: Colors.orange.shade700,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Barra de búsqueda y opciones superiores
            Row(
              children: [
                Expanded(
                  flex: 4,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Buscar por ID o Concepto',
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
                const SizedBox(width: 16),
                PopupMenuButton<String>(
                  onSelected: (option) {
                    if (option == 'Corte de Caja') {
                      _mostrarCorteDeCaja();
                    } else if (option == 'Reporte del Día') {
                      _mostrarReporteDelDia();
                    } else if (option == 'Reporte por Rango') {
                      _mostrarReportePorRango();
                    }
                  },
                  icon: Icon(Icons.more_vert, size: 30, color: Colors.blue.shade600),
                  itemBuilder: (BuildContext context) {
                    return [
                      PopupMenuItem(
                        value: 'Corte de Caja',
                        child: Row(
                          children: [
                            Icon(Icons.receipt_long, color: Colors.green.shade600),
                            const SizedBox(width: 8),
                            const Text('Corte de Caja'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Reporte del Día',
                        child: Row(
                          children: [
                            Icon(Icons.today, color: Colors.blue.shade600),
                            const SizedBox(width: 8),
                            const Text('Reporte del Día'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'Reporte por Rango',
                        child: Row(
                          children: [
                            Icon(Icons.calendar_today, color: Colors.orange.shade600),
                            const SizedBox(width: 8),
                            const Text('Reporte por Rango'),
                          ],
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Lista de ventas
            Expanded(
              child: ListView.builder(
                itemCount: _paginatedVentas.length,
                itemBuilder: (context, index) {
                  final venta = _paginatedVentas[index];
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
                                'ID: ${venta['id']}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0,
                                  color: Colors.brown.shade700,
                                ),
                              ),
                              Text(
                                '\$${venta['total'].toStringAsFixed(2)}',
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
                            venta['concepto'],
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 16.0),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              _buildGradientButton(
                                text: "Editar",
                                icon: Icons.edit,
                                colors: [Colors.blue.shade300, Colors.blue.shade600],
                                onPressed: () => _mostrarFormulario(venta: venta),
                              ),
                              const SizedBox(width: 8),
                              _buildGradientButton(
                                text: "Eliminar",
                                icon: Icons.delete,
                                colors: [Colors.red.shade300, Colors.red.shade600],
                                onPressed: () => _eliminarVenta(venta),
                              ),
                              const SizedBox(width: 8),
                              PopupMenuButton<String>(
                                onSelected: (option) {
                                  if (option == 'Detalles') {
                                    print('Detalles seleccionados');
                                  } else if (option == 'Generar PDF') {
                                    print('Generar PDF seleccionado');
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
                      icon: Icon(Icons.chevron_left),
                    ),
                    Text('Página $_currentPage de ${(_ventas.length / _itemsPerPage).ceil()}'),
                    IconButton(
                      onPressed: _currentPage <
                          (_ventas.length / _itemsPerPage).ceil()
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

  Widget _buildGradientButton({
    required String text,
    required IconData icon,
    required List<Color> colors,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: colors,
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            offset: Offset(2, 4),
            blurRadius: 6,
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 16),
        label: Text(
          text,
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      ),
    );
  }
}
