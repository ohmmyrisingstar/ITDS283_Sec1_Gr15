import 'package:flutter/material.dart';
import '../components/navbar.dart'; // ✅ เพิ่ม navbar component
import 'addmed.dart';
import 'homepage.dart';
import 'searchpage.dart';
import 'settings_page.dart';

class AmountPage extends StatelessWidget {
  final List<Map<String, dynamic>> pills = [
    {"name": "Paracetamol", "amount": 1},
    {"name": "Vitamins", "amount": 2},
    {"name": "Vitamins", "amount": 3},
  ];

  void _onTabTapped(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
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
        title: const Text("Amount", style: TextStyle(fontSize: 22)),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
        itemCount: pills.length,
        itemBuilder: (context, index) {
          return PillCard(
            pillName: pills[index]['name'],
            initialAmount: pills[index]['amount'],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AddMedicinePage()));
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.favorite, color: Colors.black, size: 32),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        currentIndex: 1,
        onTap: (index) => _onTabTapped(context, index),
      ),
    );
  }
}

class PillCard extends StatefulWidget {
  final String pillName;
  final int initialAmount;

  const PillCard({
    required this.pillName,
    required this.initialAmount,
    Key? key,
  }) : super(key: key);

  @override
  State<PillCard> createState() => _PillCardState();
}

class _PillCardState extends State<PillCard> {
  late int selectedAmount;

  @override
  void initState() {
    super.initState();
    selectedAmount = widget.initialAmount;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // รูปภาพ
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2230),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Icon(Icons.camera_alt, color: Colors.grey, size: 40),
            ),
          ),
          const SizedBox(width: 16),

          // ข้อมูลยา
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Pill Name", style: TextStyle(color: Colors.grey.shade400)),
                Text(
                  widget.pillName,
                  style: const TextStyle(
                    color: Color(0xFF82E393),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                Text("Amount to take", style: TextStyle(color: Colors.grey.shade400)),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2E3441),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: selectedAmount,
                      dropdownColor: const Color(0xFF2E3441),
                      items: [1, 2, 3, 4, 5]
                          .map((val) => DropdownMenuItem(
                                value: val,
                                child: Text(
                                  val.toString(),
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            selectedAmount = val;
                          });
                        }
                      },
                      iconEnabledColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Save new amount
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD0F0C0),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text("Apply"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}