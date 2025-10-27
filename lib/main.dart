import 'package:flutter/material.dart';
import 'package:softmed24h/src/screens/auth/login_screen.dart';
import 'package:softmed24h/src/screens/auth/register_screen.dart';
import 'package:softmed24h/src/screens/forget_password/email_sent_screen.dart';
import 'package:softmed24h/src/screens/forget_password/forget_password_screen.dart';
import 'package:softmed24h/src/screens/forget_password/reset_password_screen.dart';
import 'package:softmed24h/src/screens/home/home_page.dart';
import 'package:softmed24h/src/screens/landing/landing_screen.dart';
import 'package:softmed24h/src/screens/payment/payment_screen.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:softmed24h/src/screens/forget_password/token_error_screen.dart';

void main() {
  usePathUrlStrategy();
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
      onGenerateRoute: (settings) {
        if (settings.name?.startsWith('/reset-password') == true) {
          final uri = Uri.parse(settings.name!);
          final token = uri.queryParameters['token'];
          if (token == null || token.isEmpty) {
            return MaterialPageRoute(builder: (context) => const TokenErrorScreen());
          }
          return MaterialPageRoute(builder: (context) => ResetPasswordScreen(token: token));
        }
        // Handle other routes
        return MaterialPageRoute(builder: (context) {
          switch (settings.name) {
            case '/':
              return const LandingPage();
            case '/login':
              return const LoginScreen();
            case '/register':
              return const RegisterScreen();
            case '/home':
              return const HomePage();
            case '/payment':
              return const PaymentScreen();
            case '/forgot-password':
              return const ForgetPasswordScreen();
            case '/email-sent':
              return const EmailSentScreen();
            default:
              return const Text('Error: Unknown route'); // Or a 404 page
          }
        });
      },
    );
  }
}
