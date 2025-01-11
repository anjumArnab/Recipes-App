import 'package:company_app/model/company_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  // Private constructor to prevent instantiation
  DatabaseHelper._privateConstructor();

  // Singleton instance of DatabaseHelper
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Open or create the database
  static Future<Database> _openDatabase() async {
    // Get the directory for storing the database
    final directory = await getApplicationCacheDirectory();
    final dbPath = join(directory.path, 'company_database.db');

    return openDatabase(
      dbPath,
      onCreate: (db, version) async {
        // Call _createDB to handle database table creation
        await _createDB(db);
      },
      version: 1,
    );
  }

  // Function to create the database table
  static Future<void> _createDB(Database db) async {
    // Define column variables
    String logo = 'logo';
    String companyName = 'company_name';
    String companyNumber = 'company_number';
    String companyAddress = 'company_address';

    // Create companies table using variables
    await db.execute('''
      CREATE TABLE companies(
        id INTEGER PRIMARY KEY,
        $logo TEXT,
        $companyName TEXT,
        $companyNumber TEXT,
        $companyAddress TEXT
      )
    ''');
  }

  // Insert a company into the database
  Future<void> insertCompany(Company company) async {
    final Database db = await _openDatabase();
   await db.insert(
      'companies',
      company.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }

  // Fetch all companies from the database
  Future<List<Company>> fetchAllCompanies() async {
    final Database db = await _openDatabase();
    final List<Map<String, dynamic>> maps = await db.query('companies');

    return List.generate(maps.length, (i) {
      return Company.fromJson(maps[i]);
    });
  }

  // Update an existing company
  Future<void> updateCompany(Company company) async {
    final Database db = await _openDatabase();
    await db.update(
      'companies',
      company.toJson(),
      where: 'id = ?',
      whereArgs: [company.id],
    );
  }

  // Delete a company by its ID
  Future<void> deleteCompany(int id) async {
    final Database db = await _openDatabase();
    await db.delete(
      'companies',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
