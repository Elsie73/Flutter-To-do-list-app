import 'package:flutter/material.dart';
import 'package:todolist/model/todo.dart';
import 'package:todolist/widgets/todo_items.dart';


enum TaskCategory {
  all,
  completed,
  pending,
}

class TasksScreen extends StatefulWidget {
  const TasksScreen({Key? key}) : super(key: key);

  @override
  State<TasksScreen> createState() => _TasksScreenState();
}

class _TasksScreenState extends State<TasksScreen> {
  List<ToDo> todosList = ToDo.todoList();
  List<ToDo> _foundToDo = [];
  TaskCategory _selectedCategory = TaskCategory.all;

  @override
  void initState() {
    _updateTasks();
    super.initState();
  }

  void _updateTasks() {
    setState(() {
      switch (_selectedCategory) {
        case TaskCategory.all:
          _foundToDo = todosList;
          break;
        case TaskCategory.completed:
          _foundToDo = todosList.where((todo) => todo.isDone).toList();
          break;
        case TaskCategory.pending:
          _foundToDo = todosList.where((todo) => !todo.isDone).toList();
          break;
      }
    });
  }

  void _searchTasks(String keyword) {
    setState(() {
      if (keyword.isEmpty) {
        _updateTasks();
      } else {
        _foundToDo = todosList
            .where((todo) => todo.todoText.toLowerCase().contains(keyword.toLowerCase()))
            .toList();
      }
    });
  }

  void _handleToDoChange(ToDo todo) {
    setState(() {
      todo.isDone = !todo.isDone;
      _updateTasks();
    });
  }

  void _deleteToDoItem(String id) {
    setState(() {
      todosList.removeWhere((item) => item.id == id);
      _updateTasks();
    });
  }

  Future<void> _showAddTaskDialog(BuildContext context) async {
    String newTaskText = '';

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: Text('Add New Task'),
          content: TextField(
            autofocus: true,
            onChanged: (value) {
              newTaskText = value;
            },
            decoration: InputDecoration(hintText: 'Enter task...'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _addNewTask(newTaskText);
                Navigator.pop(dialogContext);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _addNewTask(String taskText) {
    if (taskText.isNotEmpty) {
      String newTaskId = UniqueKey().toString();

      ToDo newTask = ToDo(
        id: newTaskId,
        todoText: taskText,
        isDone: false,
      );

      setState(() {
        todosList.add(newTask);
        _updateTasks();
      });
    }
  }

  void _setSelectedCategory(TaskCategory category, BuildContext context) {
    setState(() {
      _selectedCategory = category;
      _updateTasks();
    });

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 35.0),
              child: Icon(Icons.assignment, color: Colors.white),
            ),
            SizedBox(width: 8),
            Text(
              'Tasks App',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        backgroundColor: const Color(0xFF3F51B5),
        iconTheme: IconThemeData(color: Colors.white),
      ),

      drawer: Drawer(
  child: Container(
    color: Colors.deepOrange, // Change the background color of the drawer
    child: ListView(
      padding: EdgeInsets.zero,
      children: <Widget>[
        UserAccountsDrawerHeader(
          decoration: BoxDecoration(
            color: Colors.deepPurple, // Change the background color of the header
          ),
          currentAccountPicture: CircleAvatar(
            backgroundImage: AssetImage("assets/images/avatar.png"), 
            radius: 30,
          ),
          accountName: Text(
            "Samuel Andrew",
            style: TextStyle(color: const Color.fromARGB(255, 241, 238, 238)), // Change the color of the account name
          ),
          accountEmail: Text(
            "sambaraks652@gmail.com",
            style: TextStyle(color: Colors.white), // Change the color of the account email
          ),
        ),
        ListTile(
          title: Text("All Tasks", style: TextStyle(color: Colors.white)), // Change the color of the text
          leading: Icon(Icons.menu_outlined, color: Colors.white), // Change the color of the icon
          onTap: () => _setSelectedCategory(TaskCategory.all, context),
        ),
        ListTile(
          title: Text("Completed Tasks", style: TextStyle(color: Colors.white)), // Change the color of the text
          leading: Icon(Icons.check_box, color: Colors.white), // Change the color of the icon
          onTap: () => _setSelectedCategory(TaskCategory.completed, context),
        ),
        ListTile(
          title: Text("Pending Tasks", style: TextStyle(color: Colors.white)), // Change the color of the text
          leading: Icon(Icons.incomplete_circle, color: Colors.white), // Change the color of the icon
          onTap: () => _setSelectedCategory(TaskCategory.pending, context),
        ),
        ListTile(
  title: Text("Help", style: TextStyle(color: Colors.white)), // Change the color of the text
  leading: Icon(Icons.help_center, color: Colors.white), // Change the color of the icon
  onTap: () {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Help'),
          content: Text('Need help? Contact support at sambaraks652@gmail.com'),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  },
),ListTile(
  title: Text("Logout", style: TextStyle(color: Colors.white)), // Change the color of the text
  leading: Icon(Icons.logout, color: Colors.white), // Change the color of the icon
  
),
      ],
    ),
  ),
),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: TextField(
                onChanged: (keyword) {
                  _searchTasks(keyword);
                },
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.all(0),
                  prefixIcon: Icon(
                    Icons.search,
                    color: const Color(0xFF272626),
                    size: 24,
                  ),
                  prefixIconConstraints:
                      BoxConstraints(maxHeight: 24, minWidth: 30),
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey),
                ),
              ),
            ),
            SizedBox(height: 30),
            Expanded(
              child: ListView.builder(
                itemCount: _foundToDo.length,
                itemBuilder: (context, index) => ToDoItem(
                  todo: _foundToDo[index],
                  onToDoChanged: _handleToDoChange,
                  onDeleteItem: _deleteToDoItem,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddTaskDialog(context);
        },
        tooltip: 'Add New Task',
        child: Icon(Icons.add),
        backgroundColor: const Color(0xFF3F51B5),
      ),
      backgroundColor: const Color(0xFFE8EAF6),
    );
  }
}
