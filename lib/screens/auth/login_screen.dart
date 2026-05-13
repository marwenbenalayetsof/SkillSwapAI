import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_colors.dart';
import '../../repositories/auth_repository.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});
  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> with TickerProviderStateMixin {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;
  late AnimationController _fadeCtrl;
  late Animation<double> _fade;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeIn);
    _fadeCtrl.forward();
  }

  @override
  void dispose() { _fadeCtrl.dispose(); _emailCtrl.dispose(); _passCtrl.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() { _isLoading = true; _error = null; });
    try {
      final repo = ref.read(authRepositoryProvider);
      await repo.signIn(email: _emailCtrl.text.trim(), password: _passCtrl.text);
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      setState(() { _error = _errorMsg(e.code); });
    } catch (e) {
      setState(() { _error = 'Login failed. Please try again.'; });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _errorMsg(String code) {
    switch (code) {
      case 'user-not-found': return 'No account found with this email.';
      case 'wrong-password': return 'Incorrect password.';
      case 'invalid-credential': return 'Invalid credentials. Check email and password.';
      case 'too-many-requests': return 'Too many attempts. Try again later.';
      default: return 'Login failed. Please try again.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: FadeTransition(opacity: _fade, child: Center(
        child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Form(key: _formKey, child: Column(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Center(child: Container(width: 72, height: 72,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(18), gradient: AppColors.primaryGradient,
                boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.3), blurRadius: 20, offset: const Offset(0, 8))]),
              child: const Center(child: Icon(Icons.bolt, color: Colors.white, size: 36)))),
            const SizedBox(height: 28),
            Center(child: ShaderMask(shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
              child: const Text('Welcome Back', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)))),
            const SizedBox(height: 6),
            Center(child: Text('Sign in to continue swapping skills', style: TextStyle(color: AppColors.textSecondary, fontSize: 14))),
            const SizedBox(height: 36),
            if (_error != null) ...[
              Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.error.withValues(alpha: 0.3))),
                child: Row(children: [const Icon(Icons.error_outline, color: AppColors.error, size: 18), const SizedBox(width: 8),
                  Expanded(child: Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 13)))])),
              const SizedBox(height: 16)],
            _inputField('Email', _emailCtrl, Icons.email_outlined, TextInputType.emailAddress),
            const SizedBox(height: 16),
            _inputField('Password', _passCtrl, Icons.lock_outline, null, obscure: true),
            const SizedBox(height: 28),
            SizedBox(width: double.infinity, height: 52,
              child: ElevatedButton(onPressed: _isLoading ? null : _login,
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
                child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : const Text('Sign In', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)))),
            const SizedBox(height: 20),
            Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text("Don't have an account? ", style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              GestureDetector(onTap: () => context.go('/register'),
                child: const Text('Sign Up', style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w600)))])),
          ])),
        ),
      ))),
    );
  }

  Widget _inputField(String label, TextEditingController ctrl, IconData icon, TextInputType? kb, {bool obscure = false}) {
    return TextFormField(controller: ctrl, obscureText: obscure, keyboardType: kb,
      style: const TextStyle(fontSize: 14), validator: (v) => v == null || v.isEmpty ? '$label is required' : null,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20)));
  }
}
