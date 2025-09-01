import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  Map<String, String> get _localizedStrings {
    switch (locale.languageCode) {
      case 'ar':
        return _arabicStrings;
      case 'he':
        return _hebrewStrings;
      default:
        return _englishStrings;
    }
  }

  String get title => _localizedStrings['title']!;
  String get subtitle => _localizedStrings['subtitle']!;
  String get totalParticipants => _localizedStrings['totalParticipants']!;
  String get sessionsThisMonth => _localizedStrings['sessionsThisMonth']!;
  String get revenueThisMonth => _localizedStrings['revenueThisMonth']!;
  String get attendanceRate => _localizedStrings['attendanceRate']!;
  String get todaysSession => _localizedStrings['todaysSession']!;
  String get newSession => _localizedStrings['newSession']!;
  String get recentAttendance => _localizedStrings['recentAttendance']!;
  String get participant => _localizedStrings['participant']!;
  String get session => _localizedStrings['session']!;
  String get date => _localizedStrings['date']!;
  String get status => _localizedStrings['status']!;
  String get payment => _localizedStrings['payment']!;
  String get attended => _localizedStrings['attended']!;
  String get absent => _localizedStrings['absent']!;
  String get paid => _localizedStrings['paid']!;
  String get pending => _localizedStrings['pending']!;
  String get addNew => _localizedStrings['addNew']!;
  String get addParticipant => _localizedStrings['addParticipant']!;
  String get scheduleSession => _localizedStrings['scheduleSession']!;
  String get recordPayment => _localizedStrings['recordPayment']!;
  String get takeAttendance => _localizedStrings['takeAttendance']!;
  String get upcomingSessions => _localizedStrings['upcomingSessions']!;
  String get pendingPayments => _localizedStrings['pendingPayments']!;
  String get participants => _localizedStrings['participants']!;
  String get language => _localizedStrings['language']!;
  String get english => _localizedStrings['english']!;
  String get arabic => _localizedStrings['arabic']!;
  String get hebrew => _localizedStrings['hebrew']!;
  String get dashboard => _localizedStrings['dashboard']!;
  String get sessions => _localizedStrings['sessions']!;
  String get more => _localizedStrings['more']!;

  // English strings
  static const Map<String, String> _englishStrings = {
    'title': 'Boxing Coach Manager',
    'subtitle':
        'Manage your boxing sessions, participants, attendance, and payments',
    'totalParticipants': 'Total Participants',
    'sessionsThisMonth': 'Sessions This Month',
    'revenueThisMonth': 'Revenue This Month',
    'attendanceRate': 'Attendance Rate',
    'todaysSession': "Today's Session",
    'newSession': 'New Session',
    'recentAttendance': 'Recent Attendance',
    'participant': 'Participant',
    'session': 'Session',
    'date': 'Date',
    'status': 'Status',
    'payment': 'Payment',
    'attended': 'Attended',
    'absent': 'Absent',
    'paid': 'Paid',
    'pending': 'Pending',
    'addNew': 'Add New',
    'addParticipant': 'Add Participant',
    'scheduleSession': 'Schedule Session',
    'recordPayment': 'Record Payment',
    'takeAttendance': 'Take Attendance',
    'upcomingSessions': 'Upcoming Sessions',
    'pendingPayments': 'Pending Payments',
    'participants': 'Participants',
    'language': 'Language',
    'english': 'English',
    'arabic': 'Arabic',
    'hebrew': 'Hebrew',
    'dashboard': 'Dashboard',
    'sessions': 'Sessions',
    'more': 'More',
  };

  // Arabic strings
  static const Map<String, String> _arabicStrings = {
    'title': 'مدرب الملاكمة',
    'subtitle': 'إدارة جلسات الملاكمة، المشاركين، الحضور، والمدفوعات',
    'totalParticipants': 'إجمالي المشاركين',
    'sessionsThisMonth': 'الجلسات هذا الشهر',
    'revenueThisMonth': 'الإيرادات هذا الشهر',
    'attendanceRate': 'معدل الحضور',
    'todaysSession': 'جلسة اليوم',
    'newSession': 'جلسة جديدة',
    'recentAttendance': 'الحضور الأخير',
    'participant': 'المشارك',
    'session': 'الجلسة',
    'date': 'التاريخ',
    'status': 'الحالة',
    'payment': 'الدفع',
    'attended': 'حاضر',
    'absent': 'غائب',
    'paid': 'مدفوع',
    'pending': 'قيد الانتظار',
    'addNew': 'إضافة جديد',
    'addParticipant': 'إضافة مشارك',
    'scheduleSession': 'جدولة جلسة',
    'recordPayment': 'تسديد دفعة',
    'takeAttendance': 'تسجيل الحضور',
    'upcomingSessions': 'الجلسات القادمة',
    'pendingPayments': 'المدفوعات المعلقة',
    'participants': 'المشاركين',
    'language': 'اللغة',
    'english': 'الإنجليزية',
    'arabic': 'العربية',
    'hebrew': 'العبرية',
    'dashboard': 'لوحة التحكم',
    'sessions': 'الجلسات',
    'more': 'المزيد',
  };

  // Hebrew strings
  static const Map<String, String> _hebrewStrings = {
    'title': 'מנהל מאמן איגרוף',
    'subtitle': 'נהל את אימוני האיגרוף, המשתתפים, הנוכחות והתשלומים שלך',
    'totalParticipants': 'סה"כ משתתפים',
    'sessionsThisMonth': 'אימונים החודש',
    'revenueThisMonth': 'הכנסה החודש',
    'attendanceRate': 'שיעור נוכחות',
    'todaysSession': 'אימון היום',
    'newSession': 'אימון חדש',
    'recentAttendance': 'נוכחות אחרונה',
    'participant': 'משתתף',
    'session': 'אימון',
    'date': 'תאריך',
    'status': 'סטטוס',
    'payment': 'תשלום',
    'attended': 'נכח',
    'absent': 'נעדר',
    'paid': 'שולם',
    'pending': 'ממתין',
    'addNew': 'הוסף חדש',
    'addParticipant': 'הוסף משתתף',
    'scheduleSession': 'תזמן אימון',
    'recordPayment': 'רשם תשלום',
    'takeAttendance': 'רישום נוכחות',
    'upcomingSessions': 'אימונים קרובים',
    'pendingPayments': 'תשלומים ממתינים',
    'participants': 'משתתפים',
    'language': 'שפה',
    'english': 'אנגלית',
    'arabic': 'ערבית',
    'hebrew': 'עברית',
    'dashboard': 'לוח בקרה',
    'sessions': 'אימונים',
    'more': 'עוד',
  };
}

class LocaleProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale loc) {
    _locale = loc;
    notifyListeners();
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar', 'he'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
