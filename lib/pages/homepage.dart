import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'addmed.dart';
import 'settings_page.dart';
import 'searchpage.dart';
import 'amount.dart';
import 'history.dart';
import '../components/navbar.dart';
import '../helpers/database.dart';
import '../models/medicine.dart';
import 'package:shared_preferences/shared_preferences.dart';


class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  String profileImage = "https://via.placeholder.com/150";
  DateTime selectedDate = DateTime.now();
  List<Medicine> _medicines = [];

  void _onItemTapped(int index) async {
    if (index == 0) return;
    if (index == 1) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => AmountPage()),
      );
    } else if (index == 2) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SearchPage()),
      );
    } else if (index == 3) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsPage()),
      );
      await _loadUserData(); // ✅ โหลดทั้งชื่อและรูป
    }
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(data: ThemeData.dark(), child: child!);
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
      await _loadMedicines();
    }
  }

  String _monthYearString(DateTime date) {
    final monthNames = [
      "January", "February", "March", "April", "May", "June",
      "July", "August", "September", "October", "November", "December"
    ];
    return "${monthNames[date.month - 1]} ${date.year}";
  }

  List<DateTime> getWeekDates(DateTime centerDate) {
    final int weekday = centerDate.weekday;
    final startOfWeek = centerDate.subtract(Duration(days: weekday - 1));
    return List.generate(7, (i) => startOfWeek.add(Duration(days: i)));
  }

  Future<void> _loadMedicines() async {
    final meds = await DatabaseHelper.instance.getMedicinesByDate(DateFormat('yyyy-MM-dd').format(selectedDate));
    setState(() {
      _medicines = meds;
    });
  }

  @override
  void initState() {
    super.initState();
    _loadMedicines();
    // _loadUsername();
    _loadUserData();
  }

  String? _profileImagePath;
  String _username = "User";
  File? _profileImage;

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';

      final imagePath = prefs.getString('profile_image_path');
      if (imagePath != null) {
        _profileImage = File(imagePath);
      } else {
        profileImage =
            prefs.getString('profileImage') ??
            "https://via.placeholder.com/150";
      }
    });
  }

  // Future<void> _loadUsername() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   setState(() {
  //     _username = prefs.getString('username') ?? "User";
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3047),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Colors.white,
                  backgroundImage:
                      _profileImage != null
                          ? FileImage(_profileImage!) as ImageProvider
                          : NetworkImage(profileImage),
                ),
                const SizedBox(width: 12),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Hi, $_username",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const Text(
                      "Welcome to PillMate",
                      style: TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.receipt_long, color: Colors.white),
                  onPressed: () async {
                    await Navigator.push(context, MaterialPageRoute(builder: (_) => const HistoryPage()));
                    _loadMedicines();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GestureDetector(
              onTap: _pickDate,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _monthYearString(selectedDate),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: getWeekDates(selectedDate).map((date) {
                final isSelected = DateFormat('yyyy-MM-dd').format(date) ==
                    DateFormat('yyyy-MM-dd').format(selectedDate);
                final weekdayLabel = DateFormat('E').format(date);
                return Column(
                  children: [
                    Text(
                      weekdayLabel.substring(0, 2),
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 6),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedDate = date;
                        });
                        _loadMedicines();
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.greenAccent[400] : Colors.transparent,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          "${date.day}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.black : Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Pills To Take", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left, size: 18, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          selectedDate = selectedDate.subtract(const Duration(days: 1));
                        });
                        _loadMedicines();
                      },
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.chevron_right, size: 18, color: Colors.white),
                      onPressed: () {
                        setState(() {
                          selectedDate = selectedDate.add(const Duration(days: 1));
                        });
                        _loadMedicines();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: _medicines.map((med) {
                return PillCard(name: med.name, dose: "${med.dose} pills", time: med.time, initialTaken: false);
              }).toList(),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddMedicinePage(selectedDate: selectedDate),
            ),
          ).then((_) => _loadMedicines());
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.favorite, color: Colors.black, size: 32),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class PillCard extends StatefulWidget {
  final String name;
  final String dose;
  final String time;
  final bool initialTaken;

  const PillCard({
    super.key,
    required this.name,
    required this.dose,
    required this.time,
    required this.initialTaken,
  });

  @override
  State<PillCard> createState() => _PillCardState();
}

class _PillCardState extends State<PillCard> {
  late bool isTaken;

  @override
  void initState() {
    super.initState();
    isTaken = widget.initialTaken;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Checkbox(
          value: isTaken,
          onChanged: (value) {
            setState(() {
              isTaken = value!;
            });
          },
        ),
        title: Text(
          widget.name,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        subtitle: Text("${widget.dose} / ${widget.time}", style: TextStyle(color: Colors.grey[300])),
        trailing: ElevatedButton(
          onPressed: () {
            setState(() {
              isTaken = !isTaken;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: isTaken ? Colors.green[100] : Colors.grey[800],
          ),
          child: Text(
            isTaken ? "TAKEN" : "TAKE",
            style: TextStyle(color: isTaken ? Colors.black : Colors.white),
          ),
        ),
      ),
    );
  }
}