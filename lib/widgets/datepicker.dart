import 'package:flutter/material.dart';

class DatePickerExample extends StatefulWidget {
  final String title;
  final TextEditingController dateController;
  final bool readOnly;
  const DatePickerExample({
    super.key,
    required this.title,
    required this.dateController,
    this.readOnly=false,
  });

  @override
  _DatePickerExampleState createState() => _DatePickerExampleState();
}

class _DatePickerExampleState extends State<DatePickerExample> {
  Future<void> _selectDate(BuildContext context) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      String formattedDate =
          "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
      setState(() {
        widget.dateController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Calendar Icon Button
        Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.purple, Colors.blue]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: IconButton(
            icon: Icon(Icons.calendar_today, color: Colors.white),
            onPressed: widget.readOnly ? null : () => _selectDate(context),
          ),
        ),
        SizedBox(width: 5),

        // End Date TextField
        Expanded(
          child: TextField(
            controller: widget.dateController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: widget.title,
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onTap: widget.readOnly ? null : () => _selectDate(context), //allow tapping on field as per the conditions
          ),
        ),
      ],
    );
  }
}
