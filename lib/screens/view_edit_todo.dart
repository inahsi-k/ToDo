import 'package:flutter/material.dart';
import 'package:todo/firebase%20methods/database.dart';
import 'package:todo/screens/home.dart';
import 'package:todo/widgets/datepicker.dart';
import 'package:todo/widgets/text_field.dart';

class AddTodo extends StatefulWidget {
  final String? title;
  final String? description;
  final String? startDate;
  final String? endDate;
  final String? docId;

  const AddTodo({
    super.key,
    required this.description,
    required this.docId,
    required this.endDate,
    required this.startDate,
    required this.title,
  });

  @override
  State<AddTodo> createState() => _AddTodoState();
}

class _AddTodoState extends State<AddTodo> {
  TextEditingController titleController = TextEditingController();
  TextEditingController desciptionController = TextEditingController();
  TextEditingController startDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();

  bool isEditing = false;

  DateTime _parseDate(String dateString) {
    List<String> parts = dateString.split('/');
    int day = int.parse(parts[0]);
    int month = int.parse(parts[1]);
    int year = int.parse(parts[2]);
    return DateTime(year, month, day);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    titleController.text = widget.title ?? '';
    desciptionController.text = widget.description ?? '';
    startDateController.text = widget.startDate ?? '';
    endDateController.text = widget.endDate ?? '';
    
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

                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(onPressed: (){
                       setState(() {
                            isEditing = true;
                          });
                    }, icon: Icon(Icons.edit)),
                  ),

                  SizedBox(height: MediaQuery.of(context).size.height / 7),

                  Text(
                    isEditing?"Edit your todo":"View Your Todo :)",
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
                    controller: desciptionController,
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

                  isEditing==false
                  ?Container()
                  :ElevatedButton(
                    onPressed: () {
                      final title = titleController.text;
                      final description = desciptionController.text;
                      final startDate = _parseDate(startDateController.text);
                      final endDate = _parseDate(endDateController.text);
                      if (title.isNotEmpty) {
                        FireStoreDatabase().addData(
                          title: title,
                          description: description,
                          startDate: startDate,
                          endDate: endDate,
                        );
                        Navigator.pop(context);
                      } else {
                        final sb = SnackBar(
                          content: Text(
                            "Kinldy fill the title and field atleast :/",
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
