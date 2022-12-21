import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http_client;
import 'package:niel_hands_on_exam/edit.dart';

const String apiUrl = 'https://jsonplaceholder.typicode.com/todos';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  List<dynamic> todoList = <dynamic>[];
  bool isLoading = true;

  late AnimationController _controller;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMsgerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

    // Get all todos using API placeholder
    getTodos();
  }

  getTodos() async {
    var url = Uri.parse(apiUrl);
    var response = await http_client.get(url);

    if (response.statusCode == 200) {
      todoList = jsonDecode(response.body);
      isLoading = false;
    } else {

    }

    // WidgetsBinding.instance
    //     .addPostFrameCallback((timeStamp) => _scaffoldMsgerKey
    //     .currentState
    //     ?.showSnackBar(const SnackBar(content: Text("Example"))));
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
          child: Text("Todo List"),
        ),
      ),
      body: Container(
        child: isLoading ? const Center(child: CircularProgressIndicator(color: Colors.blue)) : ListView.separated(
          padding: const EdgeInsets.all(20),
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                var todoItem = todoList[index];
                Navigator.push(context, MaterialPageRoute(builder: (context) => Edit(todo: todoItem)));
              },
              child: Container(
                  padding: const EdgeInsets.fromLTRB(10, 16, 10, 16),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade500),
                      borderRadius: const BorderRadius.all(Radius.circular(6))
                  ),
                  child: Text("${todoList[index]['title'] ?? ''}")
              ),
            );
          }, separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 10),
        ),
      )
    );
  }

}
