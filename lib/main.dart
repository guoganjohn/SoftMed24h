import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:softmed24h/src/screens/auth/login_screen.dart';
import 'package:softmed24h/src/screens/auth/register_screen.dart';
import 'package:softmed24h/src/screens/forget_password/email_sent_screen.dart';
import 'package:softmed24h/src/screens/forget_password/forget_password_screen.dart';
import 'package:softmed24h/src/screens/forget_password/reset_password_screen.dart';
import 'package:softmed24h/src/screens/home/home_page.dart';
import 'package:softmed24h/src/screens/landing/landing_screen.dart';
import 'package:softmed24h/src/screens/payment/payment_screen.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:softmed24h/src/screens/forget_password/token_error_screen.dart';
import 'package:softmed24h/src/utils/redirect_if_authenticated.dart';
import 'package:softmed24h/src/utils/session_manager.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setUrlStrategy(PathUrlStrategy());
  await dotenv.load(fileName: kReleaseMode ? ".env.production" : ".env.development");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SoftMed24h',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: 'Montserrat',
      ),
      home: FutureBuilder<String?>(
        future: SessionManager().getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const SplashScreen();
          }
          if (snapshot.hasData && snapshot.data != null) {
            return const HomePage();
          }
          return const LandingPage();
        },
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
              return const RedirectIfAuthenticated(child: LoginScreen());
            case '/register':
              return const RedirectIfAuthenticated(child: RegisterScreen());
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

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
