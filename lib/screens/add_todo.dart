import 'package:flutter/material.dart';
import 'package:keyboard_avoider/keyboard_avoider.dart';
import 'package:todo/firebase%20methods/database.dart';
import 'package:todo/widgets/datepicker.dart';
import 'package:todo/widgets/text_field.dart';

class AddTodo extends StatefulWidget {
  final bool isChecked;  //
  const AddTodo({super.key,required this.isChecked});

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  TextEditingController startDateController = TextEditingController();

  TextEditingController endDateController = TextEditingController();

  DateTime? _parseDate(String dateString) {
    try {
      List<String> parts = dateString.split('/');
      if (parts.length != 3) return null;
      int day = int.parse(parts[0]);
      int month = int.parse(parts[1]);
      int year = int.parse(parts[2]);
      return DateTime(year, month, day);
    } catch (e) {
      print("Error parsing date: $e");
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              const Color.fromARGB(255, 3, 30, 78),
              const Color.fromARGB(255, 10, 55, 133),
              const Color.fromARGB(255, 37, 103, 202),
              const Color.fromARGB(255, 20, 132, 188),
            ],
          ),
        ),
        child: SafeArea(
          child: KeyboardAvoider(
            autoScroll: true,
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 9),
                  Text(
                    "Create Your Todo :)",
                    style: TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
            
                  SizedBox(height: 70),
            
                  TextFieldWidget(
                    controller: titleController,
                    text: "Enter task title",
                    filled: true,
                  ),
                  SizedBox(height: 30),
                  TextFieldWidget(
                    controller: descriptionController,
                    text: "Enter task description",
                    filled: true,
                    lines: 6,
                  ),
            
                  SizedBox(height: 30),
            
                  Row(
                    children: [
                      Expanded(
                        child: DatePickerExample(
                          title: "Start date",
                          dateController: startDateController,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DatePickerExample(
                          title: "End date",
                          dateController: endDateController,
                        ),
                      ),
                    ],
                  ),
            
                  SizedBox(height: 70),
            
                  ElevatedButton(
                    onPressed: () async {
                      final title = titleController.text;
                      final description = descriptionController.text;
                      final startDate = _parseDate(startDateController.text);
                      final endDate = _parseDate(endDateController.text);
                      if (title.isNotEmpty &&
                          startDate != null &&
                          endDate != null) {
                        await FireStoreDatabase().addData(
                          title: title,
                          description: description,
                          startDate: startDate,
                          endDate: endDate, 
                          isChecked: widget.isChecked, /** */
                        );
                        print("Data added successfully");
                        Navigator.pop(context);
                      } else {
                        final sb = SnackBar(
                          content: Text("Kinldy fill the necessary fields :/"),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(sb);
                      }
                      // FireStoreDatabase.;
                    },
                    style: ElevatedButton.styleFrom(
                      minimumSize: Size(double.infinity, 55),
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: EdgeInsets.zero,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
            
                    child: Ink(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Colors.blue, Colors.purple],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Container(
                        alignment: Alignment.center,
                        constraints: BoxConstraints(
                          minWidth: double.infinity,
                          minHeight: 55,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(width: 8),
                            Text(
                              "Create",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
