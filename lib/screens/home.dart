import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo/firebase%20methods/database.dart';
import 'package:todo/screens/add_todo.dart';
import 'package:todo/screens/login.dart';
import 'package:todo/widgets/custom_text.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int index = 0;
  bool isChecked = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      content: Text("Are you sure you want to log out?"),
                      actions: [
                        TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop(); // Close dialog first
                            await FirebaseAuth.instance
                                .signOut(); // Then sign out
                            Navigator.of(context).push(
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: CustomText(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 186, 170, 170),
                            text: "Yes",
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: CustomText(
                            fontSize: 16,
                            color: const Color.fromARGB(255, 240, 14, 2),
                            text: "Cancel",
                          ),
                        ),
                      ],
                    ),
              );
            },
            icon: Icon(Icons.logout_outlined, color: Colors.white),
          ),
        ],
        title: Text(
          "ToDo",
          style: TextStyle(
            letterSpacing: 2,
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: const Color.fromARGB(255, 93, 165, 224),
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 30, 78),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FireStoreDatabase().getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData) {
            return Center(
              child: CustomText(
                fontSize: 20,
                color: const Color.fromARGB(255, 2, 3, 89),
                text: "No todos yet",
              ),
            );
          }

          final todos = snapshot.data!.docs; // ✅ yeh saare todos ki list hai

          return ListView.builder(
            itemCount: todos.length,
            itemBuilder: (context, index) {
              final todo =
                  todos[index].data()
                      as Map<
                        String,
                        dynamic
                      >; // ✅ yeh ek single todo document hai
              return Card(
                elevation: 3,
                child: ListTile(
                  tileColor: const Color.fromARGB(255, 151, 193, 227),
                  leading:StatefulBuilder(
                      builder: (context, setLocalState) {
                        bool localChecked = false;
                        return Checkbox(
                          activeColor: const Color.fromARGB(255, 3, 30, 78),
                          value: localChecked,
                          onChanged: (bool? value) {
                            setLocalState(() {
                              localChecked = value!;
                            });
                          },
                        );
                      },
                    ),

                  // Checkbox(
                  //   activeColor: const Color.fromARGB(255, 3, 30, 78),
                  //   value: isChecked,
                  //   onChanged: (bool? value) {
                  //     setState(() {
                  //       isChecked = value!;
                  //     });
                  //   },
                  // ),
                  title: Text(todo["title"]??"No title"),
                  subtitle: Text(todo["description"]??"No description"),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.delete),
                  ),
                ),
              );
            },
          );
        },
      ),

      // Padding(
      //   padding: const EdgeInsets.all(8.0),
      //   child: ListView.builder(
      //     itemCount: 5,
      //     itemBuilder: (context, index) {
      //       return Card(
      //         elevation: 3,
      //         child: ListTile(
      //           tileColor: const Color.fromARGB(255, 151, 193, 227),
      //           leading: Checkbox(
      //             activeColor: const Color.fromARGB(255, 3, 30, 78),
      //             value: isChecked,
      //             onChanged: (bool? value) {
      //               setState(() {
      //                 isChecked = value!;
      //               });
      //             },
      //           ),
      //           title: Text("hi"),
      //           subtitle: Text("this is just for test purpose"),
      //           trailing: IconButton(
      //             onPressed: () {},
      //             icon: Icon(Icons.delete),
      //           ),
      //         ),
      //       );
      //     },
      //   ),
      // ),
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(29)),
        backgroundColor: const Color.fromARGB(255, 3, 30, 78),
        onPressed: () {
          Navigator.of(
            context,
          ).push(MaterialPageRoute(builder: (context) => AddTodo()));
        },
        child: Icon(Icons.add, color: const Color.fromARGB(255, 93, 165, 224)),
      ),
    );
  }
}
