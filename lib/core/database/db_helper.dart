import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../../features/mail/data/models/email_model.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  static Database? _database;

  factory DbHelper() => _instance;

  DbHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    String path = join(await getDatabasesPath(), 'snaarp_mail_v3.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    // We use a single table with an isDeleted flag for simplicity and efficiency
    await db.execute('''
      CREATE TABLE emails (
        id TEXT PRIMARY KEY,
        sender TEXT,
        senderEmail TEXT,
        subject TEXT,
        body TEXT,
        category TEXT,
        timestamp TEXT,
        isRead INTEGER,
        isStarred INTEGER,
        isDeleted INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> insertEmail(EmailModel email) async {
    final db = await database;
    await db.insert(
      'emails',
      email.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> markAsDeleted(String id) async {
    final db = await database;
    await db.update(
      'emails',
      {'isDeleted': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> updateEmailReadStatus(String id, bool isRead) async {
    final db = await database;
    await db.update(
      'emails',
      {'isRead': isRead ? 1 : 0},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<EmailModel?> getEmailById(String id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'emails',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) return EmailModel.fromJson(maps.first);
    return null;
  }

  Future<List<EmailModel>> getEmailsByFolder(String folder) async {
    final db = await database;
    String? whereClause;
    List<dynamic>? whereArgs;

    if (folder == 'Sent') {
      whereClause = 'category = ? AND isDeleted = 0';
      whereArgs = ['Sent'];
    } else if (folder == 'Bin') {
      whereClause = 'isDeleted = 1';
    }

    final List<Map<String, dynamic>> maps = await db.query(
      'emails',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'timestamp DESC',
    );

    return List.generate(maps.length, (i) {
      return EmailModel.fromJson(maps[i]);
    });
  }
}
