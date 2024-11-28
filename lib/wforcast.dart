import 'package:flutter/material.dart';

class Forcast extends StatelessWidget {
  const Forcast({super.key, required this.icon, required this.time, required this.temp});
  final IconData icon;
  final String time;
  final String temp;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      child: Card(
        elevation: 10,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              Text(time),
              SizedBox(
                height: 10,
              ),
              Icon(icon,size: 32,),
              SizedBox(
                height: 10,
              ),
              Text(temp)
            ],
          ),
        ),
      ),
    );
  }
}
