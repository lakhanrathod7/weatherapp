import 'package:flutter/material.dart';

class Information extends StatelessWidget {
  const Information({super.key, required this.icon, required this.label, required this.value, });
  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon,size: 32,),
        SizedBox(height: 10,),
        Text(label,style: TextStyle(fontSize: 16),),
        SizedBox(height: 10,),
        Text(value,style: TextStyle(fontSize: 20),)

      ],
    );
  }
}
