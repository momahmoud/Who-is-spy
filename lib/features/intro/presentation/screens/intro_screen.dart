import 'package:salfah/features/intro/presentation/widgets/intro_widgets/index.dart'
    show IntroBody;
import 'package:flutter/material.dart';

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: IntroBody());
  }
}
