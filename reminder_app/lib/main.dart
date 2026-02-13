import 'package:flutter/material.dart';
import 'package:reminder_app/storage_service.dart';
import 'package:reminder_app/reminder.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); //Stellt sicher, dass die Flutter-Engine initialisiert ist, bevor wir auf sie zugreifen
  await StorageService.init(); //Initialisiert den StorageService, damit wir später auf die Hive-Datenbank zugreifen können
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reminder App',
      home: const HomePage(),
      
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  
  @override
  State<HomePage> createState() => _HomePageState(); //methode die Sate<HomePage> zurückgibt also es wird einen Objekt von _HomePageState erstellt und zurückgegeben
}

class _HomePageState extends State<HomePage> {
  final List<String> reminders = []; //Liste um die Erinnerungen zu speichern
  final List<bool> isChecked = []; //Liste um den Status der Checkboxen zu speichern
  final TextEditingController controller = TextEditingController(); //Controller um den Text aus dem Textfeld zu lesen Benutzer definiert (wie Scanner)
  DateTime? selectedDateTime;

  void loadReminders(){
    final data = StorageService.box.values.cast<String>().toList();
    
    setState(() {
      reminders.clear();
      reminders.addAll(data);
    });
  }

  @override
  void initState() {
    super.initState();
    loadReminders(); //Lädt die Erinnerungen aus der Hive-Datenbank, wenn die Seite initialisiert wird
  }

  void addReminder() {
    if (controller.text.isEmpty) return;

    setState(() {
      reminders.add(controller.text);
      isChecked.add(false); // Standardmäßig ist die Checkbox nicht aktiviert
      StorageService.box.add(controller.text); //Der Text aus dem Textfeld wird der Liste der Erinnerungen hinzugefügt
    });
    controller.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reminder App'),
      ),
         body: Column(
  children: [
    Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              onSubmitted: (_) => addReminder(), //Wenn der Benutzer die Eingabetaste drückt, wird die Methode addReminder aufgerufen
              decoration: const InputDecoration(
                labelText: 'Neuer Reminder',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          ElevatedButton(
            onPressed: addReminder,
            child: const Text('Add'),
          ),
        ],
      ),
    ),
    Expanded(
      child: ListView.builder(
        itemCount: reminders.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(reminders[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  reminders.removeAt(index);
                  StorageService.box.delete(index);
                });
              },
            ),
          );
        },
      ),
    ),
  ],
),
      );
      
  }
}
