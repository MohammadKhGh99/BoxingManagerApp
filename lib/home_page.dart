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
        onPressed: () {},
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

  Widget _buildStatsCards(BuildContext context, AppLocalizations appLocalizations) {
    return GridView.count(
      crossAxisCount: 2,
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

  Widget _buildMainContent(BuildContext context, AppLocalizations appLocalizations, bool isRTL) {
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

  Widget _buildTodaysSession(BuildContext context, AppLocalizations appLocalizations) {
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
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSessionCard(
              title: "Advanced Sparring Session",
              date: "Today, 6:00 PM - 8:00 PM",
              description: "Focus on defensive techniques and counter-punching drills.",
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
                  backgroundColor: participant['paid'] ? Colors.green[50] : Colors.blue[50],
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
                          color: participant['paid'] ? Colors.green : Colors.blue,
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

  Widget _buildRecentAttendance(BuildContext context, AppLocalizations appLocalizations) {
    final attendanceData = [
      {"participant": "Mike Tyson", "session": "Advanced Technique", "date": "Jun 3, 2024", "status": "attended", "payment": "paid"},
      {"participant": "Muhammad Ali", "session": "Footwork Drills", "date": "Jun 3, 2024", "status": "attended", "payment": "paid"},
      {"participant": "George Foreman", "session": "Strength Training", "date": "Jun 2, 2024", "status": "absent", "payment": "pending"},
      {"participant": "Floyd Mayweather", "session": "Defense Techniques", "date": "Jun 1, 2024", "status": "attended", "payment": "paid"},
      {"participant": "Manny Pacquiao", "session": "Speed Training", "date": "May 31, 2024", "status": "attended", "payment": "paid"},
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

  Widget _buildAddNewSection(BuildContext context, AppLocalizations appLocalizations) {
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
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                _buildAddButton(
                  icon: Icons.calendar_today,
                  text: appLocalizations.scheduleSession,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                _buildAddButton(
                  icon: Icons.payment,
                  text: appLocalizations.recordPayment,
                  onPressed: () {},
                ),
                const SizedBox(height: 10),
                _buildAddButton(
                  icon: Icons.checklist,
                  text: appLocalizations.takeAttendance,
                  onPressed: () {},
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

  Widget _buildUpcomingSessions(BuildContext context, AppLocalizations appLocalizations) {
    final sessions = [
      {"title": "Beginner's Class", "date": "Tomorrow, 5:00 PM", "participants": "6"},
      {"title": "Sparring Session", "date": "Jun 7, 6:30 PM", "participants": "8"},
      {"title": "Conditioning & Fitness", "date": "Jun 9, 10:00 AM", "participants": "12"},
      {"title": "Advanced Techniques", "date": "Jun 11, 7:00 PM", "participants": "5"},
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
                    fontSize: 18,
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
                            ),
                          ),
                          Text(
                            session['title']!,
                            style: const TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                      Chip(
                        backgroundColor: Colors.blue[50],
                        label: Text("${session['participants']} ${appLocalizations.participants}"),
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

  Widget _buildPendingPayments(BuildContext context, AppLocalizations appLocalizations) {
    final payments = [
      {"name": "George Foreman", "description": "2 sessions overdue", "amount": "\$120"},
      {"name": "Evander Holyfield", "description": "Monthly fee", "amount": "\$200"},
      {"name": "Joe Frazier", "description": "Private session", "amount": "\$80"},
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
