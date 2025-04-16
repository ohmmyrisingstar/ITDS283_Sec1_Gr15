import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:path/path.dart' as path;
import 'package:intl/intl.dart';
import '../helpers/database.dart';
import '../models/medicine.dart';



class AddMedicinePage extends StatefulWidget {
  final DateTime selectedDate;
  const AddMedicinePage({super.key, required this.selectedDate});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  File? _imageFile;
  final TextEditingController _nameController = TextEditingController();
  DateTime _selectedTime = DateTime.now();
  bool _reminderOn = false;
  int _selectedInterval = 2;

  final List<int> intervals = [1, 2, 4, 6];

  bool _isLoading = false;

  void _showImagePickerDialog() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF2E3047),
        title: const Text("Select Image", style: TextStyle(color: Colors.white)),
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white),
              onPressed: () async {
                Navigator.pop(context);
                final picked = await ImagePicker().pickImage(source: ImageSource.camera);
                if (picked != null) {
                  setState(() => _imageFile = File(picked.path));
                }
              },
            ),
            IconButton(
              icon: const Icon(Icons.photo, color: Colors.white),
              onPressed: () async {
                Navigator.pop(context);
                final picked = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (picked != null) {
                  setState(() => _imageFile = File(picked.path));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIntervalButton(int hour) {
    final isSelected = _selectedInterval == hour;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedInterval = hour);
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : const Color(0xFF1E2230),
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            "$hour hr",
            style: TextStyle(
              color: isSelected ? Colors.black : Colors.white54,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveMedicine() async {
    final String name = _nameController.text.trim();
    if (name.isEmpty) return;

    final db = DatabaseHelper.instance;
    final imagePath = _imageFile?.path;

    if (_reminderOn) {
      for (int i = 1; i <= 4; i++) {
        final DateTime remindTime = _selectedTime.add(Duration(hours: _selectedInterval * i));
        await db.insertMedicine(Medicine(
          name: name,
          dose: 1,
          time: DateFormat.jm().format(remindTime),
          date: DateFormat('yyyy-MM-dd').format(widget.selectedDate),
          imagePath: imagePath,
        ));
      }
    } else {
      final DateTime scheduledTime = _selectedTime.add(Duration(hours: _selectedInterval));
      await db.insertMedicine(Medicine(
        name: name,
        dose: 1,
        time: DateFormat.jm().format(scheduledTime),
        date: DateFormat('yyyy-MM-dd').format(widget.selectedDate),
        imagePath: imagePath,
      ));
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Color(0xFF2E3047),
        body: Center(child: CircularProgressIndicator(color: Colors.white)
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color(0xFF2E3047),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2E3047),
        elevation: 0,
        centerTitle: true,
        title: const Text("Add medicine"),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Stack(
              children: [
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E2230),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: _imageFile != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.file(_imageFile!, fit: BoxFit.cover),
                        )
                      : const Center(
                          child: Icon(Icons.camera_alt, color: Colors.grey, size: 40),
                        ),
                ),
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: GestureDetector(
                    onTap: _showImagePickerDialog,
                    child: const Icon(Icons.add, color: Colors.white),
                  ),
                )
              ],
            ),

            const SizedBox(height: 20),

            const Text("Name", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: "Add name here.....",
                hintStyle: const TextStyle(color: Colors.white38),
                filled: true,
                fillColor: const Color(0xFF1E2230),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            const SizedBox(height: 20),
            const Text("Start At", style: TextStyle(color: Colors.white70)),
            const SizedBox(height: 8),
            Container(
              height: 150,
              decoration: BoxDecoration(
                color: const Color(0xFF1E2230),
                borderRadius: BorderRadius.circular(12),
              ),
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                use24hFormat: false,
                initialDateTime: _selectedTime,
                onDateTimeChanged: (val) {
                  setState(() => _selectedTime = val);
                },
              ),
            ),

            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Remind Me Every", style: TextStyle(color: Colors.white70)),
                Switch(
                  value: _reminderOn,
                  onChanged: (val) => setState(() => _reminderOn = val),
                  activeColor: Colors.greenAccent,
                ),
              ],
            ),

            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: intervals.map(_buildIntervalButton).toList(),
            ),

            const SizedBox(height: 28),
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  final name = _nameController.text.trim();
                  if (name.isEmpty || _imageFile == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("กรุณาใส่ชื่อยาและเลือกรูปภาพ"),
                      ),
                    );
                    return;
                  }

                  setState(() => _isLoading = true); // ✅ เริ่มโหลด

                  try {
                    final fileName =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    final ref = FirebaseStorage.instance.ref().child(
                      'medicine_images/$fileName.jpg',
                    );

                    final snapshot = await ref.putFile(_imageFile!);

                    if (snapshot.state != TaskState.success) {
                      throw Exception("Image upload failed");
                    }

                    final imageUrl = await ref.getDownloadURL();

                    await FirebaseFirestore.instance.collection('medicines').add({
                      'name': name.toLowerCase(),
                      'form': 'Tablet',
                      'dosage': '500 mg',
                      'usage': 'รับประทาน 1 เม็ดหลังอาหาร',
                      'side_effects': 'อาจทำให้ปวดท้องหรือระคายเคือง',
                      'precautions':
                          'หลีกเลี่ยงในผู้ป่วยที่มีปัญหาเกี่ยวกับระบบทางเดินอาหาร',
                      'image_url': imageUrl,
                      'start_time': Timestamp.fromDate(_selectedTime,), // ✅ เพิ่มเวลาเริ่มเตือน
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("เพิ่มยาเรียบร้อยแล้ว")),
                    );
                    Navigator.pop(context);
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("เกิดข้อผิดพลาด: $e")),
                    );
                  } finally {
                    setState(
                      () => _isLoading = false,
                    ); // ✅ หยุดโหลด ไม่ว่าจะสำเร็จหรือ error
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCFF5C3),
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(horizontal: 100, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text("+ Add", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}
