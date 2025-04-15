import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/medicine.dart';
import '../models/medicine_info.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;
  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('medicine.db');
    return _database!;
  }

  Future<Database> _initDB(String fileName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, fileName);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('''
          CREATE TABLE IF NOT EXISTS medicine_info (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            name TEXT NOT NULL,
            imagePath TEXT,
            form TEXT,
            dosage TEXT,
            usage TEXT,
            sideEffects TEXT,
            warnings TEXT
          )
        ''');
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE medicines (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        dose INTEGER NOT NULL,
        time TEXT NOT NULL,
        date TEXT NOT NULL,
        imagePath TEXT
      )
    ''');

    await db.execute('''
      CREATE TABLE medicine_info (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        imagePath TEXT,
        form TEXT,
        dosage TEXT,
        usage TEXT,
        sideEffects TEXT,
        warnings TEXT
      )
    ''');

    await db.insert('medicine_info', {
      'name': 'Aspirin',
      'imagePath': null,
      'form': 'Tablet',
      'dosage': '500 mg',
      'usage': 'รับประทาน 1 เม็ดหลังอาหาร',
      'sideEffects': 'อาจทำให้ปวดท้องหรือระคายเคือง',
      'warnings': 'หลีกเลี่ยงในผู้ป่วยที่มีปัญหาเกี่ยวกับกระเพาะอาหาร'
    });

    await db.insert('medicine_info', {
      'name': 'Paracetamol',
      'imagePath': null,
      'form': 'Tablet',
      'dosage': '500 mg',
      'usage': 'รับประทานเมื่อมีไข้หรือปวดศีรษะ',
      'sideEffects': 'อาจมีผลต่อตับหากใช้เกินขนาด',
      'warnings': 'ไม่ควรใช้เกิน 4 กรัมต่อวัน'
    });
    
    await db.insert('medicine_info', {
      'name': 'Ibuprofen',
      'imagePath': null,
      'form': 'Tablet',
      'dosage': '400 mg',
      'usage': 'รับประทานเมื่อมีอาการปวดหรืออักเสบ',
      'sideEffects': 'อาจทำให้ปวดท้องหรือระคายเคือง',
      'warnings': 'หลีกเลี่ยงในผู้ป่วยที่มีปัญหาเกี่ยวกับไต'
    });
  }

  Future<int> insertMedicine(Medicine medicine) async {
    final db = await instance.database;
    return await db.insert('medicines', medicine.toMap());
  }

  Future<List<Medicine>> getAllMedicines() async {
    final db = await instance.database;
    final result = await db.query('medicines');
    return result.map((map) => Medicine.fromMap(map)).toList();
  }

  Future<List<Medicine>> getMedicinesByDate(String date) async {
    final db = await instance.database;
    final result = await db.query(
      'medicines',
      where: 'date = ?',
      whereArgs: [date],
    );
    return result.map((map) => Medicine.fromMap(map)).toList();
  }

  Future<int> updateMedicine(Medicine medicine) async {
    final db = await instance.database;
    return await db.update(
      'medicines',
      medicine.toMap(),
      where: 'id = ?',
      whereArgs: [medicine.id],
    );
  }

  Future<int> deleteMedicine(int id) async {
    final db = await instance.database;
    return await db.delete('medicines', where: 'id = ?', whereArgs: [id]);
  }

  Future<int> deleteAllMedicines() async {
    final db = await instance.database;
    return await db.delete('medicines');
  }

  Future<List<MedicineInfo>> searchMedicineInfoByName(String keyword) async {
    final db = await instance.database;
    try {
      final result = await db.query(
        'medicine_info',
        where: 'LOWER(name) LIKE ?',
        whereArgs: ['%$keyword%'],
      );
      print("✅ Found: ${result.length} items");
      return result.map((e) => MedicineInfo.fromMap(e)).toList();
    } catch (e) {
      print("❌ DB query error: $e");
      return [];
    }
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}