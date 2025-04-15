import 'package:flutter/material.dart';
import '../components/navbar.dart';
import 'homepage.dart';
import 'amount.dart';
import 'settings_page.dart';
import 'addmed.dart';
import '../helpers/database.dart';
import '../models/medicine_info.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearched = false;
  List<MedicineInfo> _results = [];

  Future<void> _performSearch() async {
    final query = _searchController.text.trim().toLowerCase();
    if (query.isEmpty) return;

    try {
      final results = await DatabaseHelper.instance.searchMedicineInfoByName(query);
      setState(() {
        _hasSearched = true;
        _results = results;
      });
    } catch (e) {
      print('❌ Search error: $e');
      setState(() {
        _hasSearched = true;
        _results = [];
      });
    }
  }

  void _onTabTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomePage()));
    } else if (index == 1) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => AmountPage()));
    } else if (index == 2) {
      // current page
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
        title: const Text(
          "Search Medicine",
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const SizedBox(),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFF3B3D58),
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.white54),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: "Search for a medicine...",
                        hintStyle: TextStyle(color: Colors.white54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: _performSearch,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: const Text(
                      "Search",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            if (!_hasSearched)
              const Text(
                "Search results will appear here",
                style: TextStyle(color: Colors.grey),
              )
            else if (_results.isEmpty)
              const Text(
                "ไม่พบข้อมูลยาที่ค้นหา",
                style: TextStyle(color: Colors.white70),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _results.length,
                  itemBuilder: (context, index) {
                    final item = _results[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2230),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  width: 60,
                                  height: 60,
                                  color: Colors.black26,
                                  child: const Icon(Icons.image, color: Colors.grey),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  item.name,
                                  style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          if (item.form != null) Text("• รูปแบบยา: ${item.form}", style: const TextStyle(color: Colors.white70)),
                          if (item.dosage != null) Text("• ปริมาณ: ${item.dosage}", style: const TextStyle(color: Colors.white70)),
                          if (item.usage != null) Text("• วิธีใช้: ${item.usage}", style: const TextStyle(color: Colors.white70)),
                          if (item.sideEffects != null) Text("• ผลข้างเคียง: ${item.sideEffects}", style: const TextStyle(color: Colors.white70)),
                          if (item.warnings != null) Text("• ข้อควรระวัง: ${item.warnings}", style: const TextStyle(color: Colors.white70)),
                        ],
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddMedicinePage(selectedDate: DateTime.now())));
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.favorite, color: Colors.black, size: 32),
        shape: const CircleBorder(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        currentIndex: 2,
        onTap: _onTabTapped,
      ),
    );
  }
}
