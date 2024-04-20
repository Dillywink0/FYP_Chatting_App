import 'package:flutter/material.dart';
import '../../Buttons/button.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(225, 138, 60, 55),
      body: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            const Text(
              'Message Man',
              style: TextStyle(
                fontSize: 28,
                color: Colors.amber,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.all(25),
              // child: Image.asset('lib/images/burger.png'),
            ),
            const SizedBox(height: 20),
            
            const SizedBox(
              height: 15,
            ),
            MyButton(
              text: "Get Started",
              onTap: () {
                Navigator.pushNamed(context, '/IntroScreen');
              },
            ),
          ],
        ),
      ),
    );
  }
}
