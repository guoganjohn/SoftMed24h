import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Required for FilteringTextInputFormatter
import 'package:softmed24h/src/utils/app_colors.dart';
import 'package:softmed24h/src/utils/input_formatters.dart';
import 'package:softmed24h/src/widgets/app_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _acceptTerms = false; // State for terms and conditions checkbox
  String? _selectedGender; // State for selected gender

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _phoneController.dispose();
    _dobController.dispose();
    _cpfController.dispose();
    _cepController.dispose();
    super.dispose();
  }

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
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Form Header
                      _buildFormHeader(context),

                      // Form Body
                      _buildFormSection(context, isWideScreen),
                    ],
                  ),
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
            MouseRegion(
              cursor: SystemMouseCursors.click,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(
                    context,
                  ).pushNamedAndRemoveUntil('/', (route) => false);
                },
                child: Row(
                  children: [
                    Image.asset(
                      'assets/images/logo.png',
                      height: 40,
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'MeuMed',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          'Nosso plano é a sua saúde',
                          style: TextStyle(color: AppColors.text, fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Entrar',
              width: 200,
              height: 40,
              fontSize: 18,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
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
          _buildTextField(
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 2. E-mail
          _buildFormLabel('E-mail', mandatory: true),
          _buildTextField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              ).hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 3. Gender and CPF
          _buildGenderSection(context),
          const SizedBox(height: 20),

          // CPF Field
          _buildFormLabel('CPF', mandatory: true),
          _buildTextField(
            keyboardType: TextInputType.number,
            controller: _cpfController,
            inputFormatters: [CpfInputFormatter()], // Apply CPF mask
            hintText: 'XXX.XXX.XXX-XX', // Placeholder for CPF
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your CPF';
              }
              // Basic CPF length validation (adjust as needed for specific format)
              if (value.length != 14) {
                // CPF with mask is 14 characters long
                return 'CPF must be 14 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 4. Cell phone
          _buildFormLabel('Celular', mandatory: true, hint: ''),
          _buildTextField(
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            inputFormatters: [PhoneInputFormatter()], // Apply phone mask
            hintText: '(XX) XXXX-XXXX', // Placeholder for phone number
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              // Masked phone number length: (XX) XXXX-XXXX is 14 characters
              // Masked phone number length: (XX) XXXXX-XXXX is 15 characters (for 9-digit numbers)
              // Let's assume 11 digits (2 DDD + 9 number) for now, which is 15 masked characters
              if (value.length < 14) {
                // Minimum length for (XX) XXXX-XXXX
                return 'Please enter a valid phone number';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 5. Date of birth
          _buildFormLabel('Data de Nascimento', mandatory: true),
          _buildTextField(
            keyboardType: TextInputType.datetime,
            controller: _dobController,
            inputFormatters: [DateInputFormatter()], // Apply date mask
            hintText: 'DD/MM/YYYY', // Placeholder for date of birth
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your date of birth';
              }
              // Masked date length: DD/MM/YYYY is 10 characters
              if (value.length != 10) {
                return 'Please enter a valid date (DD/MM/YYYY)';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 6. Address Header and Input (Replicating Image Layout)
          _buildAddressHeader(),
          _buildAddressField(
            'CEP:',
            '',
            hasChangeButton: false,
            controller: _cepController,
            inputFormatters: [CepInputFormatter()], // Apply CEP mask
            hintText: 'XXXXX-XXX', // Placeholder for CEP
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your CEP';
              }
              // Masked CEP length: XXXXX-XXX is 9 characters
              if (value.length != 9) {
                return 'CEP must be 9 characters long';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 7. Password
          _buildFormLabel('Senha', mandatory: true),
          _buildTextField(
            isPassword: true,
            obscureText: _obscurePassword,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters long';
              }
              return null;
            },
            onToggleVisibility: () {
              setState(() {
                _obscurePassword = !_obscurePassword;
              });
            },
          ),
          const SizedBox(height: 20),

          // 8. Confirm Password
          _buildFormLabel('Confirme a senha', mandatory: true),
          _buildTextField(
            isPassword: true,
            obscureText: _obscureConfirmPassword,
            controller: _confirmPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please confirm your password';
              }
              if (value != _passwordController.text) {
                return 'Passwords do not match';
              }
              return null;
            },
            onToggleVisibility: () {
              setState(() {
                _obscureConfirmPassword = !_obscureConfirmPassword;
              });
            },
          ),
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
                onPressed: () async {
                  // if (_formKey.currentState!.validate()) {
                  //   if (!_acceptTerms) {
                  //     _showSnackBar(
                  //       'You must accept the terms and conditions',
                  //       Colors.red,
                  //     );
                  //     return;
                  //   }
                  //   if (_selectedGender == null) {
                  //     _showSnackBar('Please select your gender', Colors.red);
                  //     return;
                  //   }
                  //   // Password match check is now handled by the validator in _buildTextField
                  //
                  //   final apiService = ApiService();
                  //   try {
                  //     // Reformat birthday from DD/MM/YYYY to YYYY-MM-DD
                  //     final List<String> dobParts = _dobController.text.split(
                  //       '/',
                  //     );
                  //     final String formattedBirthday =
                  //         '${dobParts[2]}-${dobParts[1]}-${dobParts[0]}';
                  //
                  //     await apiService.register(
                  //       _emailController.text,
                  //       _passwordController.text,
                  //       _nameController.text,
                  //       _selectedGender,
                  //       _cpfController.text,
                  //       _phoneController.text,
                  //       formattedBirthday,
                  //       _cepController.text,
                  //     );
                  //     _showSnackBar(
                  //       'Registration successful! Please login.',
                  //       Colors.green,
                  //     );
                  //     Navigator.of(context).pushReplacementNamed('/login');
                  //   } catch (e) {
                  //     _showSnackBar(
                  //       'Registration failed: ${e.toString()}',
                  //       Colors.red,
                  //     );
                  //   }
                  // }
                  Navigator.of(context).pushReplacementNamed('/payment');
                },
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
                      Radio<String>(
                        value: 'Masculino',
                        groupValue: _selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
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
                      Radio<String>(
                        value: 'Feminino',
                        groupValue: _selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
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
                      Radio<String>(
                        value: 'Não-binário',
                        groupValue: _selectedGender,
                        onChanged: (String? value) {
                          setState(() {
                            _selectedGender = value;
                          });
                        },
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
                  // CPF Field (This will be removed as CPF field is moved outside)
                  // _buildFormLabel('CPF', mandatory: true),
                  // _buildTextField(keyboardType: TextInputType.number),
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
    TextEditingController? controller,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
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
                  child: TextFormField(
                    controller: controller,
                    validator: validator,
                    inputFormatters: inputFormatters, // Applied inputFormatters
                    decoration: InputDecoration(
                      hintText: hintText, // Added hintText
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.text.withOpacity(0.8),
                    ),
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
          value: _acceptTerms, // Use state variable
          onChanged: (bool? newValue) {
            setState(() {
              _acceptTerms = newValue ?? false;
            });
          },
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
    bool obscureText = false,
    VoidCallback? onToggleVisibility,
    TextInputType keyboardType = TextInputType.text,
    String? initialValue,
    TextEditingController? controller,
    String? Function(String?)? validator,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF0F4F8), // Light grey background
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFE0E0E0)),
      ),
      child: TextFormField(
        // Changed to TextFormField
        obscureText: obscureText,
        keyboardType: keyboardType,
        controller:
            controller ??
            (initialValue != null
                ? TextEditingController(text: initialValue)
                : null),
        validator: validator, // Applied validator
        inputFormatters: inputFormatters, // Applied inputFormatters
        decoration: InputDecoration(
          hintText: hintText, // Added hintText
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 15,
          ),
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: AppColors.primary,
                  ),
                  onPressed: onToggleVisibility,
                )
              : null,
        ),
        style: const TextStyle(fontSize: 16, color: AppColors.text),
      ),
    );
  }
}
