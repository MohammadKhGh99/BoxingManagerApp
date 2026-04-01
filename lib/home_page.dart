import 'package:flutter/material.dart';
import 'package:boxing_coach_manager/app_localizations.dart';
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
    final isRTL = Directionality.of(context) == TextDirection.rtl;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.title),
        actions: [
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
            _buildStatsCards(context, appLocalizations),

            // Main content
            const SizedBox(height: 20),
            _buildMainContent(context, appLocalizations, isRTL),
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

  Widget _buildStatsCards(
      BuildContext context, AppLocalizations appLocalizations) {
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
          value: "24",
          label: appLocalizations.totalParticipants,
          context: context,
        ),
        _buildStatCard(
          icon: Icons.calendar_today,
          value: "18",
          label: appLocalizations.sessionsThisMonth,
          context: context,
        ),
        _buildStatCard(
          icon: Icons.attach_money,
          value: "\$1,240",
          label: appLocalizations.revenueThisMonth,
          context: context,
        ),
        _buildStatCard(
          icon: Icons.percent,
          value: "92%",
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
      BuildContext context, AppLocalizations appLocalizations, bool isRTL) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 3,
          child: Column(
            children: [
              // Today's session
              _buildTodaysSession(context, appLocalizations),

              // Recent attendance
              const SizedBox(height: 20),
              _buildRecentAttendance(context, appLocalizations),
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
              _buildUpcomingSessions(context, appLocalizations),

              // Pending payments
              const SizedBox(height: 20),
              _buildPendingPayments(context, appLocalizations),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTodaysSession(
      BuildContext context, AppLocalizations appLocalizations) {
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
            _buildSessionCard(
              title: "Advanced Sparring Session",
              date: "Today, 6:00 PM - 8:00 PM",
              description:
                  "Focus on defensive techniques and counter-punching drills.",
              participants: const [
                {"name": "Mike Tyson", "paid": false},
                {"name": "Muhammad Ali", "paid": true},
                {"name": "Floyd Mayweather", "paid": false},
                {"name": "George Foreman", "paid": false},
                {"name": "Manny Pacquiao", "paid": true},
              ],
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
                return Chip(
                  backgroundColor:
                      participant['paid'] ? Colors.green[50] : Colors.blue[50],
                  label: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        participant['paid'] ? Icons.check : Icons.person,
                        size: 16,
                        color: participant['paid'] ? Colors.green : Colors.blue,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        participant['name'],
                        style: TextStyle(
                          color:
                              participant['paid'] ? Colors.green : Colors.blue,
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

  Widget _buildRecentAttendance(
      BuildContext context, AppLocalizations appLocalizations) {
    final attendanceData = [
      {
        "participant": "Mike Tyson",
        "session": "Advanced Technique",
        "date": "Jun 3, 2024",
        "status": "attended",
        "payment": "paid"
      },
      {
        "participant": "Muhammad Ali",
        "session": "Footwork Drills",
        "date": "Jun 3, 2024",
        "status": "attended",
        "payment": "paid"
      },
      {
        "participant": "George Foreman",
        "session": "Strength Training",
        "date": "Jun 2, 2024",
        "status": "absent",
        "payment": "pending"
      },
      {
        "participant": "Floyd Mayweather",
        "session": "Defense Techniques",
        "date": "Jun 1, 2024",
        "status": "attended",
        "payment": "paid"
      },
      {
        "participant": "Manny Pacquiao",
        "session": "Speed Training",
        "date": "May 31, 2024",
        "status": "attended",
        "payment": "paid"
      },
    ];

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
                    DataCell(Text(data['participant'] ?? 'Unknown')),
                    DataCell(Text(data['session'] ?? 'Unknown')),
                    DataCell(Text(data['date'] ?? 'Unknown')),
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
                        backgroundColor: data['payment'] == 'paid'
                            ? Colors.blue[50]
                            : Colors.orange[50],
                        label: Text(
                          data['payment'] == 'paid'
                              ? appLocalizations.paid
                              : appLocalizations.pending,
                          style: TextStyle(
                            color: data['payment'] == 'paid'
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

  Widget _buildUpcomingSessions(
      BuildContext context, AppLocalizations appLocalizations) {
    final sessions = [
      {
        "title": "Beginner's Class",
        "date": "Tomorrow, 5:00 PM",
        "participants": "6"
      },
      {
        "title": "Sparring Session",
        "date": "Jun 7, 6:30 PM",
        "participants": "8"
      },
      {
        "title": "Conditioning & Fitness",
        "date": "Jun 9, 10:00 AM",
        "participants": "12"
      },
      {
        "title": "Advanced Techniques",
        "date": "Jun 11, 7:00 PM",
        "participants": "5"
      },
    ];

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
                            session['date']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                          Text(
                            session['title']!,
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
                            "${session['participants']} ${appLocalizations.participants}"),
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

  Widget _buildPendingPayments(
      BuildContext context, AppLocalizations appLocalizations) {
    final payments = [
      {
        "name": "George Foreman",
        "description": "2 sessions overdue",
        "amount": "\$120"
      },
      {
        "name": "Evander Holyfield",
        "description": "Monthly fee",
        "amount": "\$200"
      },
      {
        "name": "Joe Frazier",
        "description": "Private session",
        "amount": "\$80"
      },
    ];

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
                            payment['name']!,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            payment['description']!,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Chip(
                        backgroundColor: Colors.orange[50],
                        label: Text(
                          payment['amount']!,
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
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add New Participant',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Fill in the details below',
                                style: TextStyle(
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
                              _dialogFieldLabel('Full Name *'),
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
                                        _dialogFieldLabel('Phone Number *'),
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
                                        _dialogFieldLabel('Age *'),
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
                                        _dialogFieldLabel('Weight Class'),
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
                                        _dialogFieldLabel('Payment Method'),
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
                              _dialogFieldLabel('Notes'),
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
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text('Save Participant'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
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
    final formKey = GlobalKey<FormState>();
    final titleController = TextEditingController();
    final dateController = TextEditingController();
    final timeController = TextEditingController();
    final durationController = TextEditingController();
    String selectedType = 'Sparring';

    final sessionTypes = [
      'Sparring',
      'Technique',
      'Conditioning',
      'Private Coaching',
      'Kids Class',
      'Beginner Class',
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
                            child: Icon(Icons.calendar_month,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Schedule Session',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Plan a future training class',
                                style: TextStyle(
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
                              _dialogFieldLabel('Session Title *'),
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
                                        _dialogFieldLabel('Session Type'),
                                        const SizedBox(height: 6),
                                        DropdownButtonFormField<String>(
                                          initialValue: selectedType,
                                          decoration: _dialogInputDecoration(
                                            hint: '',
                                            icon: Icons.sports_mma,
                                          ),
                                          isExpanded: true,
                                          items: sessionTypes
                                              .map((s) => DropdownMenuItem(
                                                  value: s,
                                                  child: Text(s,
                                                      style: const TextStyle(
                                                          fontSize: 13))))
                                              .toList(),
                                          onChanged: (v) => setDialogState(
                                              () => selectedType = v!),
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
                                        _dialogFieldLabel('Duration'),
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
                                        _dialogFieldLabel('Date'),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: dateController,
                                          readOnly: true,
                                          decoration: _dialogInputDecoration(
                                            hint: 'Select Date',
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
                                        _dialogFieldLabel('Time'),
                                        const SizedBox(height: 6),
                                        TextFormField(
                                          controller: timeController,
                                          readOnly: true,
                                          decoration: _dialogInputDecoration(
                                            hint: 'Select Time',
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
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text('Schedule'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
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
    final formKey = GlobalKey<FormState>();
    final amountController = TextEditingController();
    String selectedParticipant = 'Mike Tyson';
    String selectedPaymentMethod = 'Cash';

    final mockParticipants = [
      'Mike Tyson',
      'Muhammad Ali',
      'Floyd Mayweather',
      'George Foreman',
      'Manny Pacquiao',
    ];

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
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Record Payment',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Log a new transaction',
                                style: TextStyle(
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
                              _dialogFieldLabel('Participant'),
                              const SizedBox(height: 6),
                              DropdownButtonFormField<String>(
                                initialValue: selectedParticipant,
                                decoration: _dialogInputDecoration(
                                  hint: '',
                                  icon: Icons.person,
                                ),
                                isExpanded: true,
                                items: mockParticipants
                                    .map((p) => DropdownMenuItem(
                                        value: p,
                                        child: Text(p,
                                            style:
                                                const TextStyle(fontSize: 13))))
                                    .toList(),
                                onChanged: (v) => setDialogState(
                                    () => selectedParticipant = v!),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        _dialogFieldLabel('Amount (\$) *'),
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
                                        _dialogFieldLabel('Method'),
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
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text('Save Payment'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        'Payment of \$${amountController.text} from $selectedParticipant recorded.'),
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

  void _showTakeAttendanceDialog(BuildContext context) {
    String selectedSession = 'Advanced Sparring (Today)';
    String selectedParticipant = 'George Foreman';
    String selectedStatus = 'Present';

    final mockSessions = [
      'Advanced Sparring (Today)',
      'Beginner Class (Tomorrow)',
      'Conditioning (Wednesday)',
    ];

    final mockParticipants = [
      'Mike Tyson',
      'Muhammad Ali',
      'Floyd Mayweather',
      'George Foreman',
      'Manny Pacquiao',
    ];

    final statusOptions = ['Present', 'Absent', 'Late', 'Excused'];

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
                            child: Icon(Icons.how_to_reg,
                                color: Colors.white, size: 22),
                          ),
                          const SizedBox(width: 14),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Mark Attendance',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Record presence for a session',
                                style: TextStyle(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _dialogFieldLabel('Session'),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              initialValue: selectedSession,
                              decoration: _dialogInputDecoration(
                                hint: '',
                                icon: Icons.sports_mma,
                              ),
                              isExpanded: true,
                              items: mockSessions
                                  .map((s) => DropdownMenuItem(
                                      value: s,
                                      child: Text(s,
                                          style:
                                              const TextStyle(fontSize: 13))))
                                  .toList(),
                              onChanged: (v) =>
                                  setDialogState(() => selectedSession = v!),
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
                                      _dialogFieldLabel('Participant'),
                                      const SizedBox(height: 6),
                                      DropdownButtonFormField<String>(
                                        initialValue: selectedParticipant,
                                        decoration: _dialogInputDecoration(
                                          hint: '',
                                          icon: Icons.person,
                                        ),
                                        isExpanded: true,
                                        items: mockParticipants
                                            .map((p) => DropdownMenuItem(
                                                value: p,
                                                child: Text(p,
                                                    style: const TextStyle(
                                                        fontSize: 13))))
                                            .toList(),
                                        onChanged: (v) => setDialogState(
                                            () => selectedParticipant = v!),
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
                                      _dialogFieldLabel('Status'),
                                      const SizedBox(height: 6),
                                      DropdownButtonFormField<String>(
                                        initialValue: selectedStatus,
                                        decoration: _dialogInputDecoration(
                                          hint: '',
                                          icon: Icons.flag,
                                        ),
                                        isExpanded: true,
                                        items: statusOptions
                                            .map((o) => DropdownMenuItem(
                                                value: o,
                                                child: Text(o,
                                                    style: const TextStyle(
                                                        fontSize: 13))))
                                            .toList(),
                                        onChanged: (v) => setDialogState(
                                            () => selectedStatus = v!),
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
                    Container(
                      padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel',
                                style: TextStyle(color: Colors.grey)),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton.icon(
                            icon: const Icon(Icons.check),
                            label: const Text('Save'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFD32F2F),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              Navigator.pop(context);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      '$selectedParticipant marked $selectedStatus.'),
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
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Quick Actions',
                    style: TextStyle(
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
}
