import 'package:salfah/core/common_widgets/dialogs/custom_dialog.dart';
import 'package:salfah/core/common_widgets/dialogs/custom_dialog_action.dart';
import 'package:flutter/material.dart';
import 'package:salfah/config/theme/app_colors.dart';

/// Helper for common dialogs with RTL support.
class CustomDialogHelper {
  CustomDialogHelper._();

  /// Success dialog.
  static Future<void> showSuccessDialog(
    BuildContext context, {
    required String title,
    required String message,
    String okLabel = 'موافق',
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        icon: Icons.check_circle_rounded,
        iconColor: AppColors.color2, // Teal success
        title: title,
        content: _buildText(message),
        actions: <Widget>[
          CustomDialogAction(
            label: okLabel,
            isPrimary: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// Error dialog.
  static Future<void> showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    String okLabel = 'موافق',
  }) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        icon: Icons.error_rounded,
        iconColor: AppColors.color3, // Coral error
        title: title,
        content: _buildText(message),
        actions: <Widget>[
          CustomDialogAction(
            label: okLabel,
            isPrimary: true,
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  /// Confirmation dialog.
  static Future<bool> showConfirmationDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'تأكيد',
    String cancelLabel = 'إلغاء',
  }) async {
    final bool? result = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => CustomDialog(
        icon: Icons.help_outline_rounded,
        iconColor: AppColors.color1, // Gold confirm
        title: title,
        content: _buildText(message),
        actions: <Widget>[
          CustomDialogAction(
            label: cancelLabel,
            onPressed: () => Navigator.of(context).pop(false),
          ),
          CustomDialogAction(
            label: confirmLabel,
            isPrimary: true,
            onPressed: () => Navigator.of(context).pop(true),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  /// Build mixed RTL/LTR text (Arabic + numbers).
  static Widget createMixedText(String text) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: AppColors.primaryWhite,
          height: 1.5,
        ),
      ),
    );
  }

  /// Format price with locale.
  static String formatPrice(String price) {
    return price;
  }

  static Widget _buildText(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: createMixedText(message),
    );
  }
}
