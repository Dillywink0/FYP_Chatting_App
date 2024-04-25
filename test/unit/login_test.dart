import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:chat_app/Pages/Login/login.dart'; // Import your login page widget
import 'package:path_provider/path_provider.dart';

// Define nextScreen function locally
void nextScreen() {
  // Define the behavior of nextScreen here
}

void main() {
  group('Login Page', () {
    testWidgets('Email and password fields are displayed',
        (WidgetTester tester) async {
      // Build the LoginPage widget.
      await tester.pumpWidget(const MaterialApp(
        home: LoginPage(
          authService: null,
        ),
      ));

      // Verify that email and password fields are displayed.
      expect(find.byKey(const Key('email_field')), findsOneWidget);
      expect(find.byKey(const Key('password_field')), findsOneWidget);

      // Export data to file
      await exportDataToFile('email_and_password_fields.txt',
          'Email field and password field are displayed.');
    });

    testWidgets('Login button is displayed', (WidgetTester tester) async {
      // Build the LoginPage widget.
      await tester.pumpWidget(const MaterialApp(
        home: LoginPage(
          authService: null,
        ),
      ));

      // Verify that login button is displayed.
      expect(find.byKey(const Key('login_button')), findsOneWidget);

      // Export data to file
      await exportDataToFile('login_button.txt', 'Login button is displayed.');
    });

    testWidgets('Entering valid email and password triggers login',
        (WidgetTester tester) async {
      // Build the LoginPage widget.
      await tester.pumpWidget(const MaterialApp(
        home: LoginPage(
          authService: null,
        ),
      ));

      // Enter valid email and password.
      await tester.enterText(
          find.byKey(const Key('email_field')), 'example@email.com');
      await tester.enterText(
          find.byKey(const Key('password_field')), 'password');

      // Tap the login button.
      await tester.tap(find.byKey(const Key('login_button')));
      await tester.pump();

      // Verify that the login process is triggered.
      // You can expect some UI change or navigation after successful login.
      // For example, you can verify that a CircularProgressIndicator is displayed.
      expect(find.byType(CircularProgressIndicator), findsOneWidget);

      // Export data to file
      await exportDataToFile(
          'login_process.txt', 'Login process is triggered.');
    });

    // Add more test cases as needed...
  });
}

// Function to export data to a file
Future<void> exportDataToFile(String fileName, String data) async {
  final directory = await getApplicationDocumentsDirectory();
  final file = File('${directory.path}/$fileName');
  await file.writeAsString(data);
}
