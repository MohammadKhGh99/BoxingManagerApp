import 'dart:io';

import 'package:flutter/material.dart';
import 'package:boxing_coach_manager/services/boxing_database.dart';

class AppDataProvider extends ChangeNotifier {
  final BoxingDatabase _database = BoxingDatabase.instance;

  bool _isLoading = true;
  int totalParticipants = 0;
  int sessionsThisMonth = 0;
  double revenueThisMonth = 0;
  double attendanceRate = 0;
  Map<String, dynamic>? todaySession;
  List<Map<String, dynamic>> todaySessionParticipants = [];
  List<Map<String, dynamic>> recentAttendance = [];
  List<Map<String, dynamic>> upcomingSessions = [];
  List<Map<String, dynamic>> pendingPayments = [];
  List<String> participantNames = [];
  String? lastBackupPath;

  bool get isLoading => _isLoading;

  Future<void> initialize() async {
    await refresh();
  }

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();

    final results = await Future.wait([
      _database.countParticipants(),
      _database.countSessionsThisMonth(),
      _database.revenueThisMonth(),
      _database.attendanceRate(),
      _database.todaySession(),
      _database.recentAttendance(),
      _database.upcomingSessions(),
      _database.pendingPayments(),
      _database.participantNames(),
    ]);

    totalParticipants = results[0] as int;
    sessionsThisMonth = results[1] as int;
    revenueThisMonth = results[2] as double;
    attendanceRate = results[3] as double;
    todaySession = results[4] as Map<String, dynamic>?;
    recentAttendance = results[5] as List<Map<String, dynamic>>;
    upcomingSessions = results[6] as List<Map<String, dynamic>>;
    pendingPayments = results[7] as List<Map<String, dynamic>>;
    final loadedParticipantNames = results[8] as List<String>;
    participantNames = loadedParticipantNames
        .map((name) => name.trim())
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList()
      ..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

    todaySessionParticipants = [];
    final sessionId = todaySession?['id'] as int?;
    if (sessionId != null) {
      todaySessionParticipants =
          await _database.todaySessionParticipants(sessionId);
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addParticipant({
    required String name,
    required String phone,
    required int age,
    required String weightClass,
    required String paymentMethod,
    required String notes,
  }) async {
    await _database.addParticipant(
      name: name,
      phone: phone,
      age: age,
      weightClass: weightClass,
      paymentMethod: paymentMethod,
      notes: notes,
    );
    await refresh();
  }

  Future<void> addSession({
    required String title,
    required String sessionType,
    required int durationMinutes,
    required String sessionDate,
    required String sessionTime,
  }) async {
    await _database.addSession(
      title: title,
      sessionType: sessionType,
      durationMinutes: durationMinutes,
      sessionDate: sessionDate,
      sessionTime: sessionTime,
    );
    await refresh();
  }

  Future<void> addPayment({
    required String participantName,
    required double amount,
    required String description,
    required String method,
    required String status,
  }) async {
    await _database.addPayment(
      participantName: participantName,
      amount: amount,
      description: description,
      method: method,
      status: status,
    );
    await refresh();
  }

  Future<void> addAttendance({
    required String participantName,
    required String sessionTitle,
    required String sessionDate,
    required String status,
    required String paymentStatus,
  }) async {
    await _database.addAttendance(
      participantName: participantName,
      sessionTitle: sessionTitle,
      sessionDate: sessionDate,
      status: status,
      paymentStatus: paymentStatus,
    );
    await refresh();
  }

  Future<File> createBackup() async {
    final backupFile = await _database.createBackup();
    lastBackupPath = backupFile.path;
    notifyListeners();
    return backupFile;
  }
}
