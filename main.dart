import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

// Главный виджет приложения (без состояния)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Заметки',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      ),
      home: const NotesPage(),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // Контроллер для поля ввода новой заметки
  final TextEditingController _controller = TextEditingController();

  // Список заметок (хранится в памяти приложения)
  final List<String> _notes = [];

  // Добавление заметки
  void _addNote() {
    final text = _controller.text.trim(); // убираем лишние пробелы
    if (text.isEmpty) return;             // пустую заметку не добавляем

    setState(() {
      _notes.add(text);
    });
    _controller.clear(); // очищаем поле ввода
  }

  // Удаление заметки по номеру
  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  // Редактирование заметки через диалоговое окно
  void _editNote(int index) {
    // Контроллер сразу содержит старый текст заметки
    final editController = TextEditingController(text: _notes[index]);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Редактирование заметки'),
          content: TextField(
            controller: editController,
            autofocus: true,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Отмена'),
            ),
            ElevatedButton(
              onPressed: () {
                final newText = editController.text.trim();
                if (newText.isEmpty) return;

                setState(() {
                  _notes[index] = newText; // заменяем старый текст новым
                });
                Navigator.pop(context); // закрываем окно
              },
              child: const Text('Сохранить'),
            ),
          ],
        );
      },
    );
  }

  // Освобождаем контроллер, когда экран закрывается
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои заметки'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Поле ввода
            TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'Введите заметку',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),

            // Кнопка «Сохранить»
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _addNote,
                child: const Text('Сохранить'),
              ),
            ),
            const SizedBox(height: 10),

            // Список заметок
            Expanded(
              child: ListView.builder(
                itemCount: _notes.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(_notes[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () => _editNote(index),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _deleteNote(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}