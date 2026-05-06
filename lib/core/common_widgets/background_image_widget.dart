import 'package:salfah/core/assets/app_images.dart';
import 'package:flutter/material.dart';

class BackgroundImageWidget extends StatelessWidget {
  const BackgroundImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(AppImages.backgroundImage, fit: BoxFit.cover),
    );
  }
}
