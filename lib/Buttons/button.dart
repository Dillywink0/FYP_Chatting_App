import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final String text;
  final void Function()? onTap;

  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          decoration: BoxDecoration(
              color: const Color.fromARGB(212, 135, 81, 77),
              borderRadius: BorderRadius.circular(40)),
          padding: const EdgeInsets.all(20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                text,
                style: const TextStyle(color: Colors.amber),
              ),
              const SizedBox(
                height: 15,
              ),
              const Icon(
                Icons.arrow_forward,
                color: Colors.amber,
              )
            ],
          )),
    );
  }
}
