import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../../features/customer/data/models/customer.dart';
import '../../features/customer/data/models/pending_operation.dart';

@lazySingleton
class SqfLiteService {
  SqfLiteService();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await _initDatabase();
    
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = join(directory.path, 'app.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    // Customers table
    await db.execute('''
      CREATE TABLE customers (
        id INTEGER PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT NOT NULL,
        email TEXT,
        address TEXT,
        last_visit_date TEXT,
        visit_status TEXT,
        notes TEXT,
        created_at TEXT
      )
    ''');

    // Pending operations table
    await db.execute('''
      CREATE TABLE pending_operations (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        entity_type TEXT NOT NULL,
        entity_id INTEGER NOT NULL,
        operation_type TEXT NOT NULL,
        payload TEXT NOT NULL,
        retry_count INTEGER DEFAULT 0,
        created_at TEXT NOT NULL,
        last_attempt_at TEXT,
        status TEXT DEFAULT 'pending'
      )
    ''');
  }

  // Customer CRUD
  Future<int> insertCustomer(Customer customer) async {
    final db = await database;
    return await db.insert('customers', {
      'id': customer.id,
      'name': customer.name,
      'phone': customer.phone,
      'email': customer.email,
      'address': customer.address,
      'last_visit_date': customer.lastVisitDate,
      'visit_status': customer.visitStatus,
      'notes': customer.notes,
      'created_at': DateTime.now().toIso8601String(),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateCustomer(Customer customer) async {
    final db = await database;
    return await db.update(
      'customers',
      {
        'name': customer.name,
        'phone': customer.phone,
        'email': customer.email,
        'address': customer.address,
        'last_visit_date': customer.lastVisitDate,
        'visit_status': customer.visitStatus,
        'notes': customer.notes,
      },
      where: 'id = ?',
      whereArgs: [customer.id],
    );
  }

  Future<List<Customer>> getAllCustomers() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'customers',
      orderBy: 'name ASC',
    );
    return maps
        .map(
          (map) => Customer(
            id: map['id'],
            name: map['name'],
            phone: map['phone'],
            email: map['email'] ?? '',
            address: map['address'] ?? '',
            lastVisitDate: map['last_visit_date'] ?? '',
            visitStatus: map['visit_status'] ?? 'Pending',
            notes: map['notes'] ?? '',
          ),
        )
        .toList();
  }

  Future<Customer?> getCustomerById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'customers',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      final map = maps.first;
      return Customer(
        id: map['id'],
        name: map['name'],
        phone: map['phone'],
        email: map['email'] ?? '',
        address: map['address'] ?? '',
        lastVisitDate: map['last_visit_date'] ?? '',
        visitStatus: map['visit_status'] ?? 'Pending',
        notes: map['notes'] ?? '',
      );
    }
    return null;
  }

  Future<void> deleteCustomer(int id) async {
    final db = await database;
    await db.delete('customers', where: 'id = ?', whereArgs: [id]);
  }

  // Pending Operations
  Future<int> insertPendingOperation(PendingOperation operation) async {
    final db = await database;
    return await db.insert('pending_operations', {
      'entity_type': operation.entityType,
      'entity_id': operation.entityId,
      'operation_type': operation.operationType,
      'payload': operation.payload,
      'retry_count': operation.retryCount,
      'created_at': operation.createdAt.toIso8601String(),
      'last_attempt_at': operation.lastAttemptAt?.toIso8601String(),
      'status': operation.status,
    });
  }

  Future<List<PendingOperation>> getPendingOperations() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'pending_operations',
      where: "status = 'pending' OR status = 'failed'",
      orderBy: 'created_at ASC',
    );
    return maps
        .map(
          (map) => PendingOperation(
            id: map['id'],
            entityType: map['entity_type'],
            entityId: map['entity_id'],
            operationType: map['operation_type'],
            payload: map['payload'],
            retryCount: map['retry_count'],
            createdAt: DateTime.parse(map['created_at']),
            lastAttemptAt: map['last_attempt_at'] != null
                ? DateTime.parse(map['last_attempt_at'])
                : null,
            status: map['status'],
          ),
        )
        .toList();
  }

  Future<int> updatePendingOperation(PendingOperation operation) async {
    final db = await database;
    return await db.update(
      'pending_operations',
      {
        'retry_count': operation.retryCount,
        'last_attempt_at': operation.lastAttemptAt?.toIso8601String(),
        'status': operation.status,
      },
      where: 'id = ?',
      whereArgs: [operation.id],
    );
  }

  Future<void> deletePendingOperation(int id) async {
    final db = await database;
    await db.delete('pending_operations', where: 'id = ?', whereArgs: [id]);
  }

  Future<bool> hasPendingOperationsForEntity(
    String entityType,
    int entityId,
  ) async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'pending_operations',
      where:
          "entity_type = ? AND entity_id = ? AND (status = 'pending' OR status = 'failed')",
      whereArgs: [entityType, entityId],
    );
    return result.isNotEmpty;
  }

  Future<int> getPendingOperationsCount() async {
    final db = await database;
    final List<Map<String, dynamic>> result = await db.rawQuery(
      "SELECT COUNT(*) as count FROM pending_operations WHERE status = 'pending' OR status = 'failed'",
    );
    return result.first['count'] as int;
  }
}
