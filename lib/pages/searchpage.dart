import 'package:flutter/material.dart';
import '../components/navbar.dart'; // ✅ import bottom nav
import 'homepage.dart';
import 'amount.dart';
import 'settings_page.dart';
import 'addmed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  bool _hasSearched = false;

  String? result;
  String? imageUrl;

  Future<void> _performSearch() async {
    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) return;

    setState(() {
      _hasSearched = true;
      result = "กำลังค้นหา...";
    });

    try {
      final snapshot =
          await FirebaseFirestore.instance
              .collection('medicines')
              .where('name', isEqualTo: query)
              .get();

      if (snapshot.docs.isNotEmpty) {
        final doc = snapshot.docs.first.data();

        imageUrl = doc['image_url']; // ✅ เพิ่มบรรทัดนี้
        result = '''
📦 ${_capitalize(doc['name'])}

• รูปแบบยา: ${doc['form']}  
• ปริมาณ: ${doc['dosage']}  
• วิธีใช้: ${doc['usage']}  
• ผลข้างเคียง: ${doc['side_effects']}  
• ข้อควรระวัง: ${doc['caution']}
    ''';
      } else {
        imageUrl = null;
        result = "ไม่พบข้อมูลยาที่ค้นหา";
      }
    } catch (e) {
      imageUrl = null;
      result = "เกิดข้อผิดพลาดในการค้นหา: $e";
    }

    setState(() {});
  }

  String _capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
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
            // Search bar + button
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
            else
              Expanded(
                child: Container(
                  width: double.infinity,
                  child: Card(
                    color: const Color(0xFF1C1E32),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (imageUrl != null)
                              ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imageUrl!,
                                  height: 160,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Text(
                                            'โหลดรูปไม่ได้',
                                            style: TextStyle(
                                              color: Colors.white54,
                                            ),
                                          ),
                                ),
                              ),
                            const SizedBox(height: 16),
                            Text(
                              result ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                height: 1.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
          ],
        ),
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
        currentIndex: 2,
        onTap: _onTabTapped,
      ),
    );
  }
}