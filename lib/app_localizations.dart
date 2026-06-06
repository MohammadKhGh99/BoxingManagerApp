import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  String get noSessionToday => _localizedStrings['noSessionToday']!;
  String get manageData => _localizedStrings['manageData']!;
  String get quickActions => _localizedStrings['quickActions']!;
  String get backupDatabase => _localizedStrings['backupDatabase']!;
  String get cancel => _localizedStrings['cancel']!;
  String get save => _localizedStrings['save']!;
  String get saveChanges => _localizedStrings['saveChanges']!;
  String get unknown => _localizedStrings['unknown']!;
  String get fullName => _localizedStrings['fullName']!;
  String get phone => _localizedStrings['phone']!;
  String get age => _localizedStrings['age']!;
  String get weightClass => _localizedStrings['weightClass']!;
  String get paymentMethod => _localizedStrings['paymentMethod']!;
  String get notes => _localizedStrings['notes']!;
  String get duration => _localizedStrings['duration']!;
  String get amount => _localizedStrings['amount']!;
  String get description => _localizedStrings['description']!;
  String get participant => _localizedStrings['participant']!;
  String get session => _localizedStrings['session']!;
  String get date => _localizedStrings['date']!;
  String get status => _localizedStrings['status']!;
  String get payment => _localizedStrings['payment']!;
  String get attended => _localizedStrings['attended']!;
  String get absent => _localizedStrings['absent']!;
  String get paid => _localizedStrings['paid']!;
  String get present => _localizedStrings['present']!;
  String get late => _localizedStrings['late']!;
  String get excused => _localizedStrings['excused']!;
  String get sessionTitle => _localizedStrings['sessionTitle']!;
  String get sessionType => _localizedStrings['sessionType']!;
  String get selectDate => _localizedStrings['selectDate']!;
  String get sessionTime => _localizedStrings['sessionTime']!;
  String get selectTime => _localizedStrings['selectTime']!;
  String get pending => _localizedStrings['pending']!;
  String get addNew => _localizedStrings['addNew']!;
  String get addParticipant => _localizedStrings['addParticipant']!;
  String get scheduleSession => _localizedStrings['scheduleSession']!;
  String get recordPayment => _localizedStrings['recordPayment']!;
  String get takeAttendance => _localizedStrings['takeAttendance']!;
  String get upcomingSessions => _localizedStrings['upcomingSessions']!;
  String get pendingPayments => _localizedStrings['pendingPayments']!;
  String get editParticipant => _localizedStrings['editParticipant']!;
  String get editSession => _localizedStrings['editSession']!;
  String get editPayment => _localizedStrings['editPayment']!;
  String get noParticipantsFound => _localizedStrings['noParticipantsFound']!;
  String get noSessionsFound => _localizedStrings['noSessionsFound']!;
  String get noPaymentsFound => _localizedStrings['noPaymentsFound']!;
  String get participantDetails => _localizedStrings['participantDetails']!;
  String get sessionPlan => _localizedStrings['sessionPlan']!;
  String get transactionLog => _localizedStrings['transactionLog']!;
  String get recordPresence => _localizedStrings['recordPresence']!;
  String get viewAndEdit => _localizedStrings['viewAndEdit']!;
  String get participants => _localizedStrings['participants']!;
  String get sessions => _localizedStrings['sessions']!;
  String get payments => _localizedStrings['payments']!;
  String get language => _localizedStrings['language']!;
  String get english => _localizedStrings['english']!;
  String get arabic => _localizedStrings['arabic']!;
  String get hebrew => _localizedStrings['hebrew']!;

  // English strings
  static const Map<String, String> _englishStrings = {
    'title': 'Boxing Coach Manager',
    'subtitle': 'Manage your boxing sessions, participants, attendance, and payments',
    'totalParticipants': 'Total Participants',
    'sessionsThisMonth': 'Sessions This Month',
    'revenueThisMonth': 'Revenue This Month',
    'attendanceRate': 'Attendance Rate',
    'todaysSession': "Today's Session",
    'newSession': 'New Session',
    'noSessionToday': 'No session scheduled for today.',
    'manageData': 'Manage Data',
    'quickActions': 'Quick Actions',
    'backupDatabase': 'Backup Database',
    'cancel': 'Cancel',
    'save': 'Save',
    'saveChanges': 'Save Changes',
    'unknown': 'Unknown',
    'fullName': 'Full Name',
    'phone': 'Phone',
    'age': 'Age',
    'weightClass': 'Weight Class',
    'paymentMethod': 'Payment Method',
    'notes': 'Notes',
    'duration': 'Duration',
    'amount': 'Amount',
    'description': 'Description',
    'recentAttendance': 'Recent Attendance',
    'participant': 'Participant',
    'session': 'Session',
    'date': 'Date',
    'status': 'Status',
    'payment': 'Payment',
    'attended': 'Attended',
    'absent': 'Absent',
    'present': 'Present',
    'late': 'Late',
    'excused': 'Excused',
    'sessionTitle': 'Session Title',
    'sessionType': 'Session Type',
    'selectDate': 'Select Date',
    'sessionTime': 'Time',
    'selectTime': 'Select Time',
    'paid': 'Paid',
    'pending': 'Pending',
    'addNew': 'Add New',
    'addParticipant': 'Add Participant',
    'scheduleSession': 'Schedule Session',
    'recordPayment': 'Record Payment',
    'takeAttendance': 'Take Attendance',
    'upcomingSessions': 'Upcoming Sessions',
    'pendingPayments': 'Pending Payments',
    'editParticipant': 'Edit Participant',
    'editSession': 'Edit Session',
    'editPayment': 'Edit Payment',
    'noParticipantsFound': 'No participants found.',
    'noSessionsFound': 'No sessions found.',
    'noPaymentsFound': 'No payments found.',
    'participantDetails': 'Fill in the details below',
    'sessionPlan': 'Plan a future training class',
    'transactionLog': 'Log a new transaction',
    'recordPresence': 'Record presence for a session',
    'viewAndEdit': 'View and edit participants, sessions, and payments',
    'participants': 'Participants',
    'sessions': 'Sessions',
    'payments': 'Payments',
    'language': 'Language',
    'english': 'English',
    'arabic': 'Arabic',
    'hebrew': 'Hebrew',
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
    'noSessionToday': 'لا توجد جلسات مجدولة اليوم.',
    'manageData': 'إدارة البيانات',
    'quickActions': 'إجراءات سريعة',
    'backupDatabase': 'نسخ احتياطي لقاعدة البيانات',
    'cancel': 'إلغاء',
    'save': 'حفظ',
    'saveChanges': 'حفظ التغييرات',
    'unknown': 'غير معروف',
    'fullName': 'الاسم الكامل',
    'phone': 'الهاتف',
    'age': 'العمر',
    'weightClass': 'فئة الوزن',
    'paymentMethod': 'طريقة الدفع',
    'notes': 'ملاحظات',
    'duration': 'المدة',
    'amount': 'المبلغ',
    'description': 'الوصف',
    'recentAttendance': 'الحضور الأخير',
    'participant': 'المشارك',
    'session': 'الجلسة',
    'date': 'التاريخ',
    'status': 'الحالة',
    'payment': 'الدفع',
    'attended': 'حاضر',
    'absent': 'غائب',
    'present': 'حاضر',
    'late': 'متأخر',
    'excused': 'عذر',
    'sessionTitle': 'عنوان الجلسة',
    'sessionType': 'نوع الجلسة',
    'selectDate': 'اختر التاريخ',
    'sessionTime': 'الوقت',
    'selectTime': 'اختر الوقت',
    'paid': 'مدفوع',
    'pending': 'قيد الانتظار',
    'addNew': 'إضافة جديد',
    'addParticipant': 'إضافة مشارك',
    'scheduleSession': 'جدولة جلسة',
    'recordPayment': 'تسديد دفعة',
    'takeAttendance': 'تسجيل الحضور',
    'upcomingSessions': 'الجلسات القادمة',
    'pendingPayments': 'المدفوعات المعلقة',
    'editParticipant': 'تعديل مشارك',
    'editSession': 'تعديل جلسة',
    'editPayment': 'تعديل دفعة',
    'noParticipantsFound': 'لم يتم العثور على مشاركين.',
    'noSessionsFound': 'لم يتم العثور على جلسات.',
    'noPaymentsFound': 'لم يتم العثور على مدفوعات.',
    'participantDetails': 'املأ التفاصيل أدناه',
    'sessionPlan': 'خطط لجلسة تدريب مستقبلية',
    'transactionLog': 'تسجيل معاملة جديدة',
    'recordPresence': 'تسجيل الحضور للجلسة',
    'viewAndEdit': 'عرض وتعديل المشاركين والجلسات والمدفوعات',
    'participants': 'المشاركين',
    'sessions': 'الجلسات',
    'payments': 'المدفوعات',
    'language': 'اللغة',
    'english': 'الإنجليزية',
    'arabic': 'العربية',
    'hebrew': 'العبرية',
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
    'noSessionToday': 'אין אימונים מתוזמנים להיום.',
    'manageData': 'ניהול נתונים',
    'quickActions': 'פעולות מהירות',
    'backupDatabase': 'גיבוי מסד נתונים',
    'cancel': 'ביטול',
    'save': 'שמור',
    'saveChanges': 'שמור שינויים',
    'unknown': 'לא ידוע',
    'fullName': 'שם מלא',
    'phone': 'טלפון',
    'age': 'גיל',
    'weightClass': 'קבוצת משקל',
    'paymentMethod': 'שיטת תשלום',
    'notes': 'הערות',
    'duration': 'משך זמן',
    'amount': 'סכום',
    'description': 'תיאור',
    'recentAttendance': 'נוכחות אחרונה',
    'participant': 'משתתף',
    'session': 'אימון',
    'date': 'תאריך',
    'status': 'סטטוס',
    'payment': 'תשלום',
    'attended': 'נכח',
    'absent': 'נעדר',
    'present': 'נוכח',
    'late': 'איחר',
    'excused': 'מוצדק',
    'sessionTitle': 'כותרת האימון',
    'sessionType': 'סוג האימון',
    'selectDate': 'בחר תאריך',
    'sessionTime': 'שעה',
    'selectTime': 'בחר שעה',
    'paid': 'שולם',
    'pending': 'ממתין',
    'addNew': 'הוסף חדש',
    'addParticipant': 'הוסף משתתף',
    'scheduleSession': 'תזמן אימון',
    'recordPayment': 'רשם תשלום',
    'takeAttendance': 'רישום נוכחות',
    'upcomingSessions': 'אימונים קרובים',
    'pendingPayments': 'תשלומים ממתינים',
    'editParticipant': 'ערוך משתתף',
    'editSession': 'ערוך אימון',
    'editPayment': 'ערוך תשלום',
    'noParticipantsFound': 'לא נמצאו משתתפים.',
    'noSessionsFound': 'לא נמצאו אימונים.',
    'noPaymentsFound': 'לא נמצאו תשלומים.',
    'participantDetails': 'מלא את הפרטים למטה',
    'sessionPlan': 'תכנן אימון עתידי',
    'transactionLog': 'רשום עסקה חדשה',
    'recordPresence': 'רשום נוכחות לאימון',
    'viewAndEdit': 'צפה וערוך משתתפים, אימונים ותשלומים',
    'participants': 'משתתפים',
    'sessions': 'אימונים',
    'payments': 'תשלומים',
    'language': 'שפה',
    'english': 'אנגלית',
    'arabic': 'ערבית',
    'hebrew': 'עברית',
  };
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
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
