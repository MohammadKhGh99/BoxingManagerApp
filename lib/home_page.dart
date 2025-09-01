import 'package:flutter/material.dart';
import 'package:boxing_coach_manager/app_localizations.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text(appLocalizations.title),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            onPressed: () => _showLanguageDialog(context),
          ),
        ],
      ),
      body: _selectedIndex == 0
          ? _buildDashboard(context, appLocalizations, screenWidth)
          : _selectedIndex == 1
          ? _buildSessionsPage(context, appLocalizations)
          : _selectedIndex == 2
          ? _buildParticipantsPage(context, appLocalizations)
          : _buildMorePage(context, appLocalizations),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.red,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.dashboard),
            label: appLocalizations.dashboard,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_today),
            label: appLocalizations.sessions,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.people),
            label: appLocalizations.participants,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.more_horiz),
            label: appLocalizations.more,
          ),
        ],
      ),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: () => _showAddOptions(context, appLocalizations),
              backgroundColor: Colors.red,
              child: const Icon(Icons.add, color: Colors.white),
            )
          : null,
    );
  }

  Widget _buildDashboard(
    BuildContext context,
    AppLocalizations appLocalizations,
    double screenWidth,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          _buildHeader(context, appLocalizations),

          // Stats Cards
          const SizedBox(height: 20),
          _buildStatsCards(context, appLocalizations, screenWidth),

          // Today's session
          const SizedBox(height: 20),
          _buildTodaysSession(context, appLocalizations),

          // Recent attendance
          const SizedBox(height: 20),
          _buildRecentAttendanceMobile(context, appLocalizations),

          // Quick actions
          const SizedBox(height: 20),
          _buildQuickActions(context, appLocalizations),
        ],
      ),
    );
  }

  Widget _buildSessionsPage(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations.upcomingSessions,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildUpcomingSessionsMobile(context, appLocalizations),
        ],
      ),
    );
  }

  Widget _buildParticipantsPage(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations.participants,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildParticipantsList(context, appLocalizations),
        ],
      ),
    );
  }

  Widget _buildMorePage(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            appLocalizations.more,
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          _buildPendingPayments(context, appLocalizations),
          const SizedBox(height: 16),
          _buildSettingsOptions(context, appLocalizations),
        ],
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
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sports_mma, color: Colors.amber, size: 36),
              const SizedBox(width: 15),
              Expanded(
                child: Text(
                  appLocalizations.title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 25,
                child: Icon(Icons.person, size: 30, color: Colors.red),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            appLocalizations.subtitle,
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(
    BuildContext context,
    AppLocalizations appLocalizations,
    double screenWidth,
  ) {
    final crossAxisCount = screenWidth > 600 ? 4 : 2;

    return GridView.count(
      crossAxisCount: crossAxisCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 15,
      crossAxisSpacing: 15,
      childAspectRatio: crossAxisCount == 4 ? 1.1 : 1.3,
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
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32, color: Colors.red),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaysSession(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                  icon: const Icon(Icons.add, size: 16),
                  label: Text(appLocalizations.newSession),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.red, width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Advanced Sparring Session",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Today, 6:00 PM - 8:00 PM",
                    style: TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Focus on defensive techniques and counter-punching drills.",
                  ),
                  const SizedBox(height: 15),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildParticipantChip("Mike Tyson", false),
                      _buildParticipantChip("Muhammad Ali", true),
                      _buildParticipantChip("Floyd Mayweather", false),
                      _buildParticipantChip("George Foreman", false),
                      _buildParticipantChip("Manny Pacquiao", true),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildParticipantChip(String name, bool paid) {
    return Chip(
      backgroundColor: paid ? Colors.green[50] : Colors.blue[50],
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            paid ? Icons.check : Icons.person,
            size: 16,
            color: paid ? Colors.green : Colors.blue,
          ),
          const SizedBox(width: 5),
          Text(
            name,
            style: TextStyle(
              color: paid ? Colors.green : Colors.blue,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentAttendanceMobile(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    final attendanceData = [
      {
        "participant": "Mike Tyson",
        "session": "Advanced Technique",
        "date": "Jun 3, 2024",
        "status": "attended",
        "payment": "paid",
      },
      {
        "participant": "Muhammad Ali",
        "session": "Footwork Drills",
        "date": "Jun 3, 2024",
        "status": "attended",
        "payment": "paid",
      },
      {
        "participant": "George Foreman",
        "session": "Strength Training",
        "date": "Jun 2, 2024",
        "status": "absent",
        "payment": "pending",
      },
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            const SizedBox(height: 15),
            ...attendanceData.map(
              (data) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.grey[50],
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: data['status'] == 'attended'
                        ? Colors.green
                        : Colors.red,
                    child: Icon(
                      data['status'] == 'attended' ? Icons.check : Icons.close,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  title: Text(data['participant']!),
                  subtitle: Text('${data['session']} • ${data['date']}'),
                  trailing: Chip(
                    backgroundColor: data['payment'] == 'paid'
                        ? Colors.green[50]
                        : Colors.orange[50],
                    label: Text(
                      data['payment'] == 'paid'
                          ? appLocalizations.paid
                          : appLocalizations.pending,
                      style: TextStyle(
                        color: data['payment'] == 'paid'
                            ? Colors.green
                            : Colors.orange,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.flash_on, color: Colors.red),
                SizedBox(width: 10),
                Text(
                  'Quick Actions',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildQuickActionButton(
                  icon: Icons.person_add,
                  label: 'Add\nParticipant',
                  onPressed: () {},
                ),
                _buildQuickActionButton(
                  icon: Icons.check_circle,
                  label: 'Take\nAttendance',
                  onPressed: () {},
                ),
                _buildQuickActionButton(
                  icon: Icons.payment,
                  label: 'Record\nPayment',
                  onPressed: () {},
                ),
                _buildQuickActionButton(
                  icon: Icons.schedule,
                  label: 'Schedule\nSession',
                  onPressed: () {},
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return GestureDetector(
      onTap: onPressed,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.red, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildUpcomingSessionsMobile(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    final sessions = [
      {
        "title": "Beginner's Class",
        "date": "Tomorrow, 5:00 PM",
        "participants": "6",
      },
      {
        "title": "Sparring Session",
        "date": "Jun 7, 6:30 PM",
        "participants": "8",
      },
      {
        "title": "Conditioning & Fitness",
        "date": "Jun 9, 10:00 AM",
        "participants": "12",
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: sessions.length,
      itemBuilder: (context, index) {
        final session = sessions[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.fitness_center, color: Colors.red),
            ),
            title: Text(session['title']!),
            subtitle: Text(session['date']!),
            trailing: Chip(
              backgroundColor: Colors.blue[50],
              label: Text(
                '${session['participants']} ${appLocalizations.participants}',
                style: const TextStyle(fontSize: 12),
              ),
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildParticipantsList(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    final participants = [
      {"name": "Mike Tyson", "status": "Active", "lastSession": "Today"},
      {"name": "Muhammad Ali", "status": "Active", "lastSession": "Yesterday"},
      {
        "name": "Floyd Mayweather",
        "status": "Pending",
        "lastSession": "3 days ago",
      },
      {
        "name": "George Foreman",
        "status": "Active",
        "lastSession": "1 week ago",
      },
    ];

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: participants.length,
      itemBuilder: (context, index) {
        final participant = participants[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: participant['status'] == 'Active'
                  ? Colors.green
                  : Colors.orange,
              child: Text(
                participant['name']![0],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            title: Text(participant['name']!),
            subtitle: Text('Last session: ${participant['lastSession']}'),
            trailing: Chip(
              backgroundColor: participant['status'] == 'Active'
                  ? Colors.green[50]
                  : Colors.orange[50],
              label: Text(
                participant['status']!,
                style: TextStyle(
                  color: participant['status'] == 'Active'
                      ? Colors.green
                      : Colors.orange,
                  fontSize: 12,
                ),
              ),
            ),
            onTap: () {},
          ),
        );
      },
    );
  }

  Widget _buildPendingPayments(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    final payments = [
      {
        "name": "George Foreman",
        "description": "2 sessions overdue",
        "amount": "\$120",
      },
      {
        "name": "Evander Holyfield",
        "description": "Monthly fee",
        "amount": "\$200",
      },
      {
        "name": "Joe Frazier",
        "description": "Private session",
        "amount": "\$80",
      },
    ];

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
            ...payments.map(
              (payment) => Card(
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: Colors.orange[50],
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Colors.orange,
                    child: Icon(
                      Icons.attach_money,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  title: Text(payment['name']!),
                  subtitle: Text(payment['description']!),
                  trailing: Text(
                    payment['amount']!,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.orange,
                    ),
                  ),
                  onTap: () {},
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsOptions(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          ListTile(
            leading: const Icon(Icons.language, color: Colors.red),
            title: Text(appLocalizations.language),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _showLanguageDialog(context),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.red),
            title: const Text('Settings'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.help, color: Colors.red),
            title: const Text('Help & Support'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.info, color: Colors.red),
            title: const Text('About'),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  void _showAddOptions(
    BuildContext context,
    AppLocalizations appLocalizations,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                appLocalizations.addNew,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildBottomSheetOption(
                icon: Icons.person_add,
                title: appLocalizations.addParticipant,
                onTap: () => Navigator.pop(context),
              ),
              _buildBottomSheetOption(
                icon: Icons.calendar_today,
                title: appLocalizations.scheduleSession,
                onTap: () => Navigator.pop(context),
              ),
              _buildBottomSheetOption(
                icon: Icons.payment,
                title: appLocalizations.recordPayment,
                onTap: () => Navigator.pop(context),
              ),
              _buildBottomSheetOption(
                icon: Icons.checklist,
                title: appLocalizations.takeAttendance,
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildBottomSheetOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, color: Colors.red),
      ),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
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
