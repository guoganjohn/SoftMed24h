import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:softmed24h/src/services/ibge_service.dart';
import 'package:softmed24h/src/services/viacep_service.dart';
import 'package:softmed24h/src/utils/api_service.dart';
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
  final TextEditingController _logradouroController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  bool _acceptTerms = false; // State for terms and conditions checkbox
  String? _selectedGender; // State for selected gender

  Map<String, dynamic>? _addressData;
  bool _isCepFilled = false;
  bool _showManualAddress = false;
  List<String> _states = [];
  List<String> _cities = [];
  String? _selectedState;
  String? _selectedCity;

  final ViaCepService _viaCepService = ViaCepService();
  final IbgeService _ibgeService = IbgeService();

  @override
  void initState() {
    super.initState();
    _fetchStates();
    _cepController.addListener(() {
      if (_cepController.text.length == 9) {
        _fetchAddressFromCep();
      }
    });
  }

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
    _logradouroController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    super.dispose();
  }

  Future<void> _fetchStates() async {
    try {
      final states = await _ibgeService.fetchStates();
      setState(() {
        _states = states;
      });
    } catch (e) {
      _showSnackBar('Failed to load states', Colors.red);
    }
  }

  Future<void> _fetchCities(String state) async {
    try {
      final cities = await _ibgeService.fetchCities(state);
      setState(() {
        _cities = cities;
      });
    } catch (e) {
      _showSnackBar('Failed to load cities', Colors.red);
    }
  }

  Future<void> _fetchAddressFromCep() async {
    try {
      final address = await _viaCepService.fetchAddress(_cepController.text);
      setState(() {
        _addressData = address;
        _logradouroController.text = address['logradouro'] ?? '';
        _bairroController.text = address['bairro'] ?? '';
        _selectedState = address['uf'] ?? '';
        _fetchCities(_selectedState!).then((_) {
          setState(() {
            _selectedCity = address['localidade'] ?? '';
          });
        });
        _isCepFilled = true;
      });
    } catch (e) {
      _showSnackBar('Failed to load address from CEP', Colors.red);
    }
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
                  context.go('/');
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
                context.go('/login');
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
          _buildFormLabel('Nome', mandatory: true, tooltipMessage: 'Informe o seu nome completo.'),
          _buildTextField(
            controller: _nameController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu nome';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 2. E-mail
          _buildFormLabel('E-mail', mandatory: true, tooltipMessage: 'Informe o seu e-mail, que também servirá como login de acesso à área exclusiva do cliente.'),
          _buildTextField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu e-mail';
              }
              if (!RegExp(
                r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
              ).hasMatch(value)) {
                return 'Por favor, insira um e-mail válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 3. Gender and CPF
          _buildGenderSection(context),
          const SizedBox(height: 20),

          // CPF Field
          _buildFormLabel('CPF', mandatory: true, tooltipMessage: 'Informe o seu CPF. Pedimos o seu CPF apenas para evitar cadastros falsos e garantir a segurana dos pagamentos processados em nossa plataforma.'),
          _buildTextField(
            keyboardType: TextInputType.number,
            controller: _cpfController,
            inputFormatters: [CpfInputFormatter()], // Apply CPF mask
            hintText: '000.000.000-00', // Placeholder for CPF
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu CPF';
              }
              // Basic CPF length validation (adjust as needed for specific format)
              if (value.length != 14) {
                // CPF with mask is 14 characters long
                return 'O CPF deve ter 14 caracteres';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 4. Cell phone
          _buildFormLabel('Celular', mandatory: true, hint: '', tooltipMessage: 'Informe o seu telefone celular de contato.'),
          _buildTextField(
            keyboardType: TextInputType.phone,
            controller: _phoneController,
            inputFormatters: [PhoneInputFormatter()], // Apply phone mask
            hintText: '(00) 0000-0000', // Placeholder for phone number
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu número de telefone';
              }
              // Masked phone number length: (XX) XXXX-XXXX is 14 characters
              // Masked phone number length: (XX) XXXXX-XXXX is 15 characters (for 9-digit numbers)
              // Let's assume 11 digits (2 DDD + 9 number) for now, which is 15 masked characters
              if (value.length < 14) {
                // Minimum length for (XX) XXXX-XXXX
                return 'Por favor, insira um número de telefone válido';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 5. Date of birth
          _buildFormLabel('Data de Nascimento', mandatory: true, tooltipMessage: 'Informe a sua data de nascimento.'),
          _buildTextField(
            keyboardType: TextInputType.datetime,
            controller: _dobController,
            inputFormatters: [DateInputFormatter()], // Apply date mask
            hintText: 'DD/MM/YYYY', // Placeholder for date of birth
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira sua data de nascimento';
              }
              // Masked date length: DD/MM/YYYY is 10 characters
              if (value.length != 10) {
                return 'Por favor, insira uma data válida (DD/MM/YYYY)';
              }
              return null;
            },
          ),
          const SizedBox(height: 20),

          // 6. Address Section
          _buildAddressSection(),
          const SizedBox(height: 20),

          // 7. Password
          _buildFormLabel('Senha', mandatory: true, tooltipMessage: 'Escolha a sua senha de acesso ao nosso portal.'),
          _buildTextField(
            isPassword: true,
            obscureText: _obscurePassword,
            controller: _passwordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira uma senha';
              }
              if (value.length < 6) {
                return 'A senha deve ter pelo menos 6 caracteres';
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
          _buildFormLabel('Confirme a senha', mandatory: true, tooltipMessage: 'Repita a sua senha de acesso.'),
          _buildTextField(
            isPassword: true,
            obscureText: _obscureConfirmPassword,
            controller: _confirmPasswordController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, confirme sua senha';
              }
              if (value != _passwordController.text) {
                return 'As senhas não correspondem';
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
                  if (_formKey.currentState!.validate()) {
                    if (!_acceptTerms) {
                      _showSnackBar(
                        'Você deve aceitar os termos e condições',
                        Colors.red,
                      );
                      return;
                    }
                    if (_selectedGender == null) {
                      _showSnackBar('Por favor, selecione seu gênero', Colors.red);
                      return;
                    }
                    // Password match check is now handled by the validator in _buildTextField
                  
                    final apiService = ApiService();
                    try {
                      // Reformat birthday from DD/MM/YYYY to YYYY-MM-DD
                      final List<String> dobParts = _dobController.text.split(
                        '/',
                      );
                      final String formattedBirthday =
                          '${dobParts[2]}-${dobParts[1]}-${dobParts[0]}';
                  
                      await apiService.register(
                        _emailController.text,
                        _passwordController.text,
                        _nameController.text,
                        _selectedGender,
                        _cpfController.text,
                        _phoneController.text,
                        formattedBirthday,
                        _cepController.text,
                        _logradouroController.text,
                        _numeroController.text,
                        _complementoController.text,
                        _bairroController.text,
                        _selectedState!,
                        _selectedCity!,
                      );
                      _showSnackBar(
                        'Cadastro realizado com sucesso! Por favor, faça o pagamento.',
                        Colors.green,
                      );
                      context.go('/payment');
                    } catch (e) {
                      _showSnackBar(
                        'Falha no cadastro: ${e.toString()}',
                        Colors.red,
                      );
                    }
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddressSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildAddressHeader(),
        if (!_isCepFilled)
          _buildAddressField(
            'CEP:',
            '',
            hasChangeButton: false,
            controller: _cepController,
            inputFormatters: [CepInputFormatter()], // Apply CEP mask
            hintText: '00000-000', // Placeholder for CEP
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu CEP';
              }
              // Masked CEP length: XXXXX-XXX is 9 characters
              if (value.length != 9) {
                return 'O CEP deve ter 9 caracteres';
              }
              return null;
            },
          )
        else if (_showManualAddress)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFormLabel('CEP', mandatory: true, tooltipMessage: 'Informe o CEP do seu endereo.'),
              _buildTextField(
                controller: _cepController,
                inputFormatters: [CepInputFormatter()],
                hintText: '00000-000',
              ),
              const SizedBox(height: 20),
              _buildFormLabel('Logradouro', mandatory: true, tooltipMessage: 'Informe o nome da rua ou avenida do seu endereo.'),
              _buildTextField(controller: _logradouroController),
              const SizedBox(height: 20),
              _buildFormLabel('Número', mandatory: true, tooltipMessage: 'Informe o número do imóvel do seu endereo.'),
              _buildTextField(controller: _numeroController),
              const SizedBox(height: 20),
              _buildFormLabel('Complemento', tooltipMessage: 'Informe o complemento do seu endereo, se houver.'),
              _buildTextField(controller: _complementoController),
              const SizedBox(height: 20),
              _buildFormLabel('Bairro', mandatory: true, tooltipMessage: 'Informe o bairro do seu endereo.'),
              _buildTextField(controller: _bairroController),
              const SizedBox(height: 20),
              _buildFormLabel('Estado', mandatory: true, tooltipMessage: 'Informe o estado do seu endereo.'),
              DropdownButtonFormField<String>(
                value: _selectedState,
                items: _states.map((String state) {
                  return DropdownMenuItem<String>(
                    value: state,
                    child: Text(state),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedState = newValue;
                    _selectedCity = null;
                    _cities = [];
                    if (newValue != null) {
                      _fetchCities(newValue);
                    }
                  });
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
              const SizedBox(height: 20),
              _buildFormLabel('Cidade', mandatory: true, tooltipMessage: 'Informe a cidade do seu endereo.'),
              DropdownButtonFormField<String>(
                value: _selectedCity,
                items: _cities.map((String city) {
                  return DropdownMenuItem<String>(
                    value: city,
                    child: Text(city),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedCity = newValue;
                  });
                },
                decoration: const InputDecoration(border: OutlineInputBorder()),
              ),
            ],
          )
        else
          Row(
            children: [
                                Expanded(
                                  child: Text(
                                    'CEP ${_cepController.text} - ${_addressData!['logradouro']}${_addressData!['numero'] != null && _addressData!['numero'].isNotEmpty ? ', N° ${_addressData!['numero']}' : ''}${_addressData!['complemento'] != null && _addressData!['complemento'].isNotEmpty ? ', ${_addressData!['complemento']}' : ''}, ${_addressData!['bairro']}, ${_addressData!['localidade']}/${_addressData!['uf']}',
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                ),              TextButton(
                onPressed: () {
                  setState(() {
                    _showManualAddress = true;
                    _numeroController.text = _addressData!['numero'] ?? '';
                    _complementoController.text = _addressData!['complemento'] ?? '';
                  });
                },
                child: const Text('Mudar'),
              ),
            ],
          ),
      ],
    );
  }
  
  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  // --- Field/Layout Helpers ---

  Widget _buildFormLabel(String label, {bool mandatory = false, String? hint, String? tooltipMessage}) {
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
          if (tooltipMessage != null) // Only show tooltip icon if message is provided
            GestureDetector(
              onTap: () {
                _showSnackBar(tooltipMessage, AppColors.primary); // Show tooltip message in a SnackBar
              },
              child: Tooltip( // Keep the Tooltip for hover, but also add tap functionality
                message: tooltipMessage,
                child: Icon(
                  Icons.help_outline,
                  size: 14,
                  color: AppColors.text.withOpacity(0.6),
                ),
              ),
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
        _buildFormLabel('Gênero', mandatory: true, tooltipMessage: 'Informe o seu gênero.'),
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
