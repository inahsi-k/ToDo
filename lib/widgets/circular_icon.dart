import 'package:flutter/material.dart';
import 'package:todo/firebase%20methods/authentication.dart';
import 'package:todo/screens/home.dart';

class CircularIconButton extends StatelessWidget {
  final String imagePath;
  const CircularIconButton({super.key,required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ()async{
        String res = await Authentication().signInWithGoogle();
        if (res == 'Success') {
          Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (context) => Home()),
            (route) => false,
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
        }
      },
      child: Container(
        width: 50,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white, // Background color
          shape: BoxShape.circle, // Make it circular
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.6),
              spreadRadius: 2,
              blurRadius: 8,
              offset: Offset(2, 4), // changes position of shadow
            ),
          ],
        ),
        child: Image.asset(imagePath),
      ),
    );
  }
}
