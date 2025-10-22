import 'package:flutter/material.dart';
import 'package:softmed24h/src/widgets/app_button.dart';

// Placeholder class for AppColors (Copied from LoginScreen for consistency)
class AppColors {
  static const Color primary = Color(
    0xFF039BE5,
  ); // Deep Sky Blue (for buttons and text)
  static const Color secondary = Color(0xFFFFFFFF); // White (for backgrounds)
  static const Color accent = Color(0xFF1E88E5); // Medium Blue
  static const Color text = Color(0xFF424242); // Greyish text
  static const Color background = Color(
    0xFFF7F7F7,
  ); // Light background for form
}

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      // Use SingleChildScrollView to ensure the long form is scrollable
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Apply a max width to the form content on large screens for readability
            final bool isWideScreen = constraints.maxWidth >= 800;
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWideScreen ? 700 : constraints.maxWidth,
                ),
                child: Column(
                  children: [
                    // Form Header
                    _buildFormHeader(context),

                    // Form Body
                    _buildFormSection(context, isWideScreen),
                  ],
                ),
              ),
            );
          },
        ),
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
              label: 'Entrar',
              width: 200,
              height: 40,
              fontSize: 18,
              onPressed: () {
                Navigator.of(context).pushNamed('/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  // --- Form Header (New Widget) ---
  Widget _buildFormHeader(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        const Text(
          'Preencha o formulário abaixo para ter acesso à nossa área exclusiva do consumidor.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: AppColors.text),
        ),
        const SizedBox(height: 5),
        const Text(
          'Apenas itens marcados com * são obrigatórios.',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 14, color: Colors.red),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  // Right Section (Form) - Adapted for Registration Fields
  Widget _buildFormSection(BuildContext context, bool isWideScreen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Name
          _buildFormLabel('Nome', mandatory: true),
          _buildTextField(),
          const SizedBox(height: 20),

          // 2. E-mail
          _buildFormLabel('E-mail', mandatory: true),
          _buildTextField(keyboardType: TextInputType.emailAddress),
          const SizedBox(height: 20),

          // 3. Gender and CPF
          _buildGenderSection(context),
          const SizedBox(height: 20),

          // 4. Cell phone
          _buildFormLabel('Celular', mandatory: true, hint: ''),
          _buildTextField(keyboardType: TextInputType.phone, initialValue: ''),
          const SizedBox(height: 20),

          // 5. Date of birth
          _buildFormLabel('Data de Nascimento', mandatory: true),
          _buildTextField(keyboardType: TextInputType.datetime),
          const SizedBox(height: 20),

          // 6. Address Header and Input (Replicating Image Layout)
          _buildAddressHeader(),
          _buildAddressField('CEP:', '', hasChangeButton: false),
          const SizedBox(height: 20),

          // 7. Password
          _buildFormLabel('Senha', mandatory: true),
          _buildTextField(isPassword: true),
          const SizedBox(height: 20),

          // 8. Confirm Password
          _buildFormLabel('Confirme a senha', mandatory: true),
          _buildTextField(isPassword: true),
          const SizedBox(height: 30),

          // 9. Terms and Conditions
          _buildTermsAndConditions(context),

          const SizedBox(height: 30),

          // Register Button
          SizedBox(
            width: double.infinity,
            child: Container(
              alignment: Alignment.center,
              child: AppButton(
                label: 'Cadastrar',
                width: 200,
                height: 40,
                fontSize: 18,
                onPressed: () {},
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Field/Layout Helpers ---

  Widget _buildFormLabel(String label, {bool mandatory = false, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          if (mandatory)
            const Text('*', style: TextStyle(color: Colors.red, fontSize: 16)),
          Text(
            label,
            style: const TextStyle(
              color: AppColors.text,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (hint != null)
            Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                hint,
                style: const TextStyle(color: AppColors.text, fontSize: 12),
              ),
            ),
          const SizedBox(width: 4),
          // Question mark icon placeholder
          Icon(
            Icons.help_outline,
            size: 14,
            color: AppColors.text.withOpacity(0.6),
          ),
        ],
      ),
    );
  }

  Widget _buildGenderSection(BuildContext context) {
    // This is styled to match the image's use of separate inputs for Gender and CPF
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormLabel('Gênero', mandatory: true),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Radio Buttons for Gender
                  Row(
                    children: [
                      Radio(
                        value: 'Masculino',
                        groupValue: 'gender',
                        onChanged: (v) {},
                        activeColor: AppColors.primary,
                      ),
                      const Text(
                        'Masculino',
                        style: TextStyle(color: AppColors.text),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Feminino',
                        groupValue: 'gender',
                        onChanged: (v) {},
                        activeColor: AppColors.primary,
                      ),
                      const Text(
                        'Feminino',
                        style: TextStyle(color: AppColors.text),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Radio(
                        value: 'Não-binário',
                        groupValue: 'gender',
                        onChanged: (v) {},
                        activeColor: AppColors.primary,
                      ),
                      const Text(
                        'Não-binário',
                        style: TextStyle(color: AppColors.text),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              flex: 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // CPF Field
                  _buildFormLabel('CPF', mandatory: true),
                  _buildTextField(keyboardType: TextInputType.number),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAddressHeader() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Endereço',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.text,
            ),
          ),
          const Divider(color: Color(0xFFE0E0E0)),
        ],
      ),
    );
  }

  Widget _buildAddressField(
    String label,
    String hint, {
    bool hasChangeButton = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildFormLabel(label, mandatory: true),
        Container(
          height: 50, // Fixed height for visual alignment
          decoration: BoxDecoration(
            color: const Color(0xFFF0F4F8), // Light grey background
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: const Color(0xFFE0E0E0)),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hint,
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.text.withOpacity(0.8),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (hasChangeButton)
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Mudar',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Checkbox(
          value: true, // Placeholder value
          onChanged: (bool? newValue) {},
          activeColor: AppColors.primary,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  text: 'Li e concordo com os ',
                  style: const TextStyle(color: AppColors.text, fontSize: 14),
                  children: [
                    TextSpan(
                      text: 'Termos e Condições de Uso da Plataforma de Saúde',
                      style: TextStyle(
                        color: AppColors.primary,
                        decoration: TextDecoration.underline,
                      ),
                      // onTap: () => launch('url_to_terms'), // In a real app
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Em conformidade com a Lei Geral de Proteção de Dados (LGPD - Lei 13.709, de 14 de agosto de 2018), entenda por que coletamos os seus dados.',
                style: TextStyle(
                  color: AppColors.text.withOpacity(0.7),
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // --- Helper Widgets (Reused from Login Screen) ---

  Widget _buildTextField({
    bool isPassword = false,
    TextInputType keyboardType = TextInputType.text,
    String? initialValue,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8), // Light grey background
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextField(
        obscureText: isPassword,
        keyboardType: keyboardType,
        controller: initialValue != null
            ? TextEditingController(text: initialValue)
            : null,
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
