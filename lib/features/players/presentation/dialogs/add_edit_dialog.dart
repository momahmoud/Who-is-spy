import 'dart:ui';
import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/common_widgets/animated_submit_button.dart';
import 'package:salfah/core/extensions/color_extension.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:salfah/features/players/presentation/controller/players_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddEditDialog extends StatefulWidget {
  const AddEditDialog({super.key});

  @override
  State<AddEditDialog> createState() => _AddEditDialogState();
}

class _AddEditDialogState extends State<AddEditDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  final PlayersController controller = Get.find<PlayersController>();

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _scaleAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutBack,
    );

    _fadeAnimation = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeIn,
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isAdd = controller.isAdd;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: Get.back<void>,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
              child: Container(color: Colors.black.withValueOpacity(0.4)),
            ),
          ),

          Center(
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 30),
                  padding: const EdgeInsets.all(25),
                  decoration: BoxDecoration(
                    color: AppColors.primary2.withValueOpacity(0.98),
                    borderRadius: BorderRadius.circular(25),
                    border: Border.all(
                      color: Colors.white.withValueOpacity(0.3),
                      width: 2,
                    ),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Colors.black.withValueOpacity(0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            isAdd
                                ? Icons.person_add_rounded
                                : Icons.edit_note_rounded,
                            color: AppColors.color1,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          ShaderMask(
                            shaderCallback: (Rect bounds) =>
                                const LinearGradient(
                                  colors: <Color>[
                                    AppColors.color1,
                                    AppColors.color2,
                                  ],
                                ).createShader(bounds),
                            child: Text(
                              isAdd
                                  ? context.localization.addNewPlayer
                                  : context.localization.editPlayerName,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Input Field
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.black.withValueOpacity(0.3),
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(
                            color: Colors.white.withValueOpacity(0.15),
                            width: 1.5,
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                              color: Colors.black.withValueOpacity(0.2),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: controller.nameController,
                          autofocus: true,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                          decoration: InputDecoration(
                            hintText: context.localization.enterNamePlaceholder,
                            hintStyle: TextStyle(
                              color: Colors.white.withValueOpacity(0.4),
                              fontWeight: FontWeight.w500,
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 18,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),

                      AnimatedSubmitButton(
                        text: isAdd
                            ? context.localization.addAction
                            : context.localization.editAction,
                        onTap: controller.addOrEditPlayer,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
