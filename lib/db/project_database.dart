import 'package:flutter/material.dart';
import 'package:row_counter_app/model/project.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:path/path.dart';

class ProjectDatabase {
  static final ProjectDatabase instance = ProjectDatabase._init();

  static Database? _database;

  ProjectDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDB('project.db');
    return _database!;
  }

  Future<Database> _initDB(String filepath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filepath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

//this is executed only when project.db is not in the file system
  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER NOT NULL PRIMARY KEY';
    const textType = 'TEXT NOT NULL';
    const integerType = 'INTEGER NOT NULL';
//define structure of the table
//put column names as well as types
    await db.execute('''
      CREATE TABLE $tableProjects (
        ${ProjectFields.id} $idType,
        ${ProjectFields.title} $textType,
        ${ProjectFields.numOfRow} $integerType
        )
  ''');
  }

  Future<Project> create(Project project) async {
    final db = await instance.database;
    final id = await db.insert(tableProjects, project.toJSON());
    return project.copy(id: id);
  }

  Future<Project> readProject(int id) async {
    final db = await instance.database;
    final maps = await db.query(tableProjects,
        columns: ProjectFields.values,
        where: '${ProjectFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Project.fromJSON(maps.first);
    } else {
      throw Exception('Project $id not found');
    }
  }

  Future<List<Project>> readAllProjects() async {
    final db = await instance.database;
    final result = await db.query(tableProjects);
    return result.map((json) => Project.fromJSON(json)).toList();
  }

  Future<int> update(Project project) async {
    final db = await instance.database;

    return db.update(
      tableProjects,
      project.toJSON(),
      where: '${ProjectFields.id} = ?',
      whereArgs: [project.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db.delete(
      tableProjects,
      where: '${ProjectFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;

    db.close();
  }
}
