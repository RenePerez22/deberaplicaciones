import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await _initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'computadoras.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(''' 
        Create table computadoras(
        id integer primary key,
        tipo text,
        marca text,
        cpu text,
        ram text,
        hdd text 
        )
        ''');
      },
    );
  }
  //CRUD

  //CREAR
  Future<int> insertarComputadora(Map<String, dynamic> computadora) async {
    final dbCliente = await db;
    return await dbCliente.insert('computadoras', computadora);
  }

  //LEER
  Future<List<Map<String, dynamic>>> getComputadoras() async {
    final dbCliente = await db;
    return await dbCliente.query('computadoras');
  }

  //ACTUALIZAR
  Future<int> upComputadora(Map<String, dynamic> computadora) async {
    final dbCliente = await db;
    return await dbCliente.update(
      'computadoras',
      computadora,
      where: 'id = ?',
      whereArgs: [computadora['id']],
    );
  }

  //ELIMINAR
  Future<int> delComputadoras(int id) async {
    final dbCliente = await db;
    return await dbCliente.delete(
      'computadoras',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
