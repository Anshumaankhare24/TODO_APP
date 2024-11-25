// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ToDo extends StatefulWidget {
  const ToDo({super.key});

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  final List<String> text = [];
  final List<bool> completedTasks = []; // Track completed tasks
  final TextEditingController taskController = TextEditingController();
  List<String> filteredTasks = [];
  List<bool> filteredCompletion = [];
  bool isSearching = false;

  void _add() {
    if (taskController.text.isNotEmpty) {
      setState(() {
        text.add(taskController.text);
        completedTasks.add(false); // New task is not completed
        taskController.clear();
        filteredTasks = text;
        filteredCompletion = completedTasks;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Task cannot be empty!")),
      );
    }
  }

  void _del(int index) {
    setState(() {
      int originalIndex = text.indexOf(filteredTasks[index]);
      text.removeAt(originalIndex);
      completedTasks.removeAt(originalIndex);
      filteredTasks = text;
      filteredCompletion = completedTasks;
    });
  }

  @override
  void initState() {
    super.initState();
    filteredTasks = text;
    filteredCompletion = completedTasks;
  }

  void startSearch(String query) {
    setState(() {
      filteredTasks = text
          .where((task) => task.toLowerCase().contains(query.toLowerCase()))
          .toList();
      filteredCompletion = filteredTasks
          .map((task) => completedTasks[text.indexOf(task)])
          .toList();
    });
  }

  void stopSearch() {
    setState(() {
      isSearching = false;
      filteredTasks = text;
      filteredCompletion = completedTasks;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: !isSearching
              ? Text("To-Do List ")
              : TextField(
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Search tasks...",
                    hintStyle:
                        TextStyle(color: const Color.fromARGB(179, 0, 0, 0)),
                    border: InputBorder.none,
                  ),
                  style: TextStyle(color: const Color.fromARGB(255, 0, 0, 0)),
                  onChanged: (value) => startSearch(value),
                ),
          actions: [
            isSearching
                ? IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: stopSearch,
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        isSearching = true;
                      });
                    },
                  ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: taskController,
                        decoration: InputDecoration(
                          hintText: "Enter a task",
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    ElevatedButton(
                      onPressed: _add,
                      child: const Text("Add"),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: filteredTasks.isEmpty
                    ? Center(
                        child: Text(
                          "No tasks found!",
                          style: TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(0.2),
                                  ),
                                ],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                leading: InkWell(
                                  onTap: () {
                                    setState(() {
                                      // Get the original index of the task in the main list
                                      int originalIndex =
                                          text.indexOf(filteredTasks[index]);

                                      // Toggle the completion status in the original list
                                      completedTasks[originalIndex] =
                                          !completedTasks[originalIndex];

                                      // Update the filteredCompletion list to stay in sync
                                      filteredCompletion[index] =
                                          completedTasks[originalIndex];
                                    });
                                  },
                                  child: Icon(
                                    filteredCompletion[index]
                                        ? Icons.check_box
                                        : Icons.check_box_outline_blank,
                                    color: filteredCompletion[index]
                                        ? Colors.green
                                        : Colors.grey,
                                  ),
                                ),
                                title: Text(
                                  filteredTasks[index],
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    decoration: filteredCompletion[index]
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                  ),
                                ),
                                trailing: InkWell(
                                  onTap: () {
                                    _del(index);
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                        color: Colors.red,
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Center(
                                      child: FaIcon(
                                        FontAwesomeIcons.trash,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: filteredTasks.length,
                      ),
              ),
            ],
          ),
        ));
  }
}
