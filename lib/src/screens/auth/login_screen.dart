import 'package:flutter/material.dart';
import 'package:softmed24h/src/utils/api_service.dart';
import 'package:softmed24h/src/widgets/app_button.dart';

// Placeholder class for AppColors
class AppColors {
  static const Color primary = Color(
    0xFF039BE5,
  ); // Deep Sky Blue (for buttons and text)
  static const Color secondary = Color(0xFFFFFFFF); // White (for backgrounds)
  static const Color accent = Color(0xFF1E88E5); // Medium Blue
  static const Color text = Color(0xFF424242); // Greyish text
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 800) {
            // Mobile/Narrow Layout
            return _buildMobileLayout(context);
          } else {
            // Tablet/Desktop Layout
            return _buildDesktopLayout(context);
          }
        },
      ),
    );
  }

  // --- App Bar ---

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.secondary,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            // Logo Placeholder (e.g., Image.asset('images/logo.png'))
            GestureDetector(
              onTap: () {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/', (route) => false);
              },
              child: const Row(
                children: [
                  Text(
                    'MeuMed',
                    style: TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    'Nosso plano é a sua saúde',
                    style: TextStyle(color: AppColors.text, fontSize: 12),
                  ),
                ],
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Cadastrar',
              width: 200,
              height: 40,
              fontSize: 18,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/register');
              },
            ),
          ],
        ),
      ),
    );
  }
  // --- Desktop/Wide Layout ---

  Widget _buildDesktopLayout(BuildContext context) {
    return Row(
      children: [
        // Left Side: Image and CTA Text
        Expanded(flex: 5, child: _buildImageSection(context)),
        // Right Side: Login Form
        Expanded(
          flex: 4,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 400),
              child: _buildFormSection(context),
            ),
          ),
        ),
      ],
    );
  }

  // Left Section (Image)
  Widget _buildImageSection(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.accent, // Background for safety
        // Placeholder for the large image
        image: DecorationImage(
          image: AssetImage('images/doctors_login.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        // Apply a subtle dark overlay at the bottom for text contrast
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0),
              Colors.black.withOpacity(0.5),
            ],
            stops: const [0.6, 1.0],
          ),
        ),
        alignment: Alignment.bottomLeft,
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Junte-se a nós com o ',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  'MeuMed.',
                  style: TextStyle(
                    color: AppColors.secondary,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 5),
            const Text(
              'Saúde Conectada: Atendimento Superior, Planos Personalizados e Inovação Tecnológica ao Seu Alcance!',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 16,
                fontWeight: FontWeight.w300,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Right Section (Form)
  Widget _buildFormSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(40.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Bem-vindo ao MeuMed!',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'Preencha os campos abaixo.',
            style: TextStyle(fontSize: 18, color: AppColors.text),
          ),
          const SizedBox(height: 40),

          // Email/CPF Field
          const Text('E-mail ou CPF', style: TextStyle(color: AppColors.text)),
          const SizedBox(height: 8),
          _buildTextField(controller: _emailController),
          const SizedBox(height: 20),

          // Password Field
          const Text('Senha', style: TextStyle(color: AppColors.text)),
          const SizedBox(height: 8),
          _buildTextField(isPassword: true, controller: _passwordController),

          // Forgot Password
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {},
              child: const Text(
                'Esqueceu a senha?',
                style: TextStyle(color: AppColors.primary),
              ),
            ),
          ),

          const SizedBox(height: 30),

          // Login Button
          SizedBox(
            width: double.infinity,
            child: Container(
              alignment: Alignment.center,
              child: AppButton(
                label: 'Entrar',
                width: 200,
                height: 40,
                fontSize: 18,
                onPressed: () async {
                  final apiService = ApiService();
                  try {
                    final authResponse = await apiService.login(
                      _emailController.text,
                      _passwordController.text,
                    );
                    _showSnackBar(
                      'Login successful! Token: ${authResponse.accessToken}',
                      Colors.green,
                    );
                    Navigator.of(context).pushReplacementNamed('/home');
                  } catch (e) {
                    _showSnackBar('Login failed: ${e.toString()}', Colors.red);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  // --- Mobile/Narrow Layout ---

  Widget _buildMobileLayout(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Top half: Form
          _buildFormSection(context),

          // Bottom half: Image and CTA (Simplified for mobile)
          SizedBox(
            height: 300, // Fixed height for the image section on mobile
            child: _buildImageSection(context),
          ),
        ],
      ),
    );
  }

  // --- Helper Widgets ---

  Widget _buildTextField({
    bool isPassword = false,
    required TextEditingController controller,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8), // Light grey background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        controller: controller,
        obscureText: isPassword,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          suffixIcon: isPassword
              ? const Icon(Icons.visibility_outlined, color: AppColors.primary)
              : null,
        ),
        style: const TextStyle(fontSize: 16, color: AppColors.text),
      ),
    );
  }
}
