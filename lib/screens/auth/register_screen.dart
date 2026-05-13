import 'package:flutter/material.dart';
import '../../providers/user_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/user_provider.dart';
import 'package:go_router/go_router.dart';
import '../../providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../providers/user_provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/user_provider.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/user_provider.dart';
import '../../models/user_model.dart';
import '../../providers/user_provider.dart';
import '../../repositories/auth_repository.dart';
import '../../providers/user_provider.dart';
import '../../repositories/firestore_repository.dart';
import '../../providers/user_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/user_provider.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});
  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _error;
  final List<String> _skillsOffered = [];
  final List<String> _skillsWanted = [];
  final _skillOfferCtrl = TextEditingController();
  final _skillWantCtrl = TextEditingController();

  void _addSkill(List<String> list, TextEditingController ctrl) {
    final s = ctrl.text.trim();
    if (s.isNotEmpty && !list.contains(s) && list.length < AppConstants.maxSkillsPerUser) {
      setState(() => list.add(s));
      ctrl.clear();
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    if (_skillsOffered.isEmpty) { setState(() => _error = 'Add at least one skill you offer.'); return; }
    if (_skillsWanted.isEmpty) { setState(() => _error = 'Add at least one skill you want.'); return; }
    setState(() { _isLoading = true; _error = null; });
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final cred = await authRepo.signUp(email: _emailCtrl.text.trim(), password: _passCtrl.text);
      final user = UserModel(uid: cred.user!.uid, name: _nameCtrl.text.trim(), email: _emailCtrl.text.trim(),
        skillsOffered: _skillsOffered, skillsWanted: _skillsWanted, timeCredits: AppConstants.defaultTimeCredits,
        badges: ['early_adopter'], createdAt: DateTime.now());
      try { await ref.read(firestoreRepositoryProvider).createUser(user); } catch (_) {}
      if (mounted) context.go('/home');
    } on FirebaseAuthException catch (e) {
      setState(() { _error = _errorMsg(e.code); });
    } catch (e) {
      setState(() { _error = 'Registration failed: $e'; });
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String _errorMsg(String code) {
    switch (code) {
      case 'email-already-in-use': return 'This email is already registered.';
      case 'weak-password': return 'Password is too weak. Use at least 6 characters.';
      case 'invalid-email': return 'Invalid email address.';
      default: return 'Registration failed. Please try again.';
    }
  }

  @override
  void dispose() { _nameCtrl.dispose(); _emailCtrl.dispose(); _passCtrl.dispose(); _skillOfferCtrl.dispose(); _skillWantCtrl.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(child: Center(child: SingleChildScrollView(padding: const EdgeInsets.symmetric(horizontal: 28),
        child: Form(key: _formKey, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          IconButton(onPressed: () => context.go('/login'), icon: Icon(Icons.arrow_back, color: AppColors.textSecondary), padding: EdgeInsets.zero, alignment: Alignment.centerLeft),
          const SizedBox(height: 10),
          Center(child: ShaderMask(shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
            child: const Text('Create Account', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800, color: Colors.white)))),
          const SizedBox(height: 6),
          Center(child: Text('Join the skill-swapping community', style: TextStyle(color: AppColors.textSecondary, fontSize: 14))),
          const SizedBox(height: 28),
          if (_error != null) ...[
            Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: AppColors.error.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.error.withValues(alpha: 0.3))),
              child: Row(children: [const Icon(Icons.error_outline, color: AppColors.error, size: 18), const SizedBox(width: 8),
                Expanded(child: Text(_error!, style: const TextStyle(color: AppColors.error, fontSize: 13)))])),
            const SizedBox(height: 16)],
          _field('Full Name', _nameCtrl, Icons.person_outline),
          const SizedBox(height: 14),
          _field('Email', _emailCtrl, Icons.email_outlined, kb: TextInputType.emailAddress),
          const SizedBox(height: 14),
          _field('Password', _passCtrl, Icons.lock_outline, obscure: true),
          const SizedBox(height: 20),
          _skillSection('Skills You Offer', _skillsOffered, _skillOfferCtrl, AppColors.primary),
          const SizedBox(height: 16),
          _skillSection('Skills You Want', _skillsWanted, _skillWantCtrl, AppColors.purple),
          const SizedBox(height: 28),
          SizedBox(width: double.infinity, height: 52,
            child: ElevatedButton(onPressed: _isLoading ? null : _register,
              style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)), elevation: 0),
              child: _isLoading ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Row(mainAxisAlignment: MainAxisAlignment.center, children: [Icon(Icons.person_add, size: 20), SizedBox(width: 8), Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600))]))),
          const SizedBox(height: 20),
          Center(child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Already have an account? ', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
            GestureDetector(onTap: () => context.go('/login'),
              child: const Text('Sign In', style: TextStyle(color: AppColors.primary, fontSize: 14, fontWeight: FontWeight.w600)))])),
          const SizedBox(height: 20),
        ])),
      ))),
    );
  }

  Widget _field(String label, TextEditingController ctrl, IconData icon, {bool obscure = false, TextInputType? kb}) {
    return TextFormField(controller: ctrl, obscureText: obscure, keyboardType: kb, style: const TextStyle(fontSize: 14),
      validator: (v) => v == null || v.isEmpty ? '$label is required' : null,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon, size: 20)));
  }

  Widget _skillSection(String title, List<String> skills, TextEditingController ctrl, Color color) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: TextStyle(color: color, fontSize: 15, fontWeight: FontWeight.w600)),
      const SizedBox(height: 8),
      Row(children: [
        Expanded(child: TextFormField(controller: ctrl, style: const TextStyle(fontSize: 14),
          decoration: InputDecoration(hintText: 'e.g., Python, UI Design', prefixIcon: Icon(Icons.add_circle_outline, color: color, size: 20)),
          onFieldSubmitted: (_) => _addSkill(skills, ctrl))),
        const SizedBox(width: 8),
        IconButton(onPressed: () => _addSkill(skills, ctrl),
          icon: Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(10)),
            child: Icon(Icons.add, color: color, size: 20))),
      ]),
      const SizedBox(height: 8),
      Wrap(spacing: 8, runSpacing: 8, children: skills.map((s) => Chip(label: Text(s, style: TextStyle(color: color, fontSize: 12)),
        backgroundColor: color.withValues(alpha: 0.1), side: BorderSide(color: color.withValues(alpha: 0.3)),
        deleteIconColor: color, onDeleted: () => setState(() => skills.remove(s)))).toList()),
    ]);
  }
}
