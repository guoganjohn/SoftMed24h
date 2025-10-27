import 'package:flutter/material.dart';
import 'package:softmed24h/src/screens/auth/login_screen.dart';
import 'package:softmed24h/src/screens/auth/register_screen.dart';
import 'package:softmed24h/src/screens/forget_password/email_sent_screen.dart';
import 'package:softmed24h/src/screens/forget_password/forget_password_screen.dart';
import 'package:softmed24h/src/screens/forget_password/reset_password_screen.dart';
import 'package:softmed24h/src/screens/home/home_page.dart';
import 'package:softmed24h/src/screens/landing/landing_screen.dart';
import 'package:softmed24h/src/screens/payment/payment_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoftMed24h',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Montserrat',
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LandingPage(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomePage(),
        '/payment': (context) => const PaymentScreen(),
        '/forgot-password': (context) => const ForgetPasswordScreen(),
        '/email-sent': (context) => const EmailSentScreen(),
        '/reset-password': (context) => const ResetPasswordScreen(),
      },
    );
  }
}
