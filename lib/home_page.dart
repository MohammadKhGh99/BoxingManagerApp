import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' as intl;
import 'package:boxing_coach_manager/app_localizations.dart';
import 'package:boxing_coach_manager/providers/app_data_provider.dart';
import 'package:boxing_coach_manager/locale_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // final int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final dataProvider = context.watch<AppDataProvider>();
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    if (dataProvider.isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text(appLocalizations.title),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.backup),
            tooltip: 'Backup database',
            onPressed: () => _backupDatabase(context),
          ),
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageDialog(context),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context, appLocalizations),

            // Stats Cards
            const SizedBox(height: 20),
            _buildStatsCards(context, appLocalizations, dataProvider),

            // Main content
            const SizedBox(height: 20),
            _buildMainContent(context, appLocalizations, isRTL, dataProvider),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFabMenu(context, appLocalizations),
        backgroundColor: Colors.red,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, AppLocalizations appLocalizations) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFD32F2F), Color(0xFF9A0007)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.sports_mma, color: Colors.amber, size: 36),
                  const SizedBox(width: 15),
                  Text(
                    appLocalizations.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                appLocalizations.subtitle,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const CircleAvatar(
            backgroundColor: Colors.white,
            radius: 30,
            child: Icon(Icons.person, size: 40, color: Colors.red),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(BuildContext context,
      AppLocalizations appLocalizations, AppDataProvider dataProvider) {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: 1.2,
      children: [
        _buildStatCard(
          icon: Icons.people,
          value: dataProvider.totalParticipants.toString(),
          label: appLocalizations.totalParticipants,
          context: context,
        ),
        _buildStatCard(
          icon: Icons.calendar_today,
          value: dataProvider.sessionsThisMonth.toString(),
          label: appLocalizations.sessionsThisMonth,
          context: context,
        ),
        _buildStatCard(
          icon: Icons.attach_money,
          value: '\$${dataProvider.revenueThisMonth.toStringAsFixed(0)}',
          label: appLocalizations.revenueThisMonth,
          context: context,
        ),
        _buildStatCard(
          icon: Icons.percent,
          value: '${dataProvider.attendanceRate.toStringAsFixed(0)}%',
          label: appLocalizations.attendanceRate,
          context: context,
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    required BuildContext context,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.red),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent(
      BuildContext context,
      AppLocalizations appLocalizations,
      bool isRTL,
      AppDataProvider dataProvider) {
    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                // Today's session
                _buildTodaysSession(context, appLocalizations, dataProvider),

                // Recent attendance
                const SizedBox(height: 20),
                _buildRecentAttendance(context, appLocalizations, dataProvider),
              ],
            ),
          ),

          // Sidebar
          const SizedBox(width: 20),
          Expanded(
            flex: 1,
            child: Column(
              children: [
                // Add new section
                _buildAddNewSection(context, appLocalizations),

                // Upcoming sessions
                const SizedBox(height: 20),
                _buildUpcomingSessions(context, appLocalizations, dataProvider),

                // Pending payments
                const SizedBox(height: 20),
                _buildPendingPayments(context, appLocalizations, dataProvider),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodaysSession(BuildContext context,
      AppLocalizations appLocalizations, AppDataProvider dataProvider) {
    final session = dataProvider.todaySession;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.red),
                    const SizedBox(width: 10),
                    Text(
                      appLocalizations.todaysSession,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  icon: const Icon(Icons.add),
                  label: Text(appLocalizations.newSession),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () {
                    _showScheduleSessionDialog(context);
                  },
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (session == null)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Center(child: Text(appLocalizations.noSessionToday)),
              )
            else
              _buildSessionCard(
                title: session['title']?.toString() ?? appLocalizations.session,
                date: '${session['sessionDate']} ${session['sessionTime']}',
                description: session['notes']?.toString() ?? '',
                participants: dataProvider.todaySessionParticipants,
                appLocalizations: appLocalizations,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionCard({
    required String title,
    required String date,
    required String description,
    required List<Map<String, dynamic>> participants,
    required AppLocalizations appLocalizations,
  }) {
    return Card(
      elevation: 2,
      color: Colors.grey[50],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: const BorderSide(color: Colors.red, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  date,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(description),
            const SizedBox(height: 15),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: participants.map((participant) {
                final isPaid =
                    participant['paid'] == true || participant['paid'] == 1;
                final participantName =
                    participant['participantName']?.toString() ??
                        participant['name']?.toString() ??
                        appLocalizations.unknown;
                return Chip(
                  backgroundColor: isPaid ? Colors.green[50] : Colors.blue[50],
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isPaid ? Icons.check : Icons.person,
                        size: 16,
                        color: isPaid ? Colors.green : Colors.blue,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        participantName,
                        style: TextStyle(
                          color: isPaid ? Colors.green : Colors.blue,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAttendance(BuildContext context,
      AppLocalizations appLocalizations, AppDataProvider dataProvider) {
    final attendanceData = dataProvider.recentAttendance;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.list_alt, color: Colors.red),
                const SizedBox(width: 10),
                Text(
                  appLocalizations.recentAttendance,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: DataTable(
                columns: [
                  DataColumn(label: Text(appLocalizations.participant)),
                  DataColumn(label: Text(appLocalizations.session)),
                  DataColumn(label: Text(appLocalizations.date)),
                  DataColumn(label: Text(appLocalizations.status)),
                  DataColumn(label: Text(appLocalizations.payment)),
                ],
                rows: attendanceData.map((data) {
                  return DataRow(cells: [
                    DataCell(Text(data['participantName']?.toString() ??
                        appLocalizations.unknown)),
                    DataCell(Text(data['sessionTitle']?.toString() ??
                        appLocalizations.unknown)),
                    DataCell(Text(data['sessionDate']?.toString() ??
                        appLocalizations.unknown)),
                    DataCell(
                      Chip(
                        backgroundColor: data['status'] == 'attended'
                            ? Colors.green[50]
                            : Colors.red[50],
                        label: Text(
                          data['status'] == 'attended'
                              ? appLocalizations.attended
                              : appLocalizations.absent,
                          style: TextStyle(
                            color: data['status'] == 'attended'
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ),
                    ),
                    DataCell(
                      Chip(
                        backgroundColor: data['paymentStatus'] == 'paid'
                            ? Colors.blue[50]
                            : Colors.orange[50],
                        label: Text(
                          data['paymentStatus'] == 'paid'
                              ? appLocalizations.paid
                              : appLocalizations.pending,
                          style: TextStyle(
                            color: data['paymentStatus'] == 'paid'
                                ? Colors.blue
                                : Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ]);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddNewSection(
      BuildContext context, AppLocalizations appLocalizations) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.add_circle, color: Colors.red),
                const SizedBox(width: 10),
                Text(
                  appLocalizations.addNew,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Column(
              children: [
                _buildAddButton(
                  icon: Icons.person_add,
                  text: appLocalizations.addParticipant,
                  onPressed: () => _showAddParticipantDialog(context),
                ),
                const SizedBox(height: 10),
                _buildAddButton(
                  icon: Icons.calendar_today,
                  text: appLocalizations.scheduleSession,
                  onPressed: () => _showScheduleSessionDialog(context),
                ),
                const SizedBox(height: 10),
                _buildAddButton(
                  icon: Icons.payment,
                  text: appLocalizations.recordPayment,
                  onPressed: () => _showRecordPaymentDialog(context),
                ),
                const SizedBox(height: 10),
                _buildAddButton(
                  icon: Icons.checklist,
                  text: appLocalizations.takeAttendance,
                  onPressed: () => _showTakeAttendanceDialog(context),
                ),
                const SizedBox(height: 10),
                _buildAddButton(
                  icon: Icons.manage_search,
                  text: appLocalizations.manageData,
                  onPressed: () => _showManageDataDialog(context, appLocalizations),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: Colors.red,
        side: const BorderSide(color: Colors.red),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon),
          const SizedBox(width: 10),
          Text(text),
        ],
      ),
    );
  }

  Widget _buildUpcomingSessions(BuildContext context,
      AppLocalizations appLocalizations, AppDataProvider dataProvider) {
    final sessions = dataProvider.upcomingSessions;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.upcoming, color: Colors.red),
                const SizedBox(width: 10),
                Text(
                  appLocalizations.upcomingSessions,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Column(
              children: sessions.map((session) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${session['sessionDate']} ${session['sessionTime']}',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            session['title']?.toString() ?? '',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Chip(
                        backgroundColor: Colors.blue[50],
                        label: Text(
                            "${session['participantsCount']} ${appLocalizations.participants}"),
                        labelStyle: const TextStyle(
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPendingPayments(BuildContext context,
      AppLocalizations appLocalizations, AppDataProvider dataProvider) {
    final payments = dataProvider.pendingPayments;

    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.warning, color: Colors.orange),
                const SizedBox(width: 10),
                Text(
                  appLocalizations.pendingPayments,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Column(
              children: payments.map((payment) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            payment['participantName']?.toString() ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            payment['description']?.toString() ?? '',
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Chip(
                        backgroundColor: Colors.orange[50],
                        label: Text(
                          '\$${(payment['amount'] as num).toStringAsFixed(0)}',
                          style: const TextStyle(color: Colors.orange),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddParticipantDialog(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final nameController = TextEditingController();
    final phoneController = TextEditingController();
    final ageController = TextEditingController();
    final notesController = TextEditingController();
    String selectedWeightClass = 'Lightweight';
    String selectedPaymentMethod = 'Cash';

    final weightClasses = [
      'Minimumweight',
      'Light Flyweight',
      'Flyweight',
      'Super Flyweight',
      'Bantamweight',
      'Super Bantamweight',
      'Featherweight',
      'Super Featherweight',
      'Lightweight',
      'Super Lightweight',
      'Welterweight',
      'Super Welterweight',
      'Middleweight',
      'Super Middleweight',
      'Light Heavyweight',
      'Cruiserweight',
      'Heavyweight',
      'Super Heavyweight',
    ];

    final paymentMethods = [
      'Cash',
      'Credit Card',
      'Bank Transfer',
      'Monthly Plan'
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Header
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFF9A0007)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white24,
                            radius: 22,
                            child: Icon(Icons.person_add,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appLocalizations.addParticipant,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                appLocalizations.participantDetails,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon:
                                const Icon(Icons.close, color: Colors.white70),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),

                    // Form body
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Full Name
                              _dialogFieldLabel(
                                  '${appLocalizations.fullName} *'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: nameController,
                                decoration: _dialogInputDecoration(
                                  hint: 'e.g. John Smith',
                                  icon: Icons.person_outline,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Name is required'
                                        : null,
                              ),
                              const SizedBox(height: 16),

                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            '${appLocalizations.phone} *'),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: phoneController,
                                          keyboardType: TextInputType.phone,
                                          maxLength: 10,
                                          decoration: _dialogInputDecoration(
                                            hint: 'e.g. 050 000 0000',
                                            icon: Icons.phone_outlined,
                                          ),
                                          validator: (v) =>
                                              (v == null || v.trim().isEmpty)
                                                  ? 'Phone is required'
                                                  : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            '${appLocalizations.age} *'),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: ageController,
                                          keyboardType: TextInputType.number,
                                          maxLength: 3,
                                          decoration: _dialogInputDecoration(
                                            hint: 'e.g. 22',
                                            icon: Icons.cake_outlined,
                                          ),
                                          validator: (v) {
                                            if (v == null || v.trim().isEmpty) {
                                              return 'Age is required';
                                            }
                                            final age = int.tryParse(v.trim());
                                            if (age == null ||
                                                age < 1 ||
                                                age > 99) {
                                              return 'Enter a valid age (1-99)';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Weight Class + Payment side by side
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            appLocalizations.weightClass),
                                        const SizedBox(height: 6),
                                        DropdownButtonFormField<String>(
                                          initialValue: selectedWeightClass,
                                          decoration: _dialogInputDecoration(
                                            hint: '',
                                            icon: Icons.monitor_weight_outlined,
                                          ),
                                          isExpanded: true,
                                          items: weightClasses
                                              .map((w) => DropdownMenuItem(
                                                  value: w,
                                                  child: Text(w,
                                                      style: const TextStyle(
                                                          fontSize: 13))))
                                              .toList(),
                                          onChanged: (v) => setDialogState(
                                              () => selectedWeightClass = v!),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            appLocalizations.paymentMethod),
                                        const SizedBox(height: 6),
                                        DropdownButtonFormField<String>(
                                          initialValue: selectedPaymentMethod,
                                          decoration: _dialogInputDecoration(
                                            hint: '',
                                            icon: Icons.payment_outlined,
                                          ),
                                          isExpanded: true,
                                          items: paymentMethods
                                              .map((p) => DropdownMenuItem(
                                                  value: p,
                                                  child: Text(p,
                                                      style: const TextStyle(
                                                          fontSize: 13))))
                                              .toList(),
                                          onChanged: (v) => setDialogState(
                                              () => selectedPaymentMethod = v!),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // Notes
                              _dialogFieldLabel(appLocalizations.notes),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: notesController,
                                maxLines: 3,
                                decoration: _dialogInputDecoration(
                                  hint: 'Any additional information...',
                                  icon: Icons.notes_outlined,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    // Actions
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(appLocalizations.cancel,
                                style: const TextStyle(color: Colors.grey)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: Text(appLocalizations.save),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final navigator = Navigator.of(context);
                                final messenger = ScaffoldMessenger.of(context);
                                await context
                                    .read<AppDataProvider>()
                                    .addParticipant(
                                      name: nameController.text.trim(),
                                      phone: phoneController.text.trim(),
                                      age: int.parse(ageController.text.trim()),
                                      weightClass: selectedWeightClass,
                                      paymentMethod: selectedPaymentMethod,
                                      notes: notesController.text.trim(),
                                    );
                                navigator.pop();
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(Icons.check_circle,
                                            color: Colors.white),
                                        const SizedBox(width: 10),
                                        Text(
                                            '${nameController.text.trim()} added successfully!'),
                                      ],
                                    ),
                                    backgroundColor: Colors.green[700],
                                    behavior: SnackBarBehavior.floating,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    duration: const Duration(seconds: 3),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _dialogFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
          fontSize: 13, fontWeight: FontWeight.w600, color: Colors.black87),
    );
  }

  InputDecoration _dialogInputDecoration(
      {required String hint, required IconData icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
      prefixIcon: Icon(icon, size: 20, color: Colors.red[300]),
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[300]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFD32F2F), width: 2),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Colors.red),
      ),
      filled: true,
      fillColor: Colors.grey[50],
    );
  }

  void _showScheduleSessionDialog(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final sessionTypeController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final durationController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFF9A0007)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white24,
                            radius: 22,
                            child: Icon(Icons.calendar_month,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appLocalizations.scheduleSession,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                appLocalizations.sessionPlan,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon:
                                const Icon(Icons.close, color: Colors.white70),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _dialogFieldLabel(
                                  '${appLocalizations.sessionTitle} *'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: titleController,
                                decoration: _dialogInputDecoration(
                                  hint: 'e.g. Friday Sparring',
                                  icon: Icons.title,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Required'
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            appLocalizations.sessionType),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: sessionTypeController,
                                          decoration: _dialogInputDecoration(
                                            hint: 'e.g. Group Training',
                                            icon: Icons.sports_mma,
                                          ),
                                          validator: (v) =>
                                              (v == null || v.trim().isEmpty)
                                                  ? 'Required'
                                                  : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            appLocalizations.duration),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: durationController,
                                          decoration: _dialogInputDecoration(
                                            hint: 'min',
                                            icon: Icons.timer_outlined,
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            appLocalizations.date),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: dateController,
                                          readOnly: true,
                                          decoration: _dialogInputDecoration(
                                            hint: appLocalizations.selectDate,
                                            icon: Icons.event,
                                          ),
                                          onTap: () async {
                                            final now = DateTime.now();
                                            final DateTime? picked =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: now,
                                              firstDate:
                                                  now, // Prevents picking dates before today
                                              lastDate: DateTime(now.year + 2),
                                            );
                                            if (picked != null) {
                                              dateController.text =
                                                  "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                                            }
                                          },
                                          validator: (v) {
                                            if (v == null || v.trim().isEmpty) {
                                              return 'Required';
                                            }
                                            final selectedDate =
                                                DateTime.tryParse(v);
                                            if (selectedDate != null) {
                                              final today = DateTime.now();
                                              final normalizedToday = DateTime(
                                                  today.year,
                                                  today.month,
                                                  today.day);
                                              if (selectedDate
                                                  .isBefore(normalizedToday)) {
                                                return 'Date cannot be in the past';
                                              }
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            appLocalizations.sessionTime),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: timeController,
                                          readOnly: true,
                                          decoration: _dialogInputDecoration(
                                            hint: appLocalizations.selectTime,
                                            icon: Icons.access_time,
                                          ),
                                          onTap: () async {
                                            final TimeOfDay? picked =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: TimeOfDay.now(),
                                            );
                                            if (picked != null &&
                                                context.mounted) {
                                              timeController.text =
                                                  picked.format(context);
                                            }
                                          },
                                          validator: (v) =>
                                              (v == null || v.trim().isEmpty)
                                                  ? 'Required'
                                                  : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(appLocalizations.cancel,
                                style: const TextStyle(color: Colors.grey)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: Text(appLocalizations.save),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                final navigator = Navigator.of(context);
                                final messenger = ScaffoldMessenger.of(context);
                                await context
                                    .read<AppDataProvider>()
                                    .addSession(
                                      title: titleController.text.trim(),
                                      sessionType:
                                          sessionTypeController.text.trim(),
                                      durationMinutes: int.tryParse(
                                            durationController.text.trim(),
                                          ) ??
                                          0,
                                      sessionDate: dateController.text.trim(),
                                      sessionTime: timeController.text.trim(),
                                    );
                                navigator.pop();
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${titleController.text.trim()} scheduled!'),
                                    backgroundColor: Colors.green[700],
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _showRecordPaymentDialog(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    String selectedPaymentMethod = 'Cash';
    final participantNames = context.read<AppDataProvider>().participantNames;
    String? selectedParticipant =
        participantNames.isNotEmpty ? participantNames.first : null;

    final paymentMethods = [
      'Cash',
      'Credit Card',
      'Bank Transfer',
      'Mobile App'
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 500,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFF9A0007)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white24,
                            radius: 22,
                            child: Icon(Icons.attach_money,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appLocalizations.recordPayment,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                appLocalizations.transactionLog,
                                style: const TextStyle(
                                    color: Colors.white70, fontSize: 13),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon:
                                const Icon(Icons.close, color: Colors.white70),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _dialogFieldLabel(appLocalizations.participant),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                initialValue: selectedParticipant,
                                decoration: _dialogInputDecoration(
                                  hint: '',
                                  icon: Icons.person,
                                ),
                                disabledHint: const Text(
                                  'No participants yet',
                                  style: TextStyle(fontSize: 13),
                                ),
                                isExpanded: true,
                                items: participantNames
                                    .map((p) => DropdownMenuItem(
                                        value: p,
                                        child: Text(p,
                                            style:
                                                const TextStyle(fontSize: 13))))
                                    .toList(),
                                onChanged: participantNames.isEmpty
                                    ? null
                                    : (v) => setDialogState(
                                        () => selectedParticipant = v),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            '${appLocalizations.amount} (\$) *'),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: amountController,
                                          decoration: _dialogInputDecoration(
                                            hint: 'e.g. 50',
                                            icon: Icons.payment,
                                          ),
                                          keyboardType: const TextInputType
                                              .numberWithOptions(decimal: true),
                                          validator: (v) =>
                                              (v == null || v.trim().isEmpty)
                                                  ? 'Required'
                                                  : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            appLocalizations.paymentMethod),
                                        const SizedBox(height: 6),
                                        DropdownButtonFormField<String>(
                                          initialValue: selectedPaymentMethod,
                                          decoration: _dialogInputDecoration(
                                            hint: '',
                                            icon: Icons.account_balance_wallet,
                                          ),
                                          isExpanded: true,
                                          items: paymentMethods
                                              .map((m) => DropdownMenuItem(
                                                  value: m,
                                                  child: Text(m,
                                                      style: const TextStyle(
                                                          fontSize: 13))))
                                              .toList(),
                                          onChanged: (v) => setDialogState(
                                              () => selectedPaymentMethod = v!),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(appLocalizations.cancel,
                                style: const TextStyle(color: Colors.grey)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: Text(appLocalizations.save),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () async {
                              if (formKey.currentState!.validate()) {
                                if (selectedParticipant == null) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                          'Add a participant first to record payment.'),
                                    ),
                                  );
                                  return;
                                }

                                final navigator = Navigator.of(context);
                                final messenger = ScaffoldMessenger.of(context);
                                await context
                                    .read<AppDataProvider>()
                                    .addPayment(
                                      participantName: selectedParticipant!,
                                      amount: double.tryParse(
                                            amountController.text.trim(),
                                          ) ??
                                          0,
                                      description: 'Payment marked as paid',
                                      method: selectedPaymentMethod,
                                      status: 'paid',
                                    );
                                navigator.pop();
                                messenger.showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Payment of \$${amountController.text} from $selectedParticipant marked as paid.'),
                                    backgroundColor: Colors.green[700],
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _showTakeAttendanceDialog(BuildContext context) async {
    final appLocalizations = AppLocalizations.of(context)!;
    final dataProvider = context.read<AppDataProvider>();
    final allSessions = await dataProvider.allSessions();
    if (!context.mounted) {
      return;
    }

    final now = DateTime.now();
    final eligibleSessions = allSessions
        .where((session) => _isSessionEligibleForAttendance(session, now))
        .toList()
      ..sort((a, b) {
        final aDateTime = _sessionDateTime(a);
        final bDateTime = _sessionDateTime(b);
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

    if (eligibleSessions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content:
              Text('No past or current sessions are available for attendance.'),
        ),
      );
      return;
    }

    final participantNames = dataProvider.participantNames;
    String? selectedParticipant =
        participantNames.isNotEmpty ? participantNames.first : null;
    int? selectedSessionId = eligibleSessions.first['id'] as int?;
    String selectedStatus = appLocalizations.present;
    String selectedPaymentStatus = appLocalizations.pending;

    final statusOptions = [
      appLocalizations.present,
      appLocalizations.absent,
      appLocalizations.late,
      appLocalizations.excused
    ];
    final paymentStatusOptions = ['pending', 'paid'];

    if (!context.mounted) {
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final selectedSession = eligibleSessions.firstWhere(
              (session) => session['id'] == selectedSessionId,
              orElse: () => eligibleSessions.first,
            );

            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 540,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 20,
                      ),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFF9A0007)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white24,
                            radius: 22,
                            child: Icon(Icons.how_to_reg,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appLocalizations.takeAttendance,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                appLocalizations.recordPresence,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon:
                                const Icon(Icons.close, color: Colors.white70),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _dialogFieldLabel(appLocalizations.session),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<int>(
                              value: selectedSessionId,
                              decoration: _dialogInputDecoration(
                                hint: '',
                                icon: Icons.sports_mma,
                              ),
                              isExpanded: true,
                              items: eligibleSessions.map((session) {
                                final sessionId = session['id'] as int?;
                                return DropdownMenuItem<int>(
                                  value: sessionId,
                                  child: Text(
                                    '#${sessionId ?? '-'} ${session['title'] ?? ''} • ${session['sessionDate'] ?? ''} ${session['sessionTime'] ?? ''}',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setDialogState(() => selectedSessionId = value);
                              },
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _dialogFieldLabel(
                                          appLocalizations.participant),
                                      const SizedBox(height: 6),
                                      DropdownButtonFormField<String>(
                                        value: selectedParticipant,
                                        decoration: _dialogInputDecoration(
                                          hint: '',
                                          icon: Icons.person,
                                        ),
                                        disabledHint: const Text(
                                          'No participants yet',
                                          style: TextStyle(fontSize: 13),
                                        ),
                                        isExpanded: true,
                                        items: participantNames
                                            .map(
                                              (participant) => DropdownMenuItem(
                                                value: participant,
                                                child: Text(
                                                  participant,
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: participantNames.isEmpty
                                            ? null
                                            : (value) => setDialogState(() =>
                                                selectedParticipant = value),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _dialogFieldLabel(
                                          appLocalizations.status),
                                      const SizedBox(height: 6),
                                      DropdownButtonFormField<String>(
                                        value: selectedStatus,
                                        decoration: _dialogInputDecoration(
                                          hint: '',
                                          icon: Icons.flag,
                                        ),
                                        isExpanded: true,
                                        items: statusOptions
                                            .map(
                                              (option) => DropdownMenuItem(
                                                value: option,
                                                child: Text(
                                                  option,
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          setDialogState(
                                              () => selectedStatus = value!);
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _dialogFieldLabel(appLocalizations.payment),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: selectedPaymentStatus,
                              decoration: _dialogInputDecoration(
                                hint: '',
                                icon: Icons.payments,
                              ),
                              isExpanded: true,
                              items: paymentStatusOptions
                                  .map(
                                    (option) => DropdownMenuItem(
                                      value: option,
                                      child: Text(
                                        option,
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (value) {
                                setDialogState(
                                    () => selectedPaymentStatus = value!);
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text(
                              appLocalizations.cancel,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: Text(appLocalizations.save),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              if (selectedParticipant == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Add a participant first to record attendance.',
                                    ),
                                  ),
                                );
                                return;
                              }
                              if (selectedSessionId == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text(
                                      'Select a valid current or past session.',
                                    ),
                                  ),
                                );
                                return;
                              }

                              final selectedSessionTitle =
                                  selectedSession['title']?.toString() ?? '';
                              final selectedSessionDate =
                                  selectedSession['sessionDate']?.toString() ??
                                      '';

                              final navigator = Navigator.of(context);
                              final messenger = ScaffoldMessenger.of(context);
                              await context
                                  .read<AppDataProvider>()
                                  .addAttendance(
                                    participantName: selectedParticipant!,
                                    sessionTitle: selectedSessionTitle,
                                    sessionDate: selectedSessionDate,
                                    status: selectedStatus.toLowerCase(),
                                    paymentStatus: selectedPaymentStatus,
                                  );
                              navigator.pop();
                              messenger.showSnackBar(
                                SnackBar(
                                  content: Text(
                                    '$selectedParticipant marked $selectedStatus for $selectedSessionTitle.',
                                  ),
                                  backgroundColor: Colors.green[700],
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  bool _isSessionEligibleForAttendance(
      Map<String, dynamic> session, DateTime now) {
    final sessionDateTime = _sessionDateTime(session);
    return sessionDateTime != null && !sessionDateTime.isAfter(now);
  }

  DateTime? _sessionDateTime(Map<String, dynamic> session) {
    final sessionDateText = session['sessionDate']?.toString().trim();
    final sessionTimeText = session['sessionTime']?.toString().trim();

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

    final candidateFormats = [
      intl.DateFormat.jm(),
      intl.DateFormat.Hm(),
      intl.DateFormat('h:mm a'),
      intl.DateFormat('hh:mm a'),
    ];

    DateTime? parsedTime;
    for (final format in candidateFormats) {
      try {
        parsedTime = format.parseStrict(sessionTimeText);
        break;
      } catch (_) {
        continue;
      }
    }

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

  Future<void> _showManageDataDialog(BuildContext context, AppLocalizations appLocalizations) async {
    final appLocalizations = AppLocalizations.of(context)!;
    final dataProvider = context.read<AppDataProvider>();

    Future<Map<String, List<Map<String, dynamic>>>> loadData() async {
      final results = await Future.wait([
        dataProvider.allParticipants(),
        dataProvider.allSessions(),
        dataProvider.allPayments(),
      ]);
      return {
        'participants':
            List<Map<String, dynamic>>.from(results[0] as List<dynamic>),
        'sessions':
            List<Map<String, dynamic>>.from(results[1] as List<dynamic>),
        'payments':
            List<Map<String, dynamic>>.from(results[2] as List<dynamic>),
      };
    }

    late Future<Map<String, List<Map<String, dynamic>>>> loadFuture =
        loadData();

    if (!context.mounted) {
      return;
    }

    await showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 820,
                height: 620,
                child: DefaultTabController(
                  length: 3,
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 20,
                        ),
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Color(0xFFD32F2F), Color(0xFF9A0007)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Row(
                          children: [
                            const CircleAvatar(
                              backgroundColor: Colors.white24,
                              radius: 22,
                              child: Icon(Icons.manage_accounts,
                                  color: Colors.white, size: 22),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  appLocalizations.manageData,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  appLocalizations.viewAndEdit,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close,
                                  color: Colors.white70),
                              onPressed: () => Navigator.pop(dialogContext),
                            ),
                          ],
                        ),
                      ),
                      TabBar(
                        labelColor: Color(0xFFD32F2F),
                        unselectedLabelColor: Colors.grey,
                        tabs: [
                          Tab(text: appLocalizations.participants),
                          Tab(text: appLocalizations.sessions),
                          Tab(text: appLocalizations.payments),
                        ],
                      ),
                      Expanded(
                        child: FutureBuilder<
                            Map<String, List<Map<String, dynamic>>>>(
                          future: loadFuture,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            }

                            if (snapshot.hasError) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24),
                                  child: Text(
                                      'Failed to load data: ${snapshot.error}'),
                                ),
                              );
                            }

                            final participants =
                                snapshot.data?['participants'] ?? [];
                            final sessions = snapshot.data?['sessions'] ?? [];
                            final payments = snapshot.data?['payments'] ?? [];

                            return TabBarView(
                              children: [
                                _buildParticipantsListTab(
                                  context: context,
                                  participants: participants,
                                  onEdit: (participant) async {
                                    final updated =
                                        await _showEditParticipantDialog(
                                      context,
                                      participant,
                                    );
                                    if (updated && context.mounted) {
                                      setDialogState(() {
                                        loadFuture = loadData();
                                      });
                                    }
                                  },
                                ),
                                _buildSessionsListTab(
                                  context: context,
                                  sessions: sessions,
                                  onEdit: (session) async {
                                    final updated =
                                        await _showEditSessionDialog(
                                      context,
                                      session,
                                    );
                                    if (updated && context.mounted) {
                                      setDialogState(() {
                                        loadFuture = loadData();
                                      });
                                    }
                                  },
                                ),
                                _buildPaymentsListTab(
                                  context: context,
                                  payments: payments,
                                  onEdit: (payment) async {
                                    final updated =
                                        await _showEditPaymentDialog(
                                      context,
                                      payment,
                                    );
                                    if (updated && context.mounted) {
                                      setDialogState(() {
                                        loadFuture = loadData();
                                      });
                                    }
                                  },
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildParticipantsListTab({
    required BuildContext context,
    required List<Map<String, dynamic>> participants,
    required Future<void> Function(Map<String, dynamic> participant) onEdit,
  }) {
    final appLocalizations = AppLocalizations.of(context)!;
    if (participants.isEmpty) {
      return Center(child: Text(appLocalizations.noParticipantsFound));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: participants.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final participant = participants[index];
        final participantId = participant['id']?.toString() ?? '-';
        final participantName = participant['name']?.toString() ?? 'Unknown';
        final phone = participant['phone']?.toString() ?? '';
        final weightClass = participant['weightClass']?.toString() ?? '';
        final paymentMethod = participant['paymentMethod']?.toString() ?? '';

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red[50],
              child: Text(participantId,
                  style: const TextStyle(color: Colors.red)),
            ),
            title: Text(
              '#$participantId $participantName',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              [
                if (phone.isNotEmpty) '${appLocalizations.phone}: $phone',
                if (weightClass.isNotEmpty)
                  '${appLocalizations.weightClass}: $weightClass',
                if (paymentMethod.isNotEmpty)
                  '${appLocalizations.paymentMethod}: $paymentMethod',
              ].join(' • '),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.red),
              onPressed: () => onEdit(participant),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSessionsListTab({
    required BuildContext context,
    required List<Map<String, dynamic>> sessions,
    required Future<void> Function(Map<String, dynamic> session) onEdit,
  }) {
    final appLocalizations = AppLocalizations.of(context)!;
    if (sessions.isEmpty) {
      return Center(child: Text(appLocalizations.noSessionsFound));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: sessions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final session = sessions[index];
        final sessionId = session['id']?.toString() ?? '-';
        final title = session['title']?.toString() ?? 'Session';
        final sessionDate = session['sessionDate']?.toString() ?? '';
        final sessionTime = session['sessionTime']?.toString() ?? '';
        final sessionType = session['sessionType']?.toString() ?? '';
        final durationMinutes = session['durationMinutes']?.toString() ?? '';
        final participantsCount =
            session['participantsCount']?.toString() ?? '0';

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red[50],
              child: Text(sessionId, style: const TextStyle(color: Colors.red)),
            ),
            title: Text(
              '#$sessionId $title',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              [
                '$sessionDate $sessionTime',
                if (sessionType.isNotEmpty) sessionType,
                if (durationMinutes.isNotEmpty) '$durationMinutes min',
                '$participantsCount participants',
              ].join(' • '),
            ),
            trailing: IconButton(
              icon: const Icon(Icons.edit, color: Colors.red),
              onPressed: () => onEdit(session),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPaymentsListTab({
    required BuildContext context,
    required List<Map<String, dynamic>> payments,
    required Future<void> Function(Map<String, dynamic> payment) onEdit,
  }) {
    final appLocalizations = AppLocalizations.of(context)!;
    if (payments.isEmpty) {
      return Center(child: Text(appLocalizations.noPaymentsFound));
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: payments.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final payment = payments[index];
        final paymentId = payment['id']?.toString() ?? '-';
        final participantName =
            payment['participantName']?.toString() ?? 'Unknown';
        final description = payment['description']?.toString() ?? '';
        final method = payment['method']?.toString() ?? '';
        final status = payment['status']?.toString() ?? '';
        final amount = (payment['amount'] as num?)?.toDouble() ?? 0;

        return Card(
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor:
                  status == 'paid' ? Colors.green[50] : Colors.orange[50],
              child: Text(
                paymentId,
                style: TextStyle(
                  color: status == 'paid' ? Colors.green : Colors.orange,
                ),
              ),
            ),
            title: Text(
              '#$paymentId $participantName',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              [
                if (description.isNotEmpty) description,
                if (method.isNotEmpty)
                  '${appLocalizations.paymentMethod}: $method',
                '${appLocalizations.status}: ${status.isEmpty ? appLocalizations.unknown : status}',
              ].join(' • '),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Chip(
                  backgroundColor:
                      status == 'paid' ? Colors.green[50] : Colors.orange[50],
                  label: Text(
                    '\$${amount.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: status == 'paid' ? Colors.green : Colors.orange,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.red),
                  onPressed: () => onEdit(payment),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<bool> _showEditParticipantDialog(
    BuildContext context,
    Map<String, dynamic> participant,
  ) async {
    final appLocalizations = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final nameController =
        TextEditingController(text: participant['name']?.toString() ?? '');
    final phoneController =
        TextEditingController(text: participant['phone']?.toString() ?? '');
    final ageController =
        TextEditingController(text: participant['age']?.toString() ?? '');
    final notesController =
        TextEditingController(text: participant['notes']?.toString() ?? '');

    String selectedWeightClass =
        participant['weightClass']?.toString().trim().isNotEmpty == true
            ? participant['weightClass'].toString()
            : 'Lightweight';
    String selectedPaymentMethod =
        participant['paymentMethod']?.toString().trim().isNotEmpty == true
            ? participant['paymentMethod'].toString()
            : 'Cash';

    final weightClasses = [
      'Minimumweight',
      'Light Flyweight',
      'Flyweight',
      'Super Flyweight',
      'Bantamweight',
      'Super Bantamweight',
      'Featherweight',
      'Super Featherweight',
      'Lightweight',
      'Super Lightweight',
      'Welterweight',
      'Super Welterweight',
      'Middleweight',
      'Super Middleweight',
      'Light Heavyweight',
      'Cruiserweight',
      'Heavyweight',
      'Super Heavyweight',
    ];

    final paymentMethods = [
      'Cash',
      'Credit Card',
      'Bank Transfer',
      'Monthly Plan',
    ];

    final participantId = participant['id']?.toString() ?? '-';

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 520,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFF9A0007)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white24,
                            radius: 22,
                            child: Icon(Icons.person,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appLocalizations.editParticipant,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Participant ID #$participantId',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon:
                                const Icon(Icons.close, color: Colors.white70),
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _dialogFieldLabel(
                                  '${appLocalizations.participant} *'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: nameController,
                                decoration: _dialogInputDecoration(
                                  hint: 'Enter name',
                                  icon: Icons.person,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Required'
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            appLocalizations.phone),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: phoneController,
                                          decoration: _dialogInputDecoration(
                                            hint: 'Phone number',
                                            icon: Icons.phone,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(appLocalizations.age),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: ageController,
                                          decoration: _dialogInputDecoration(
                                            hint: 'Age',
                                            icon: Icons.cake,
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (v) {
                                            if (v == null || v.trim().isEmpty) {
                                              return 'Required';
                                            }
                                            final age = int.tryParse(v.trim());
                                            if (age == null || age <= 0) {
                                              return 'Enter a valid age';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            appLocalizations.weightClass),
                                        const SizedBox(height: 6),
                                        DropdownButtonFormField<String>(
                                          initialValue: selectedWeightClass,
                                          decoration: _dialogInputDecoration(
                                            hint: '',
                                            icon: Icons.monitor_weight,
                                          ),
                                          isExpanded: true,
                                          items: weightClasses
                                              .map((weightClass) =>
                                                  DropdownMenuItem(
                                                    value: weightClass,
                                                    child: Text(
                                                      weightClass,
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (value) =>
                                              setDialogState(() {
                                            selectedWeightClass = value!;
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            appLocalizations.paymentMethod),
                                        const SizedBox(height: 6),
                                        DropdownButtonFormField<String>(
                                          initialValue: selectedPaymentMethod,
                                          decoration: _dialogInputDecoration(
                                            hint: '',
                                            icon: Icons.account_balance_wallet,
                                          ),
                                          isExpanded: true,
                                          items: paymentMethods
                                              .map((method) => DropdownMenuItem(
                                                    value: method,
                                                    child: Text(
                                                      method,
                                                      style: const TextStyle(
                                                          fontSize: 13),
                                                    ),
                                                  ))
                                              .toList(),
                                          onChanged: (value) =>
                                              setDialogState(() {
                                            selectedPaymentMethod = value!;
                                          }),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _dialogFieldLabel(appLocalizations.notes),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: notesController,
                                decoration: _dialogInputDecoration(
                                  hint: 'Optional notes',
                                  icon: Icons.notes,
                                ),
                                maxLines: 3,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: Text(
                              appLocalizations.cancel,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: Text(appLocalizations.saveChanges),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              await context
                                  .read<AppDataProvider>()
                                  .updateParticipant(
                                    id: participant['id'] as int,
                                    name: nameController.text.trim(),
                                    phone: phoneController.text.trim(),
                                    age: int.parse(ageController.text.trim()),
                                    weightClass: selectedWeightClass,
                                    paymentMethod: selectedPaymentMethod,
                                    notes: notesController.text.trim(),
                                  );

                              Navigator.pop(dialogContext, true);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) => value ?? false);
  }

  Future<bool> _showEditPaymentDialog(
    BuildContext context,
    Map<String, dynamic> payment,
  ) async {
    final appLocalizations = AppLocalizations.of(context)!;
    final paymentId = payment['id'] as int;
    final amountController = TextEditingController(
      text: (payment['amount'] as num?)?.toString() ?? '',
    );
    final descriptionController = TextEditingController(
      text: payment['description']?.toString() ?? '',
    );
    final methodController = TextEditingController(
      text: payment['method']?.toString() ?? '',
    );
    String selectedStatus =
        payment['status']?.toString() == 'paid' ? 'paid' : 'pending';

    final statusOptions = ['pending', 'paid'];

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 520,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFF9A0007)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white24,
                            radius: 22,
                            child: Icon(Icons.payments,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appLocalizations.editPayment,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Payment ID #$paymentId',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon:
                                const Icon(Icons.close, color: Colors.white70),
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _dialogFieldLabel(appLocalizations.participant),
                            const SizedBox(height: 6),
                            TextFormField(
                              initialValue:
                                  payment['participantName']?.toString() ?? '',
                              readOnly: true,
                              decoration: _dialogInputDecoration(
                                hint: '',
                                icon: Icons.person,
                              ),
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _dialogFieldLabel(
                                          appLocalizations.amount),
                                      const SizedBox(height: 6),
                                      TextFormField(
                                        controller: amountController,
                                        decoration: _dialogInputDecoration(
                                          hint: 'Amount',
                                          icon: Icons.attach_money,
                                        ),
                                        keyboardType: const TextInputType
                                            .numberWithOptions(decimal: true),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _dialogFieldLabel(
                                          appLocalizations.status),
                                      const SizedBox(height: 6),
                                      DropdownButtonFormField<String>(
                                        value: selectedStatus,
                                        decoration: _dialogInputDecoration(
                                          hint: '',
                                          icon: Icons.flag,
                                        ),
                                        isExpanded: true,
                                        items: statusOptions
                                            .map(
                                              (option) => DropdownMenuItem(
                                                value: option,
                                                child: Text(
                                                  option,
                                                  style: const TextStyle(
                                                      fontSize: 13),
                                                ),
                                              ),
                                            )
                                            .toList(),
                                        onChanged: (value) {
                                          setDialogState(() {
                                            selectedStatus = value!;
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            _dialogFieldLabel(appLocalizations.paymentMethod),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: methodController,
                              decoration: _dialogInputDecoration(
                                hint: 'Payment method',
                                icon: Icons.account_balance_wallet,
                              ),
                            ),
                            const SizedBox(height: 16),
                            _dialogFieldLabel(appLocalizations.description),
                            const SizedBox(height: 6),
                            TextFormField(
                              controller: descriptionController,
                              decoration: _dialogInputDecoration(
                                hint: 'Description',
                                icon: Icons.description,
                              ),
                              maxLines: 2,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: Text(
                              appLocalizations.cancel,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: Text(appLocalizations.saveChanges),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              await context
                                  .read<AppDataProvider>()
                                  .updatePaymentStatus(
                                    id: paymentId,
                                    status: selectedStatus,
                                  );

                              await context.read<AppDataProvider>().addPayment(
                                    participantName: payment['participantName']
                                            ?.toString() ??
                                        '',
                                    amount: double.tryParse(
                                            amountController.text.trim()) ??
                                        ((payment['amount'] as num?)
                                                ?.toDouble() ??
                                            0),
                                    description:
                                        descriptionController.text.trim(),
                                    method: methodController.text.trim(),
                                    status: selectedStatus,
                                  );

                              Navigator.pop(dialogContext, true);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) => value ?? false);
  }

  Future<bool> _showEditSessionDialog(
    BuildContext context,
    Map<String, dynamic> session,
  ) async {
    final appLocalizations = AppLocalizations.of(context)!;
    final formKey = GlobalKey<FormState>();
    final titleController =
        TextEditingController(text: session['title']?.toString() ?? '');
    final sessionTypeController =
        TextEditingController(text: session['sessionType']?.toString() ?? '');
    final dateController =
        TextEditingController(text: session['sessionDate']?.toString() ?? '');
    final timeController =
        TextEditingController(text: session['sessionTime']?.toString() ?? '');
    final durationController = TextEditingController(
        text: session['durationMinutes']?.toString() ?? '');

    final sessionId = session['id']?.toString() ?? '-';
    final initialDateTime = _sessionDateTime(session);

    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: SizedBox(
                width: 520,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFD32F2F), Color(0xFF9A0007)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Row(
                        children: [
                          const CircleAvatar(
                            backgroundColor: Colors.white24,
                            radius: 22,
                            child: Icon(Icons.calendar_month,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                appLocalizations.editSession,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Session ID #$sessionId',
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            icon:
                                const Icon(Icons.close, color: Colors.white70),
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                          ),
                        ],
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.all(24),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _dialogFieldLabel(
                                  '${appLocalizations.sessionTitle} *'),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: titleController,
                                decoration: _dialogInputDecoration(
                                  hint: 'e.g. Friday Sparring',
                                  icon: Icons.title,
                                ),
                                validator: (v) =>
                                    (v == null || v.trim().isEmpty)
                                        ? 'Required'
                                        : null,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    flex: 2,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            appLocalizations.sessionType),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: sessionTypeController,
                                          decoration: _dialogInputDecoration(
                                            hint: 'e.g. Group Training',
                                            icon: Icons.sports_mma,
                                          ),
                                          validator: (v) =>
                                              (v == null || v.trim().isEmpty)
                                                  ? 'Required'
                                                  : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            appLocalizations.duration),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: durationController,
                                          decoration: _dialogInputDecoration(
                                            hint: 'min',
                                            icon: Icons.timer_outlined,
                                          ),
                                          keyboardType: TextInputType.number,
                                          validator: (v) {
                                            if (v == null || v.trim().isEmpty) {
                                              return 'Required';
                                            }
                                            if (int.tryParse(v.trim()) ==
                                                null) {
                                              return 'Enter a number';
                                            }
                                            return null;
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            appLocalizations.date),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: dateController,
                                          readOnly: true,
                                          decoration: _dialogInputDecoration(
                                            hint: appLocalizations.selectDate,
                                            icon: Icons.event,
                                          ),
                                          onTap: () async {
                                            final now = DateTime.now();
                                            final initialDate =
                                                initialDateTime ?? now;
                                            final DateTime? picked =
                                                await showDatePicker(
                                              context: context,
                                              initialDate: initialDate,
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(now.year + 10),
                                            );
                                            if (picked != null &&
                                                context.mounted) {
                                              setDialogState(() {
                                                dateController.text =
                                                    '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                                              });
                                            }
                                          },
                                          validator: (v) =>
                                              (v == null || v.trim().isEmpty)
                                                  ? 'Required'
                                                  : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel(
                                            appLocalizations.sessionTime),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: timeController,
                                          readOnly: true,
                                          decoration: _dialogInputDecoration(
                                            hint: appLocalizations.selectTime,
                                            icon: Icons.access_time,
                                          ),
                                          onTap: () async {
                                            final initialTime =
                                                initialDateTime != null
                                                    ? TimeOfDay.fromDateTime(
                                                        initialDateTime)
                                                    : TimeOfDay.now();
                                            final TimeOfDay? picked =
                                                await showTimePicker(
                                              context: context,
                                              initialTime: initialTime,
                                            );
                                            if (picked != null &&
                                                context.mounted) {
                                              setDialogState(() {
                                                timeController.text =
                                                    picked.format(context);
                                              });
                                            }
                                          },
                                          validator: (v) =>
                                              (v == null || v.trim().isEmpty)
                                                  ? 'Required'
                                                  : null,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () =>
                                Navigator.pop(dialogContext, false),
                            child: Text(
                              appLocalizations.cancel,
                              style: const TextStyle(color: Colors.grey),
                            ),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: Text(appLocalizations.saveChanges),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () async {
                              if (!formKey.currentState!.validate()) {
                                return;
                              }

                              await context
                                  .read<AppDataProvider>()
                                  .updateSession(
                                    id: session['id'] as int,
                                    title: titleController.text.trim(),
                                    sessionType:
                                        sessionTypeController.text.trim(),
                                    durationMinutes: int.parse(
                                        durationController.text.trim()),
                                    sessionDate: dateController.text.trim(),
                                    sessionTime: timeController.text.trim(),
                                  );
                              Navigator.pop(dialogContext, true);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    ).then((value) => value ?? false);
  }

  void _showFabMenu(BuildContext context, AppLocalizations appLocalizations) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.only(top: 12, bottom: 8),
                height: 4,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    appLocalizations.quickActions,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFD32F2F),
                    ),
                  ),
                ),
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFEBEE),
                  child: Icon(Icons.person_add, color: Color(0xFFD32F2F)),
                ),
                title: Text(appLocalizations.addParticipant,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  _showAddParticipantDialog(context);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFEBEE),
                  child: Icon(Icons.calendar_today, color: Color(0xFFD32F2F)),
                ),
                title: Text(appLocalizations.scheduleSession,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  _showScheduleSessionDialog(context);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFEBEE),
                  child: Icon(Icons.payment, color: Color(0xFFD32F2F)),
                ),
                title: Text(appLocalizations.recordPayment,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  _showRecordPaymentDialog(context);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFEBEE),
                  child: Icon(Icons.checklist, color: Color(0xFFD32F2F)),
                ),
                title: Text(appLocalizations.takeAttendance,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  _showTakeAttendanceDialog(context);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFFEBEE),
                  child: Icon(Icons.backup, color: Color(0xFFD32F2F)),
                ),
                title: Text(appLocalizations.backupDatabase,
                    style: const TextStyle(fontWeight: FontWeight.w500)),
                onTap: () {
                  Navigator.pop(context);
                  _backupDatabase(context);
                },
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final localeProvider = Provider.of<LocaleProvider>(context, listen: false);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(appLocalizations.language),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(appLocalizations.english),
                onTap: () {
                  localeProvider.setLocale(const Locale('en'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(appLocalizations.arabic),
                onTap: () {
                  localeProvider.setLocale(const Locale('ar'));
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.language),
                title: Text(appLocalizations.hebrew),
                onTap: () {
                  localeProvider.setLocale(const Locale('he'));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _backupDatabase(BuildContext context) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final backupFile = await context.read<AppDataProvider>().createBackup();
      if (!mounted) {
        return;
      }

      messenger.showSnackBar(
        SnackBar(
          content: Text('Backup saved to ${backupFile.path}'),
          action: SnackBarAction(
            label: 'Copy',
            onPressed: () => Clipboard.setData(
              ClipboardData(text: backupFile.path),
            ),
          ),
        ),
      );
    } catch (error) {
      if (!mounted) {
        return;
      }
      messenger.showSnackBar(
        SnackBar(content: Text('Backup failed: $error')),
      );
    }
  }
}
