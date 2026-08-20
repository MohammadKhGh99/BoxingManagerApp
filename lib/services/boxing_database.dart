import 'dart:io';

import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class BoxingDatabase {
  BoxingDatabase._();

  static final BoxingDatabase instance = BoxingDatabase._();
  static const MethodChannel _backupChannel =
      MethodChannel('boxing_coach_manager/backup_storage');

  static const _databaseName = 'boxing_coach_manager.db';
  Database? _database;
  String? _databasePath;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final databasesPath = await getDatabasesPath();
    _databasePath = p.join(databasesPath, _databaseName);
    _database = await openDatabase(
      _databasePath!,
      version: 3,
      onConfigure: (db) async {
        await db.execute('PRAGMA foreign_keys = ON');
      },
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return _database!;
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE participants (
        personalId TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        phone TEXT,
        age INTEGER,
        weightClass TEXT,
        paymentMethod TEXT,
        notes TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE sessions (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        sessionType TEXT,
        durationMinutes INTEGER,
        sessionDate TEXT NOT NULL,
        sessionTime TEXT NOT NULL,
        notes TEXT,
        createdAt TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE session_participants (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sessionId INTEGER NOT NULL,
        participantPersonalId TEXT NOT NULL,
        participantName TEXT NOT NULL,
        paid INTEGER NOT NULL DEFAULT 0,
        FOREIGN KEY(sessionId) REFERENCES sessions(id) ON DELETE CASCADE,
        FOREIGN KEY(participantPersonalId) REFERENCES participants(personalId)
          ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE attendance (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        participantPersonalId TEXT NOT NULL,
        participantName TEXT NOT NULL,
        sessionTitle TEXT NOT NULL,
        sessionDate TEXT NOT NULL,
        status TEXT NOT NULL,
        paymentStatus TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY(participantPersonalId) REFERENCES participants(personalId)
          ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE payments (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        participantPersonalId TEXT NOT NULL,
        participantName TEXT NOT NULL,
        amount REAL NOT NULL,
        description TEXT,
        method TEXT NOT NULL,
        status TEXT NOT NULL,
        createdAt TEXT NOT NULL,
        FOREIGN KEY(participantPersonalId) REFERENCES participants(personalId)
          ON DELETE CASCADE ON UPDATE CASCADE
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await _rebuildSchema(db);
    }
  }

  Future<void> _rebuildSchema(Database db) async {
    await db.execute('DROP TABLE IF EXISTS session_participants');
    await db.execute('DROP TABLE IF EXISTS attendance');
    await db.execute('DROP TABLE IF EXISTS payments');
    await db.execute('DROP TABLE IF EXISTS sessions');
    await db.execute('DROP TABLE IF EXISTS participants');
    await _onCreate(db, 3);
  }

  Future<void> _clearAllData(Database db) async {
    await db.delete('session_participants');
    await db.delete('attendance');
    await db.delete('payments');
    await db.delete('sessions');
    await db.delete('participants');
  }

  Future<int> addParticipant({
    required String personalId,
    required String name,
    required String phone,
    required int age,
    required String weightClass,
    required String paymentMethod,
    required String notes,
  }) async {
    final db = await database;
    final existing = await db.query(
      'participants',
      where: 'personalId = ?',
      whereArgs: [personalId],
      limit: 1,
    );
    if (existing.isNotEmpty) {
      throw Exception('A participant with this personal ID already exists.');
    }

    final participantId = await db.insert('participants', {
      'personalId': personalId,
      'name': name,
      'phone': phone,
      'age': age,
      'weightClass': weightClass,
      'paymentMethod': paymentMethod,
      'notes': notes,
      'createdAt': DateTime.now().toIso8601String(),
    });

    await addPendingPayment(
      participantPersonalId: personalId,
      participantName: name,
      amount: 0,
      description: 'Enrollment fee pending',
      method: paymentMethod,
    );

    return participantId;
  }

  Future<int> updateParticipant({
    required String personalId,
    required String name,
    required String phone,
    required int age,
    required String weightClass,
    required String paymentMethod,
    required String notes,
  }) async {
    final db = await database;
    return db.update(
      'participants',
      {
        'personalId': personalId,
        'name': name,
        'phone': phone,
        'age': age,
        'weightClass': weightClass,
        'paymentMethod': paymentMethod,
        'notes': notes,
      },
      where: 'personalId = ?',
      whereArgs: [personalId],
    );
  }

  Future<int> addSession({
    required String title,
    required String sessionType,
    required int durationMinutes,
    required String sessionDate,
    required String sessionTime,
  }) async {
    final db = await database;
    return db.insert('sessions', {
      'title': title,
      'sessionType': sessionType,
      'durationMinutes': durationMinutes,
      'sessionDate': sessionDate,
      'sessionTime': sessionTime,
      'notes': '',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<int> updateSession({
    required int id,
    required String title,
    required String sessionType,
    required int durationMinutes,
    required String sessionDate,
    required String sessionTime,
  }) async {
    final db = await database;
    return db.update(
      'sessions',
      {
        'title': title,
        'sessionType': sessionType,
        'durationMinutes': durationMinutes,
        'sessionDate': sessionDate,
        'sessionTime': sessionTime,
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> addPayment({
    required String participantPersonalId,
    required String participantName,
    required double amount,
    required String description,
    required String method,
    required String status,
  }) async {
    final db = await database;

    if (status == 'paid') {
      final pendingPayment = await db.query(
        'payments',
        where: 'participantPersonalId = ? AND status = ?',
        whereArgs: [participantPersonalId, 'pending'],
        orderBy: 'createdAt ASC, id ASC',
        limit: 1,
      );

      if (pendingPayment.isNotEmpty) {
        final paymentId = pendingPayment.first['id'] as int;
        return db.update(
          'payments',
          {
            'participantPersonalId': participantPersonalId,
            'participantName': participantName,
            'amount': amount,
            'description': description,
            'method': method,
            'status': 'paid',
            'createdAt': DateTime.now().toIso8601String(),
          },
          where: 'id = ?',
          whereArgs: [paymentId],
        );
      }
    }

    return db.insert('payments', {
      'participantPersonalId': participantPersonalId,
      'participantName': participantName,
      'amount': amount,
      'description': description,
      'method': method,
      'status': status,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<int> addPendingPayment({
    required String participantPersonalId,
    required String participantName,
    required double amount,
    required String description,
    required String method,
  }) async {
    final db = await database;
    return db.insert('payments', {
      'participantPersonalId': participantPersonalId,
      'participantName': participantName,
      'amount': amount,
      'description': description,
      'method': method,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<int> updatePaymentStatus({
    required int id,
    required String status,
  }) async {
    final db = await database;
    return db.update(
      'payments',
      {
        'status': status,
        'createdAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> updatePayment({
    required int id,
    required String participantPersonalId,
    required String participantName,
    required double amount,
    required String description,
    required String method,
    required String status,
  }) async {
    final db = await database;
    return db.update(
      'payments',
      {
        'participantPersonalId': participantPersonalId,
        'participantName': participantName,
        'amount': amount,
        'description': description,
        'method': method,
        'status': status,
        'createdAt': DateTime.now().toIso8601String(),
      },
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> addAttendance({
    required String participantPersonalId,
    required String participantName,
    required String sessionTitle,
    required String sessionDate,
    required String status,
    int? sessionId,
    required String paymentStatus,
  }) async {
    final db = await database;
    final insertedId = await db.insert('attendance', {
      'participantPersonalId': participantPersonalId,
      'participantName': participantName,
      'sessionTitle': sessionTitle,
      'sessionDate': sessionDate,
      'status': status,
      'paymentStatus': paymentStatus,
      'createdAt': DateTime.now().toIso8601String(),
    });

    // If we have a sessionId and the participant attended, ensure the
    // session_participants table contains an entry so session participant
    // counts reflect attendance in the Manage Data view.
    if (sessionId != null && status == 'attended') {
      final existing = await db.query(
        'session_participants',
        where: 'sessionId = ? AND participantPersonalId = ?',
        whereArgs: [sessionId, participantPersonalId],
        limit: 1,
      );
      if (existing.isEmpty) {
        await db.insert('session_participants', {
          'sessionId': sessionId,
          'participantPersonalId': participantPersonalId,
          'participantName': participantName,
          'paid': 0,
        });
      }
    }

    return insertedId;
  }

  Future<int> countParticipants() async {
    final db = await database;
    return Sqflite.firstIntValue(
          await db.rawQuery('SELECT COUNT(*) FROM participants'),
        ) ??
        0;
  }

  Future<int> countSessionsThisMonth() async {
    final db = await database;
    final monthKey = DateTime.now().toIso8601String().substring(0, 7);
    return Sqflite.firstIntValue(
          await db.rawQuery(
            'SELECT COUNT(*) FROM sessions WHERE sessionDate LIKE ?',
            ['$monthKey%'],
          ),
        ) ??
        0;
  }

  Future<double> revenueThisMonth() async {
    final db = await database;
    final monthKey = DateTime.now().toIso8601String().substring(0, 7);
    final result = await db.rawQuery(
      'SELECT COALESCE(SUM(amount), 0) AS total FROM payments WHERE status = ? AND createdAt LIKE ?',
      ['paid', '$monthKey%'],
    );
    return (result.first['total'] as num?)?.toDouble() ?? 0;
  }

  Future<double> attendanceRate() async {
    final db = await database;
    final result = await db.rawQuery('''
      SELECT
        SUM(CASE WHEN status = 'attended' THEN 1 ELSE 0 END) AS attended,
        COUNT(*) AS total
      FROM attendance
    ''');
    final attended = (result.first['attended'] as num?)?.toDouble() ?? 0;
    final total = (result.first['total'] as num?)?.toDouble() ?? 0;
    if (total == 0) {
      return 0;
    }
    return (attended / total) * 100;
  }

  Future<Map<String, dynamic>?> todaySession() async {
    final db = await database;
    final today = _formatDate(DateTime.now());
    final rows = await db.query(
      'sessions',
      where: 'sessionDate = ?',
      whereArgs: [today],
      orderBy: 'sessionTime ASC',
      limit: 1,
    );
    if (rows.isNotEmpty) {
      return rows.first;
    }
    // Only return a session if it occurs today. Do not fall back to the
    // most-recent session on other dates.
    return null;
  }

  Future<List<Map<String, dynamic>>> todaySessionParticipants(
      int sessionId) async {
    final db = await database;
    return db.query(
      'session_participants',
      where: 'sessionId = ?',
      whereArgs: [sessionId],
      orderBy: 'participantPersonalId ASC, id ASC',
    );
  }

  Future<List<Map<String, dynamic>>> allParticipants() async {
    final db = await database;
    return db.query(
      'participants',
      orderBy: 'personalId ASC',
    );
  }

  Future<List<Map<String, dynamic>>> allSessions() async {
    final db = await database;
    final sessions = await db.rawQuery(
      '''
      SELECT
        s.id,
        s.title,
        s.sessionDate,
        s.sessionTime,
        s.sessionType,
        s.durationMinutes,
        s.notes,
        COALESCE(COUNT(sp.id), 0) AS participantsCount
      FROM sessions s
      LEFT JOIN session_participants sp ON sp.sessionId = s.id
      GROUP BY s.id
      ORDER BY s.sessionDate ASC, s.sessionTime ASC, s.id ASC
      ''',
    );
    final sessionParticipants = await db.query(
      'session_participants',
      columns: ['sessionId', 'participantName'],
      orderBy: 'sessionId ASC, participantPersonalId ASC, id ASC',
    );
    final attendedBySession = <int, List<String>>{};
    for (final participant in sessionParticipants) {
      final sessionId = (participant['sessionId'] as num).toInt();
      attendedBySession
          .putIfAbsent(sessionId, () => <String>[])
          .add(participant['participantName']?.toString() ?? '');
    }

    return sessions.map((session) {
      final sessionId = (session['id'] as num).toInt();
      return {
        ...session,
        'attendedParticipants': attendedBySession[sessionId] ?? <String>[],
      };
    }).toList();
  }

  Future<List<Map<String, dynamic>>> recentAttendance({int limit = 5}) async {
    final db = await database;
    return db.query(
      'attendance',
      orderBy: 'createdAt DESC, id DESC',
      limit: limit,
    );
  }

  Future<List<Map<String, dynamic>>> upcomingSessions({int limit = 4}) async {
    final db = await database;
    final today = _formatDate(DateTime.now());
    final rows = await db.rawQuery(
      '''
      SELECT
        s.id,
        s.title,
        s.sessionDate,
        s.sessionTime,
        s.sessionType,
        s.durationMinutes,
        COALESCE(COUNT(sp.id), 0) AS participantsCount
      FROM sessions s
      LEFT JOIN session_participants sp ON sp.sessionId = s.id
      WHERE s.sessionDate >= ?
      GROUP BY s.id
      ORDER BY s.sessionDate ASC, s.sessionTime ASC
      ''',
      [today],
    );

    final now = DateTime.now();
    final upcomingRows = rows.where((row) {
      final sessionDateTime = _parseSessionDateTime(row);
      return sessionDateTime != null && !sessionDateTime.isBefore(now);
    }).toList()
      ..sort((a, b) {
        final aDateTime = _parseSessionDateTime(a);
        final bDateTime = _parseSessionDateTime(b);

        if (aDateTime == null && bDateTime == null) {
          return 0;
        }
        if (aDateTime == null) {
          return 1;
        }
        if (bDateTime == null) {
          return -1;
        }
        return aDateTime.compareTo(bDateTime);
      });

    return upcomingRows.take(limit).toList();
  }

  Future<List<Map<String, dynamic>>> pendingPayments({int limit = 3}) async {
    final db = await database;
    return db.query(
      'payments',
      where: 'status = ?',
      whereArgs: ['pending'],
      orderBy: 'createdAt DESC, id DESC',
      limit: limit,
    );
  }

  Future<List<Map<String, dynamic>>> allPayments() async {
    final db = await database;
    return db.query(
      'payments',
      orderBy: 'createdAt DESC, id DESC',
    );
  }

  Future<List<String>> participantNames() async {
    final db = await database;
    final rows = await db.rawQuery(
      '''
      SELECT DISTINCT TRIM(name) AS name
      FROM participants
      WHERE TRIM(name) <> ''
      ORDER BY name COLLATE NOCASE ASC
      ''',
    );
    return rows
        .map((row) => row['name']?.toString())
        .whereType<String>()
        .where((name) => name.isNotEmpty)
        .toList();
  }

  Future<File> createBackup() async {
    final db = await database;
    await _checkpointDatabase(db);
    final sourcePath = _databasePath ?? db.path;
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .replaceAll('.', '-');
    final backupFileName = 'boxing_coach_manager_backup_$timestamp.db';

    if (Platform.isAndroid) {
      final savedPath = await _backupChannel.invokeMethod<String>(
        'saveBackup',
        {
          'sourcePath': sourcePath,
          'fileName': backupFileName,
          'subDir': 'BoxingManager',
        },
      );

      if (savedPath == null || savedPath.isEmpty) {
        throw Exception('Unable to save backup to public storage');
      }

      return File(savedPath);
    }

    final appDocumentsDir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(appDocumentsDir.path, 'backups'));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    final backupFile = File(p.join(backupDir.path, backupFileName));
    return File(sourcePath).copy(backupFile.path);
  }

  Future<void> restoreBackup(File backupFile) async {
    if (!await backupFile.exists()) {
      throw Exception('Backup file does not exist.');
    }

    final databasesPath = await getDatabasesPath();
    final targetPath = p.join(databasesPath, _databaseName);
    final temporaryPath = '$targetPath.restore';

    await _database?.close();
    _database = null;
    _databasePath = targetPath;

    final temporaryFile = File(temporaryPath);
    if (await temporaryFile.exists()) {
      await temporaryFile.delete();
    }
    await backupFile.copy(temporaryPath);

    final restoredDatabase = await openDatabase(
      temporaryPath,
      readOnly: true,
      version: 3,
    );
    await restoredDatabase.close();

    final targetFile = File(targetPath);
    if (await targetFile.exists()) {
      await targetFile.delete();
    }
    await temporaryFile.rename(targetPath);
  }

  Future<void> _checkpointDatabase(Database db) async {
    try {
      await db.rawQuery('PRAGMA wal_checkpoint(FULL)');
    } catch (_) {
      // Some SQLite configurations do not use WAL; in that case there is nothing to checkpoint.
    }
  }

  String _formatDate(DateTime dateTime) {
    return '${dateTime.year.toString().padLeft(4, '0')}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }

  DateTime? _parseSessionDateTime(Map<String, Object?> row) {
    final sessionDateText = row['sessionDate']?.toString().trim();
    final sessionTimeText = row['sessionTime']?.toString().trim();

    if (sessionDateText == null ||
        sessionDateText.isEmpty ||
        sessionTimeText == null ||
        sessionTimeText.isEmpty) {
      return null;
    }

    final sessionDate = DateTime.tryParse(sessionDateText);
    if (sessionDate == null) {
      return null;
    }

    final parsedTime = _parseSessionTime(sessionTimeText);
    if (parsedTime == null) {
      return null;
    }

    return DateTime(
      sessionDate.year,
      sessionDate.month,
      sessionDate.day,
      parsedTime.hour,
      parsedTime.minute,
    );
  }

  DateTime? _parseSessionTime(String sessionTimeText) {
    final candidateFormats = [
      DateFormat.jm(),
      DateFormat.Hm(),
      DateFormat('h:mm a'),
      DateFormat('hh:mm a'),
    ];

    for (final format in candidateFormats) {
      try {
        return format.parseStrict(sessionTimeText);
      } catch (_) {
        // Try the next known time format.
      }
    }

    return null;
  }
}
