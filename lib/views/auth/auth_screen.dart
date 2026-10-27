import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../providers/auth_provider.dart';
import '../widgets/custom_toast.dart';

// Tela de autenticação (Login e Cadastro) com design retro-futurista
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();
  bool _isSignUp = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildBrandHeader(),
                  const SizedBox(height: 32),
                  _buildFormCard(),
                  const SizedBox(height: 20),
                  _buildToggleButton(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Cabeçalho da marca Discotheque com ícone neon
  Widget _buildBrandHeader() {
    return Column(
      children: [
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceContainer,
            border: Border.all(color: Colors.white12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x55FF4A8D),
                blurRadius: 18,
                spreadRadius: 2,
              ),
            ],
          ),
          child: const Icon(Icons.graphic_eq, color: AppColors.primary, size: 36),
        ),
        const SizedBox(height: 12),
        Text(
          'Discotheque',
          style: AppTextStyles.headlineXl.copyWith(color: AppColors.primary),
        ),
        Text(
          'VINYL & SOCIAL CLUB',
          style: AppTextStyles.labelCaps.copyWith(color: AppColors.onSurfaceVariant),
        ),
      ],
    );
  }

  // Card do formulário com campos de texto e botão de ação
  Widget _buildFormCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isSignUp) ...[
            _buildNameField(),
            const SizedBox(height: 16),
          ],
          _buildEmailField(),
          const SizedBox(height: 16),
          _buildPasswordField(),
          const SizedBox(height: 24),
          _buildSubmitButton(),
        ],
      ),
    );
  }

  // Campo de nome do usuário
  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Nome do Curador',
        prefixIcon: Icon(Icons.person_outline, color: AppColors.outline),
      ),
      validator: (v) => (v == null || v.trim().isEmpty) ? 'Informe seu nome' : null,
    );
  }

  // Campo de e-mail
  Widget _buildEmailField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'E-mail',
        prefixIcon: Icon(Icons.mail_outline, color: AppColors.outline),
      ),
      validator: (v) {
        if (v == null || !v.contains('@')) return 'Informe um e-mail válido';
        return null;
      },
    );
  }

  // Campo de senha
  Widget _buildPasswordField() {
    return TextFormField(
      controller: _passwordController,
      obscureText: true,
      style: AppTextStyles.bodyMd.copyWith(color: Colors.white),
      decoration: const InputDecoration(
        labelText: 'Senha',
        prefixIcon: Icon(Icons.lock_outline, color: AppColors.outline),
      ),
      validator: (v) {
        if (v == null || v.length < 6) return 'Mínimo de 6 caracteres';
        return null;
      },
    );
  }

  // Botão principal de submissão com gradiente neon
  Widget _buildSubmitButton() {
    final auth = context.watch<AuthProvider>();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: const [
          BoxShadow(
            color: Color(0x66FF4A8D),
            blurRadius: 16,
            spreadRadius: 1,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: auth.isLoading ? null : _handleAuthSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryContainer,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        child: auth.isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Text(
                _isSignUp ? 'Criar Conta' : 'Entrar no Clube',
                style: AppTextStyles.labelLg.copyWith(color: Colors.white),
              ),
      ),
    );
  }

  // Alterna entre modo de login e modo de criação de conta
  Widget _buildToggleButton() {
    return TextButton(
      onPressed: () => setState(() => _isSignUp = !_isSignUp),
      child: Text(
        _isSignUp ? 'Já tem uma conta? Entre aqui' : 'Novo por aqui? Criar conta',
        style: AppTextStyles.bodySm.copyWith(color: AppColors.tertiary),
      ),
    );
  }

  // Executa o envio do formulário chamando o AuthProvider
  Future<void> _handleAuthSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = context.read<AuthProvider>();
    final email = _emailController.text;
    final password = _passwordController.text;

    final success = _isSignUp
        ? await auth.signUp(email, password, _nameController.text)
        : await auth.signIn(email, password);

    if (!mounted) return;
    if (success) {
      CustomToast.showSuccess(context, 'Bem-vindo ao Discotheque!');
    } else if (auth.errorMessage != null) {
      CustomToast.showError(context, auth.errorMessage!);
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }
}

