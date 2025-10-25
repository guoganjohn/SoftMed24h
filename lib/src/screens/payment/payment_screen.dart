import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:softmed24h/src/utils/app_colors.dart';
import 'package:softmed24h/src/widgets/app_button.dart';

// --- ENUM FOR PAYMENT METHOD ---
enum PaymentMethod { creditCard, pixBoleto }

// --- MAIN SCREEN WIDGET ---
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen>
    with SingleTickerProviderStateMixin {
  PaymentMethod _selectedPaymentMethod = PaymentMethod.creditCard;
  bool _saveCardChecked = false;

  // Controllers for the form fields
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _cardNumberController = TextEditingController();
  final TextEditingController _expiryController = TextEditingController();
  final TextEditingController _cvvController = TextEditingController();
  final TextEditingController _cpfController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _cepController = TextEditingController();

  // Global key for form validation
  final _formKey = GlobalKey<FormState>();
  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController!.addListener(() {
      setState(() {}); // To rebuild the widget when tab changes
    });
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _nameController.dispose();
    _cardNumberController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    _cpfController.dispose();
    _phoneController.dispose();
    _cepController.dispose();
    super.dispose();
  }

  // Mock function for payment
  void _processPayment() {
    if (_formKey.currentState!.validate()) {
      // In a real app, this would call an API
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Pagamento em processamento...')),
      );
      // Simulate API call delay
      Future.delayed(const Duration(seconds: 2), () {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sucesso! Simulação de pagamento concluída.'),
          ),
        );
      });
    }
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: AppColors.secondary,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.of(context)
                    .pushNamedAndRemoveUntil('/home', (route) => false);
              },
              child: const Text(
                'Minha Conta',
                style: TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            const Spacer(),
            AppButton(
              label: 'Sair',
              width: 150,
              height: 40,
              fontSize: 18,
              icon: Icons.logout,
              iconSize: 20,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine the maximum width for the form card on large screens
    final screenWidth = MediaQuery.of(context).size.width;
    final contentWidth = screenWidth > 800 ? 700.0 : screenWidth * 0.9;

    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            constraints: BoxConstraints(maxWidth: contentWidth),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // 1. Inactive Subscription Warning
                _buildWarningBanner(),
                const SizedBox(height: 16),
                // 2. Main Content Card
                Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          // Tabs (Mocked as just Payment)
                          _buildTabs(),
                          const SizedBox(height: 32),
                          if (_tabController?.index == 0)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Plan Details
                                _buildPlanDetails(),
                                const Divider(height: 32),
                                // Order Data
                                _buildOrderData(),
                                const Divider(height: 32),
                                // Account Data
                                _buildAccountData(),
                                const Divider(height: 32),
                                // Payment Data (Credit Card Form)
                                _buildPaymentData(),
                              ],
                            )
                          else
                            _buildEmptyHistory(),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Payment Button
                if (_tabController?.index == 0) _buildPaymentButton(),
                const SizedBox(height: 24),
                // Legal Disclaimer
                _buildLegalDisclaimer(),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // --- WIDGET BUILDERS ---

  Widget _buildWarningBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFFEEEE), // Light red background
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(4),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.warning_amber_rounded, color: Colors.red),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              'Atenção: Sua assinatura encontra-se inativa. Pague agora mesmo para desfrutar dos benefícios de fazer parte da plataforma de saúde.',
              style: TextStyle(color: Colors.red, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return TabBar(
      controller: _tabController,
      tabs: const [
        Tab(text: 'Pagamento'),
        Tab(text: 'Histórico de Pagamentos'),
      ],
      labelColor: Colors.white,
      unselectedLabelColor: Colors.grey.shade600,
      indicatorSize: TabBarIndicatorSize.tab,
      indicator: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 48.0),
        child: Text(
          'Nenhum histórico de pagamento encontrado.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildPlanDetails() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0F8FF), // Very light blue background
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left side: Icon and Title
          Column(
            children: [
              Image.asset(
                'assets/images/logo.png',
                height: 40,
              ),
              const SizedBox(height: 8),
              const Text(
                'R\$ 49,90',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1976D2),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          // Right side: Plan description
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Atendimento Médico 24H',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue.shade900,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'ATENDIMENTO PREMIUM',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.blueGrey,
                  ),
                ),
                const SizedBox(height: 8),
                // Features list
                _buildFeatureBullet('Atendimento para todas as idades.'),
                _buildFeatureBullet('Telemedicina.'),
                _buildFeatureBullet('Receitas e Atestados.'),
                _buildFeatureBullet('Solicitação de exames e acompanhamento.'),
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerRight,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.blue.shade700,
                      side: BorderSide(color: Colors.blue.shade700),
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                    ),
                    child: const Text('Selecionar'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: Colors.black)),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13))),
        ],
      ),
    );
  }

  Widget _buildOrderData() {
    return _InfoSection(
      title: 'Dados do Pedido',
      children: [
        const SizedBox(height: 8),
        // Credit Card Radio
        _buildPaymentRadio(
          title: 'Cartão de Crédito',
          value: PaymentMethod.creditCard,
        ),
        // Pix/Boleto Radio
        _buildPaymentRadio(
          title: 'Pix / Boleto de Consulta',
          value: PaymentMethod.pixBoleto,
        ),
        const SizedBox(height: 8),
        const Text(
          'O seu pedido é pago online, utilizando cartão de crédito. Todo o processamento do pagamento é realizado de maneira automatizada.',
          style: TextStyle(fontSize: 12, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildPaymentRadio({
    required String title,
    required PaymentMethod value,
  }) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(title, style: const TextStyle(fontSize: 14)),
      leading: Radio<PaymentMethod>(
        value: value,
        groupValue: _selectedPaymentMethod,
        onChanged: (PaymentMethod? newValue) {
          setState(() {
            _selectedPaymentMethod = newValue!;
          });
        },
      ),
      dense: true,
      horizontalTitleGap: 0,
    );
  }

  Widget _buildAccountData() {
    return _InfoSection(
      title: 'Dados da Conta',
      children: [
        const SizedBox(height: 8),
        _buildReadOnlyField('Responsável:', 'Aliceia Clara S.'),
        _buildReadOnlyField('Email:', 'aliceiasimples@outlook.com'),
        _buildReadOnlyField(
          'Celular:',
          '098.431.854/0001-44',
        ), // Placeholder for document/phone
      ],
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black54)),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentData() {
    return _InfoSection(
      title: 'Dados de Pagamento',
      children: [
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerRight,
          child: TextButton(
            onPressed: () {
              // Mock action: Use my data
            },
            child: const Text(
              'Utilizar Meus Dados',
              style: TextStyle(fontSize: 13),
            ),
          ),
        ),
        // Credit Card Form
        if (_selectedPaymentMethod == PaymentMethod.creditCard)
          Column(
            children: [
              _PaymentTextField(
                controller: _nameController,
                label: 'Nome Impresso no Cartão',
                hintText: 'Nome completo no cartão',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Campo obrigatório' : null,
              ),
              _PaymentTextField(
                controller: _cardNumberController,
                label: 'Número do Cartão',
                hintText: '0000 0000 0000 0000',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(16),
                  _CardNumberInputFormatter(),
                ],
                validator: (value) => value == null || value.length < 16
                    ? 'Número de cartão inválido'
                    : null,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _PaymentTextField(
                      controller: _expiryController,
                      label: 'Validade',
                      hintText: 'MM/AA',
                      keyboardType: TextInputType.datetime,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                        _ExpiryDateInputFormatter(),
                      ],
                      validator: (value) => value == null || value.length < 5
                          ? 'Data inválida (MM/AA)'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _PaymentTextField(
                      controller: _cvvController,
                      label: 'Código de Segurança',
                      hintText: 'CVV',
                      keyboardType: TextInputType.number,
                      isObscured: true,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(4),
                      ],
                      validator: (value) => value == null || value.length < 3
                          ? 'Código inválido'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Cardholder Data
              _PaymentTextField(
                controller: _cpfController,
                label: 'CPF',
                hintText: '000.000.000-00',
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(11),
                ],
                validator: (value) =>
                    value == null || value.length < 11 ? 'CPF inválido' : null,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _PaymentTextField(
                      controller: _phoneController,
                      label: 'Celular',
                      hintText: '(00) 00000-0000',
                      keyboardType: TextInputType.phone,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(11),
                      ],
                      validator: (value) => value == null || value.length < 11
                          ? 'Telefone inválido'
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _PaymentTextField(
                      controller: _cepController,
                      label: 'CEP',
                      hintText: '00000-000',
                      keyboardType: TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(8),
                      ],
                      validator: (value) => value == null || value.length < 8
                          ? 'CEP inválido'
                          : null,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              // Save Card Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _saveCardChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        _saveCardChecked = newValue!;
                      });
                    },
                  ),
                  const Text('Salvar Cartão', style: TextStyle(fontSize: 14)),
                ],
              ),
              const SizedBox(height: 8),
              // Security Info
              const Text(
                'As suas informações de pagamento serão armazenadas no sistema com a mais alta tecnologia de criptografia disponível atualmente e facilitarão o processo de pagamento em suas próximas compras. Para garantir ainda mais a integridade dos seus dados, o código de segurança do cartão de crédito não será armazenado e deverá ser informado em sua próxima compra.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
            ],
          ),
        // Pix/Boleto Info (Placeholder)
        if (_selectedPaymentMethod == PaymentMethod.pixBoleto)
          const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Text(
              'O pagamento via Pix ou Boleto será processado após a confirmação. Instruções serão enviadas por e-mail.',
              style: TextStyle(fontSize: 14, color: Colors.blueGrey),
            ),
          ),
      ],
    );
  }

  Widget _buildPaymentButton() {
    return Center(
      child: ElevatedButton(
        onPressed: _processPayment,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade700,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        child: const Text('PAGAR'),
      ),
    );
  }

  Widget _buildLegalDisclaimer() {
    return const Text(
      'Em conformidade com a Lei Geral de Proteção de Dados (LGPD - Lei 13.709, de 14 de agosto de 2018), entenda por que coletamos os seus dados.',
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 11, color: Colors.grey),
    );
  }
}

// --- REUSABLE WIDGETS ---

// Widget for structuring information sections with a title and an info icon
class _InfoSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InfoSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.help_outline, size: 16, color: Colors.blue),
          ],
        ),
        ...children,
      ],
    );
  }
}

// Custom TextField that includes a help icon next to the label (as seen in the screenshot)
class _PaymentTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final TextInputType keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final bool isObscured;
  final FormFieldValidator<String>? validator;

  const _PaymentTextField({
    required this.controller,
    required this.label,
    this.hintText = '',
    this.keyboardType = TextInputType.text,
    this.inputFormatters,
    this.isObscured = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.help_outline, size: 14, color: Colors.blue),
            ],
          ),
          const SizedBox(height: 4),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            inputFormatters: inputFormatters,
            obscureText: isObscured,
            validator: validator,
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 10.0,
                horizontal: 12.0,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- INPUT FORMATTERS (Simulated) ---

// Formatter to add spaces to card number (4 digits each)
class _CardNumberInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll(RegExp(r'\s+'), '');
    if (text.length > 16) {
      text = text.substring(0, 16);
    }
    var buffer = StringBuffer();
    for (int i = 0; i < text.length; i++) {
      buffer.write(text[i]);
      var nonZeroIndex = i + 1;
      if (nonZeroIndex % 4 == 0 && nonZeroIndex != text.length) {
        buffer.write(' ');
      }
    }
    var string = buffer.toString();
    return newValue.copyWith(
      text: string,
      selection: TextSelection.collapsed(offset: string.length),
    );
  }
}

// Formatter for MM/YY expiry date
class _ExpiryDateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String text = newValue.text.replaceAll('/', '');
    if (text.length > 4) {
      text = text.substring(0, 4);
    }

    if (text.length >= 2) {
      return newValue.copyWith(
        text: '${text.substring(0, 2)}/${text.substring(2)}',
        selection: TextSelection.collapsed(
          offset:
              newValue.selection.end +
              (newValue.text.length - oldValue.text.length),
        ),
      );
    }
    return newValue;
  }
}
