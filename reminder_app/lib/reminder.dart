class Reminder {
  final String text;
  final DateTime dateTime;
  
  Reminder ({
    required this.text,
    required this.dateTime,
  });

  Map<String, dynamic> toMap(){
    return {
      'text': text,
      'dateTime': dateTime.toIso8601String(),
    };
  }
  factory Reminder.fromMap(Map map){
    return Reminder(
      text: map['text'],
      dateTime: DateTime.parse(map['dateTime']),
      );
  }
}