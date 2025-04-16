class Medicine {
  final int? id;
  final String name;
  final int dose;
  final String time;
  final String date;
  final String? imagePath;

  Medicine({
    this.id,
    required this.name,
    required this.dose,
    required this.time,
    required this.date,
    this.imagePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'dose': dose,
      'time': time,
      'date': date,
      'imagePath': imagePath,
    };
  }

  factory Medicine.fromMap(Map<String, dynamic> map) {
    return Medicine(
      id: map['id'],
      name: map['name'],
      dose: map['dose'],
      time: map['time'],
      date: map['date'],
      imagePath: map['imagePath'],
    );
  }
}