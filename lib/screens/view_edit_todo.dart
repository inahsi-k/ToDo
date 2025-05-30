import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo/firebase%20methods/database.dart';
import 'package:todo/widgets/datepicker.dart';
import 'package:todo/widgets/text_field.dart';

class ViewEditTodo extends StatefulWidget {
  final String? title;
  final String? description;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? docId;
  final bool? isChecked;

  const ViewEditTodo({
    super.key,
    required this.description,
    required this.docId,
    required this.endDate,
    required this.startDate,
    required this.title,
    required this.isChecked
  });

  @override
  State<ViewEditTodo> createState() => _ViewEditTodoState();
}

class _ViewEditTodoState extends State<ViewEditTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  bool isEditing = false;

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
  void initState() {
    // TODO: implement initState
    super.initState();

    titleController.text = widget.title ?? '';
    descriptionController.text = widget.description ?? '';
    // startDateController.text = widget.startDate ?? '';
    // endDateController.text = widget.endDate ?? '';
    if (widget.startDate != null) {
      startDateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(widget.startDate!);
    }

    if (widget.endDate != null) {
      endDateController.text = DateFormat('dd/MM/yyyy').format(widget.endDate!);
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
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(13.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () {
                          // Navigator.pop(context);
                          if (isEditing == false) {
                            Navigator.pop(context);
                          } else {
                            setState(() {
                              isEditing = false;
                            });
                          }
                        },
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                      ),
                      IconButton(
                        onPressed: () {
                          setState(() {
                            isEditing = true;
                          });
                        },
                        icon: Icon(Icons.edit, color: Colors.white),
                      ),
                    ],
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height / 9),

                  Text(
                    isEditing ? "Edit your todo" : "View Your Todo :)",
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
                    readOnly: !isEditing,
                  ),
                  SizedBox(height: 30),
                  TextFieldWidget(
                    controller: descriptionController,
                    text: "Enter task description",
                    filled: true,
                    lines: 6,
                    readOnly: !isEditing,
                  ),

                  SizedBox(height: 30),

                  Row(
                    children: [
                      Expanded(
                        child: DatePickerExample(
                          title: "Start date",
                          dateController: startDateController,
                          readOnly: !isEditing,
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: DatePickerExample(
                          title: "End date",
                          dateController: endDateController,
                          readOnly: !isEditing,
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 70),

                  isEditing == false
                      ? Container()
                      : ElevatedButton(
                        onPressed: () async {
                          final title = titleController.text;
                          final description = descriptionController.text;
                          final startDate = _parseDate(
                            startDateController.text,
                          );
                          final endDate = _parseDate(endDateController.text);

                          if (title.isNotEmpty &&
                              startDate != null &&
                              endDate != null) {
                            if (widget.docId != null) {
                              await FireStoreDatabase().updateData(
                                title: title,
                                description: description,
                                startDate: startDate,
                                endDate: endDate,
                                docId: widget.docId!,
                                isChecked: widget.isChecked??false,
                              );
                              Navigator.pop(context);
                            }
                          } else {
                            final sb = SnackBar(
                              content: Text(
                                "Kinldy fill the title field atleast :/",
                              ),
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
                                  "Edit",
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
