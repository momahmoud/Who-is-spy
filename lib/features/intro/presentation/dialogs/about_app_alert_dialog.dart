import 'package:salfah/config/theme/app_colors.dart';
import 'package:salfah/core/extensions/color_extension.dart';
import 'package:salfah/core/localization/localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AboutAppAlertDialog extends StatelessWidget {
  const AboutAppAlertDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 320.w,
          height: 550.h,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: <Color>[
                AppColors.primary2,
                AppColors.primary2.withValueOpacity(0.8),
              ],
            ),
            borderRadius: BorderRadius.circular(30.r),
            border: Border.all(
              width: 2,
              color: Colors.white.withValueOpacity(0.5),
            ),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black.withValueOpacity(0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Icon(Icons.info_outline, color: Colors.white, size: 40),
                  const SizedBox(height: 15),
                  Text(
                    context.localization.aboutTheGame,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Divider(color: Colors.white24, height: 30),
                ],
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Text(
                    context.localization.aboutGame,
                    style: TextStyle(color: Colors.white.withValueOpacity(0.8)),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),

              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.color2,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  context.localization.understood,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
