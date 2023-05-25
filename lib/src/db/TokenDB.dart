import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class TokenDatabase {
  static final TokenDatabase instance = TokenDatabase._init();

  static Database? _database;

  TokenDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tokens.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE tokens (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        token TEXT
      )
    ''');
  }

  Future<void> saveToken(String token) async {
    final db = await instance.database;
    await db.insert('tokens', {'token': token});
  }

  Future<String?> getToken() async {
    final db = await instance.database;
    final maps = await db.query('tokens', orderBy: 'id DESC', limit: 1);
    if (maps.isNotEmpty) {
      return maps.first['token'] as String?;
    }
    return null;
  }
}
