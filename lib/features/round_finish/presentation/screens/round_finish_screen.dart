import 'package:salfah/features/round_finish/presentation/controller/round_finish_controller.dart';
import 'package:salfah/features/round_finish/presentation/widgets/round_finish_widgets/index.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RoundFinishScreen extends StatelessWidget {
  const RoundFinishScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RoundFinishController>(
      builder: (RoundFinishController controller) {
        return Scaffold(body: RoundFinishBody(controller: controller));
      },
    );
  }
}
