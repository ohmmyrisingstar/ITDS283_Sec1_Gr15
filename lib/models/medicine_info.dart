class MedicineInfo {
  final int? id;
  final String name;
  final String? imagePath;
  final String? form;
  final String? dosage;
  final String? usage;
  final String? sideEffects;
  final String? warnings;

  MedicineInfo({
    this.id,
    required this.name,
    this.imagePath,
    this.form,
    this.dosage,
    this.usage,
    this.sideEffects,
    this.warnings,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imagePath': imagePath,
      'form': form,
      'dosage': dosage,
      'usage': usage,
      'sideEffects': sideEffects,
      'warnings': warnings,
    };
  }

  factory MedicineInfo.fromMap(Map<String, dynamic> map) {
    return MedicineInfo(
      id: map['id'],
      name: map['name'],
      imagePath: map['imagePath'],
      form: map['form'],
      dosage: map['dosage'],
      usage: map['usage'],
      sideEffects: map['sideEffects'],
      warnings: map['warnings'],
    );
  }
}
