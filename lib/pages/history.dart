import 'package:flutter/material.dart';
import '../components/navbar.dart'; // ✅ import component
import 'addmed.dart';
import 'homepage.dart';
import 'searchpage.dart';
import 'settings_page.dart';
import 'amount.dart';

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> historyItems = [
    {
      "pillName": "Pill Name #1",
      "amount": "2",
      "date": "2024-04-01",
      "time": "08:00 AM"
    },
    {
      "pillName": "Pill Name #2",
      "amount": "1",
      "date": "2024-04-03",
      "time": "12:00 PM"
    },
    {
      "pillName": "Pill Name #3",
      "amount": "3",
      "date": "2024-04-05",
      "time": "06:00 PM"
    },
  ];

  void _onTabTapped(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => AmountPage()));
    } else if (index == 2) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchPage()));
    } else if (index == 3) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => const SettingsPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3047),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E3047),
        elevation: 0,
        centerTitle: true,
        title: const Text('History', style: TextStyle(fontSize: 24)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 80),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                'Medication History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: historyItems.length,
                itemBuilder: (context, index) {
                  final item = historyItems[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E2230),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black26, blurRadius: 4, offset: Offset(2, 2))
                      ],
                    ),
                    child: IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const CircleAvatar(
                            radius: 26,
                            backgroundColor: Colors.black26,
                            child: Icon(Icons.camera_alt, color: Colors.grey),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['pillName'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Amount: ${item['amount']}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    const Icon(Icons.calendar_today, color: Colors.white70, size: 16),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        item['date'],
                                        style: const TextStyle(color: Colors.white70),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    const Icon(Icons.access_time, color: Colors.white70, size: 16),
                                    const SizedBox(width: 4),
                                    Flexible(
                                      child: Text(
                                        item['time'],
                                        style: const TextStyle(color: Colors.white70),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.redAccent,
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child: const Text('Delete', style: TextStyle(color: Colors.white)),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        child: const Icon(Icons.favorite, color: Colors.black, size: 32),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddMedicinePage()));
        },
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        currentIndex: -1, // ✅ ไม่มีปุ่ม history ใน navbar
        onTap: (index) => _onTabTapped(context, index),
      ),
    );
  }
}