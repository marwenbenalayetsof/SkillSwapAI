import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../core/theme/app_colors.dart';
import '../../repositories/firestore_repository.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late Animation<double> _logoScale;
  late Animation<double> _textFade;

  @override
  void initState() {
    super.initState();
    _logoController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _textController = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _logoScale = Tween<double>(begin: 0.5, end: 1.0).animate(CurvedAnimation(parent: _logoController, curve: Curves.elasticOut));
    _textFade = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _logoController.forward().then((_) => _textController.forward());

    _navigate();
  }

  Future<void> _navigate() async {
    // Check Firestore availability in background
    FirestoreRepository().checkAvailability();

    // Wait for splash animation
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    // Check if user is already signed in
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      context.go('/home');
    } else {
      context.go('/login');
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _logoScale,
              child: Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: AppColors.primaryGradient,
                  boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 30, offset: const Offset(0, 10))],
                ),
                child: const Center(child: Icon(Icons.bolt, color: Colors.white, size: 40)),
              ),
            ),
            const SizedBox(height: 24),
            FadeTransition(
              opacity: _textFade,
              child: Column(children: [
                ShaderMask(shaderCallback: (b) => AppColors.primaryGradient.createShader(b),
                  child: const Text('SkillSwapAI', style: TextStyle(fontSize: 32, fontWeight: FontWeight.w800, color: Colors.white))),
                const SizedBox(height: 8),
                const Text('Global Time-Banking for the AI Era', style: TextStyle(color: AppColors.textSecondary, fontSize: 14)),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}
