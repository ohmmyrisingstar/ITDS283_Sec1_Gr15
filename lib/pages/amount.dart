import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/helpers/database.dart';
import 'package:flutter_application_1/models/medicine.dart';
import '../components/navbar.dart';
import 'addmed.dart';
import 'homepage.dart';
import 'searchpage.dart';
import 'settings_page.dart';

class AmountPage extends StatelessWidget {
  final List<Map<String, dynamic>> pills = [];

  void _onTabTapped(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SearchPage()),
      );
    } else if (index == 3) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const SettingsPage()),
      );
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
        title: const Text(
          "Amount",
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: FutureBuilder<List<Medicine>>(
        future: DatabaseHelper.instance.getAllMedicines(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            final pillWidgets = snapshot.data!
                .map(
                  (medicine) => PillCard(
                    pillName: medicine.name,
                    initialAmount: medicine.dose,
                    id: medicine.id,
                    time: medicine.time,
                    date: medicine.date,
                    imagePath: medicine.imagePath,
                  ),
                )
                .toList();

            return ListView(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
              children: pillWidgets,
            );
          }

          return const Center(
            child: Text(
              'No Medicine added yet',
              style: TextStyle(color: Colors.white38, fontSize: 16),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => AddMedicinePage(selectedDate: DateTime.now()),
            ),
          );
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
  final int? id;
  final String? time;
  final String? date;
  final String? imagePath;

  const PillCard({
    required this.pillName,
    required this.initialAmount,
    this.id,
    this.time,
    this.date,
    this.imagePath,
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
          Container(
            width: 160,
            height: 160,
            decoration: BoxDecoration(
              color: const Color(0xFF1E2230),
              borderRadius: BorderRadius.circular(16),
              image: (widget.imagePath != null && File(widget.imagePath!).existsSync())
                  ? DecorationImage(
                      image: FileImage(File(widget.imagePath!)),
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            child: (widget.imagePath == null || !File(widget.imagePath!).existsSync())
                ? const Center(
                    child: Icon(Icons.camera_alt, color: Colors.grey, size: 40),
                  )
                : null,
          ),
          const SizedBox(width: 16),
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
                          .map(
                            (val) => DropdownMenuItem(
                              value: val,
                              child: Text(
                                val.toString(),
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
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
                    onPressed: () async {
                      if (widget.id != null) {
                        final updatedMedicine = Medicine(
                          id: widget.id!,
                          name: widget.pillName,
                          dose: selectedAmount,
                          time: widget.time ?? '',
                          date: widget.date ?? '',
                          imagePath: widget.imagePath,
                        );
                        await DatabaseHelper.instance.updateMedicine(updatedMedicine);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Updated successfully")),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD0F0C0),
                      foregroundColor: Colors.black,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
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