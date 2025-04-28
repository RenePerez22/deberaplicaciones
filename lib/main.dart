import 'package:flutter/material.dart';
import 'database/database_helper.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(title: 'COMPUTADORAS', home: HomePage());
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final TextEditingController _tipoController = TextEditingController();
  final TextEditingController _marcaController = TextEditingController();
  final TextEditingController _cpuController = TextEditingController();
  final TextEditingController _ramController = TextEditingController();
  final TextEditingController _hddController = TextEditingController();

  List<Map<String, dynamic>> _computadoras = [];

  @override
  void initState() {
    super.initState();
    _actualizarComputadoras();
  }

  void _actualizarComputadoras() async {
    final data = await _dbHelper.getComputadoras();
    setState(() {
      _computadoras = data;
    });
  }

  void _addComputadora() async {
    await _dbHelper.insertarComputadora({
      'tipo': _tipoController.text,
      'marca': _marcaController.text,
      'cpu': _cpuController.text,
      'ram': _ramController.text,
      'hdd': _hddController.text,
    });
    _actualizarComputadoras();
    _clearFields();
  }

  void _editarComputadora(Map<String, dynamic> computadora) {
    // Cargar los datos actuales en los controladores
    _tipoController.text = computadora['tipo'];
    _marcaController.text = computadora['marca'];
    _cpuController.text = computadora['cpu'];
    _ramController.text = computadora['ram'];
    _hddController.text = computadora['hdd'];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Editar Computadora'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _tipoController,
                  decoration: InputDecoration(labelText: 'Tipo'),
                ),
                TextField(
                  controller: _marcaController,
                  decoration: InputDecoration(labelText: 'Marca'),
                ),
                TextField(
                  controller: _cpuController,
                  decoration: InputDecoration(labelText: 'CPU'),
                ),
                TextField(
                  controller: _ramController,
                  decoration: InputDecoration(labelText: 'RAM'),
                ),
                TextField(
                  controller: _hddController,
                  decoration: InputDecoration(labelText: 'HDD'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                _actualizarComputadora(computadora['id']);
                Navigator.pop(context);
              },
              child: Text('Guardar'),
            ),
          ],
        );
      },
    );
  }

  void _actualizarComputadora(int id) async {
    await _dbHelper.upComputadora({
      'id': id,
      'tipo': _tipoController.text,
      'marca': _marcaController.text,
      'cpu': _cpuController.text,
      'ram': _ramController.text,
      'hdd': _hddController.text,
    });
    _actualizarComputadoras(); // Recargar la lista
    _clearFields(); // Limpiar los campos del formulario
  }

  void _deleteComputadora(int id) async {
    await _dbHelper.delComputadoras(id);
    _actualizarComputadoras(); // Recargar la lista
  }

  void _clearFields() {
    _tipoController.clear();
    _marcaController.clear();
    _cpuController.clear();
    _ramController.clear();
    _hddController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text('COMPUTADORAS'),
        backgroundColor: const Color.fromARGB(255, 60, 58, 120),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: _tipoController,
                  decoration: InputDecoration(labelText: 'Tipo'),
                ),
                TextField(
                  controller: _marcaController,
                  decoration: InputDecoration(labelText: 'Marca'),
                ),
                TextField(
                  controller: _cpuController,
                  decoration: InputDecoration(labelText: 'CPU'),
                ),
                TextField(
                  controller: _ramController,
                  decoration: InputDecoration(labelText: 'RAM'),
                ),
                TextField(
                  controller: _hddController,
                  decoration: InputDecoration(labelText: 'HDD'),
                ),
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: _addComputadora,
                  child: Text('Agregar Computadora'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _computadoras.length,
              itemBuilder: (context, index) {
                final computadora = _computadoras[index];
                return ListTile(
                  title: Text(
                    '${computadora['marca']} (${computadora['tipo']})',
                  ),
                  subtitle: Text(
                    'CPU: ${computadora['cpu']} | RAM: ${computadora['ram']} | HDD: ${computadora['hdd']}',
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          _editarComputadora(computadora);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          _deleteComputadora(computadora['id']);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
