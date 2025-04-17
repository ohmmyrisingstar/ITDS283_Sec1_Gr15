import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../helpers/database.dart';
import '../models/medicine.dart';
import '../helpers/notification.dart';

class AddMedicinePage extends StatefulWidget {
  final DateTime selectedDate;
  const AddMedicinePage({super.key, required this.selectedDate});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  File? _imageFile;
  final TextEditingController _nameController = TextEditingController();
  Duration _remindIn = const Duration(hours: 1);

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

  Future<void> _saveMedicine() async {
    final String name = _nameController.text.trim();
    if (name.isEmpty) return;

    final db = DatabaseHelper.instance;
    final imagePath = _imageFile?.path;

    final DateTime remindTime = DateTime(
      widget.selectedDate.year,
      widget.selectedDate.month,
      widget.selectedDate.day,
    ).add(_remindIn);

    await db.insertMedicine(Medicine(
      name: name,
      dose: 1,
      time: DateFormat.jm().format(remindTime),
      date: DateFormat('yyyy-MM-dd').format(widget.selectedDate),
      imagePath: imagePath,
    ));

    await NotificationService.scheduleNotification(
      id: remindTime.millisecondsSinceEpoch ~/ 1000,
      title: "Don't forget to take your pills!",
      body: "It's time to take your $name brotherrr 💊⏰",
      scheduledTime: remindTime,
    );

    if (!mounted) return;
    Navigator.pop(context);
  }

  String formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return "${twoDigits(d.inHours)} hr ${twoDigits(d.inMinutes % 60)} min ${twoDigits(d.inSeconds % 60)} sec";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3047),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  const Center(
                    child: Text(
                      "Add medicine",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const Text("Remind Me In", style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 8),
                    Container(
                      height: 150,
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E2230),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: CupertinoTimerPicker(
                        mode: CupertinoTimerPickerMode.hms,
                        initialTimerDuration: _remindIn,
                        onTimerDurationChanged: (Duration val) {
                          setState(() {
                            _remindIn = val;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Center(
                      child: Text(
                        formatDuration(_remindIn),
                        style: const TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                height: 70,
                child: ElevatedButton(
                  onPressed: _saveMedicine,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFCFF5C3),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text("+ Add", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}