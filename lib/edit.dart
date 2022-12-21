import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http_client;

const String apiUrl = 'https://jsonplaceholder.typicode.com/todos';

class Edit extends StatefulWidget {
  const Edit({Key? key, @required this.todo}) : super(key: key);

  final dynamic todo;

  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> with SingleTickerProviderStateMixin {
  var todoTitleController = TextEditingController();
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    todoTitleController.text = widget.todo['title'];
    _controller = AnimationController(vsync: this);
  }

  updateTodo(context) async {
    var url = Uri.parse("$apiUrl/${widget.todo['id']}");
    var payload = jsonEncode({
      "id": widget.todo['id'],
      "title": widget.todo['title'],
      "completed": widget.todo['completed'],
      "userId": widget.todo['userId'],
    });

    var response = await http_client.put(url, body: payload);
    if (response.statusCode == 200) {
      Navigator.pop(context);
    } else {
      print("Error");
    }
  }

  String? get _errorText {
    final text = todoTitleController.value.text;

    // Condition text if empty, then show error text
    if (text.isEmpty) {
      return 'Field is required';
    }

    return null;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text("Edit Todo"),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              child: TextField(
                controller: todoTitleController,
                decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    hintText: 'Enter text',
                    errorText: _errorText
                ),
                onChanged: (text) => setState(() => _errorText)
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Back")
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _errorText == null ? () {
                    updateTodo(context);
                  } : null,
                  child: const Text("Update Todo"),
                )
              ],
            )
          ],
        )
      ),
    );
  }
}