import 'package:flutter/material.dart';
import 'package:todo/firebase%20methods/authentication.dart';
import 'package:todo/widgets/text_field.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({super.key});

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  bool circular = false;
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          "Forgot Password",
          style: TextStyle(
            color: const Color.fromARGB(255, 133, 188, 232),
            fontSize: 23,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 3, 30, 78),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            
            TextFieldWidget(
              controller: emailController,
              text: "Enter email for password recovery",
              filled: false,
            ),
        
            SizedBox(height: 15),
        
            ElevatedButton(
              onPressed: () async {
                setState(() {
                  circular = true;
                });
                final String res = await Authentication().resetPassword(
                  email: emailController.text.toString(),
                );
                setState(() {
                  circular = false;
                });
                if (res == "Success") {
                  SnackBar sb = SnackBar(
                    content: Text("email has been sent"),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(sb);
                  Navigator.pop(context);
                } else {
                  SnackBar sb = SnackBar(content: Text(res));
                  ScaffoldMessenger.of(context).showSnackBar(sb);
                }
              },
        
        
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: const Color.fromARGB(255, 3, 30, 78),
                foregroundColor: Colors.blue,
              ),
        
        
              child:
                  circular
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text(
                        "Change Password",
                        style: TextStyle(
                          color: const Color.fromARGB(255, 133, 188, 232),
                          fontSize: 23,
                        ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
