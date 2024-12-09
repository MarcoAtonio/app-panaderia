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


  List<Map<String, dynamic>> _filteredVentas = []; // Lista para ventas filtradas
  final TextEditingController _searchController = TextEditingController();
  int _currentPage = 1;
  int _itemsPerPage = 3;

  @override
  void initState() {
    super.initState();
    _filteredVentas = _ventas; // Inicializamos la lista filtrada con todas las ventas
    _searchController.addListener(_filterVentas); // Agregamos el listener para la búsqueda
  }

  // Filtra las ventas según el texto de búsqueda
  void _filterVentas() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredVentas = _ventas.where((venta) {
        return venta['concepto'].toLowerCase().contains(query) ||
            venta['id'].toString().contains(query);
      }).toList();
    });
  }

  // Obtener ventas paginadas
  List<Map<String, dynamic>> get _paginatedVentas {
    final startIndex = (_currentPage - 1) * _itemsPerPage;
    final endIndex = startIndex + _itemsPerPage;
    return _filteredVentas.sublist(
        startIndex, endIndex > _filteredVentas.length ? _filteredVentas.length : endIndex);
  }


  void _mostrarFormulario({Map<String, dynamic>? venta}) {
    final TextEditingController _descripcionController = TextEditingController();
    final TextEditingController _cantidadController = TextEditingController();
    final TextEditingController _reciboController = TextEditingController();
    double _cambio = 0.0;

    // Simulación de productos para el dropdown
    final List<Map<String, dynamic>> _productos = [
      {"nombre": "Pan Tostado", "precio": 225.0, "stock": 100},
      {"nombre": "Leche Entera", "precio": 50.0, "stock": 200},
    ];
    String? _productoSeleccionado;
    List<Map<String, dynamic>> _detalleVenta = [];

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: StatefulBuilder(
            builder: (context, setState) {
              double _calcularTotal() {
                return _detalleVenta.fold(
                    0, (sum, item) => sum + (item['cantidad'] * item['precio']));
              }

              return GestureDetector(
                onTap: () => FocusScope.of(context).unfocus(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.8, // Tamaño fijo
                  padding: const EdgeInsets.all(20),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Detalles de la Venta",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.brown,
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Campo de descripción
                        TextField(
                          controller: _descripcionController,
                          decoration: const InputDecoration(
                            labelText: "Descripción",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Campo Producto
                        DropdownButtonFormField<String>(
                          value: _productoSeleccionado,
                          items: _productos
                              .map((producto) => DropdownMenuItem<String>(
                            value: producto['nombre'],
                            child: Text(
                              "${producto['nombre']} - \$${producto['precio']} - ${producto['stock']} Existe",
                            ),
                          ))
                              .toList(),
                          onChanged: (value) {
                            setState(() {
                              _productoSeleccionado = value;
                            });
                          },
                          decoration: const InputDecoration(
                            labelText: "Producto",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Campo Cantidad
                        TextField(
                          controller: _cantidadController,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            labelText: "Cantidad",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Botón Agregar
                        ElevatedButton(
                          onPressed: () {
                            if (_productoSeleccionado != null &&
                                _cantidadController.text.isNotEmpty) {
                              final cantidad =
                                  int.tryParse(_cantidadController.text) ?? 0;
                              final producto = _productos.firstWhere(
                                      (p) => p['nombre'] == _productoSeleccionado);

                              if (cantidad > producto['stock']) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Cantidad excede el stock disponible (${producto['stock']})'),
                                    backgroundColor: Colors.red,
                                  ),
                                );
                                return;
                              }

                              setState(() {
                                _detalleVenta.add({
                                  "producto": producto['nombre'],
                                  "cantidad": cantidad,
                                  "precio": producto['precio'],
                                  "subtotal": cantidad * producto['precio'],
                                });
                                _cantidadController.clear();
                                _productoSeleccionado = null;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                          ),
                          child: const Text("Agregar"),
                        ),
                        const SizedBox(height: 16),
                        // Tabla de detalle de venta
                        ListView(
                          shrinkWrap: true,
                          children: _detalleVenta.map((item) {
                            return ListTile(
                              title: Text(item['producto']),
                              subtitle: Text(
                                  "Cantidad: ${item['cantidad']}, Precio Unitario: \$${item['precio']}, Subtotal: \$${item['subtotal']}"),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  setState(() {
                                    _detalleVenta.remove(item);
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 16),
                        // Total
                        Text(
                          "Total: \$${_calcularTotal().toStringAsFixed(2)}",
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        // Campos Recibo y Cambio
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _reciboController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Recibo",
                                  border: OutlineInputBorder(),
                                ),
                                onChanged: (value) {
                                  final recibo = double.tryParse(value) ?? 0;
                                  setState(() {
                                    _cambio = recibo - _calcularTotal();
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextField(
                                readOnly: true,
                                decoration: InputDecoration(
                                  labelText: "Cambio",
                                  border: const OutlineInputBorder(),
                                  hintText: "\$${_cambio.toStringAsFixed(2)}",
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Botones Guardar y Cancelar
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text("Cancelar"),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                // Validar campos antes de guardar
                                if (_detalleVenta.isNotEmpty && _descripcionController.text.isNotEmpty) {
                                  setState(() {
                                    // Agregar los detalles de la venta a la lista principal
                                    final nuevaVenta = {
                                      "id": _ventas.isNotEmpty ? _ventas.last['id'] + 1 : 1,
                                      "concepto": _descripcionController.text,
                                      "total": _detalleVenta.fold<double>(
                                        0.0,
                                            (double sum, Map<String, dynamic> item) =>
                                        sum + (item['cantidad'] * item['precio']),
                                      ),
                                    };
                                    _ventas.add(nuevaVenta);
                                    _filteredVentas = _ventas; // Actualizar lista filtrada
                                  });

                                  // Mostrar un mensaje de éxito
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Venta guardada correctamente'),
                                      backgroundColor: Colors.green,
                                    ),
                                  );

                                  // Cerrar el modal
                                  Navigator.of(context).pop();
                                } else {
                                  // Mostrar un mensaje si faltan datos
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Por favor, completa todos los campos antes de guardar.'),
                                      backgroundColor: Colors.red,
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                              ),
                              child: const Text("Guardar Venta"),
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
  void _mostrarDetallesVenta(Map<String, dynamic> venta) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Detalles de la Venta",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.brown,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "ID:",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${venta['id']}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Concepto:",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${venta['concepto']}",
                      style: const TextStyle(fontSize: 18),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Total:",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "\$${venta['total'].toStringAsFixed(2)}",
                      style: const TextStyle(fontSize: 18, color: Colors.green),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  ),
                  child: const Text(
                    "Cerrar",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
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
          backgroundColor: Color(0xFFF4A259),
          elevation: 5,
          foregroundColor: Colors.white,

    ),
    body: Container(
    decoration: BoxDecoration(
    image: DecorationImage(
    image: AssetImage("assets/images/Fondosregistros.png"), // Imagen de fondo local
    fit: BoxFit.cover,
    colorFilter: ColorFilter.mode(
    Colors.black.withOpacity(0.3), // Efecto de oscuridad sobre el fondo
    BlendMode.darken,
    ),
    ),
    ),
    child: Padding(
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
            filled: true,  // Agrega esta línea para permitir el fondo
            fillColor: Colors.white,  // Color blanco de fondo
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
            contentPadding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
