import 'package:flutter/material.dart';
import '../components/navbar.dart'; // ✅ import navbar
import 'homepage.dart';
import 'searchpage.dart';
import 'settings_page.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

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
        title: const Text(
          "About Us",
          style: TextStyle(color: Colors.white, fontSize: 22),
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
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 150),
              const Text(
                "Scan here to know more about us",
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Image.network(
                      'https://api.qrserver.com/v1/create-qr-code/?data=https://onespotapps.com&size=200x200',
                      width: 200,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      "SCAN ME!",
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("FAB clicked!")),
          );
        },
        backgroundColor: Colors.white,
        shape: const CircleBorder(),
        child: const Icon(Icons.favorite, color: Colors.black, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        currentIndex: -1, // ❌ ไม่มี tab ตรงกับ "About Us"
        onTap: (index) => _onTabTapped(context, index),
      ),
    );
  }
}