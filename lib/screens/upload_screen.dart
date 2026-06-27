import 'package:flutter/material.dart';
import '../../app_theme.dart';

class UploadScreen extends StatelessWidget {
  const UploadScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text(
          "Subir Fotos",
          style: TextStyle(color: AppColors.textPrimary),
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [

            const SizedBox(height: 30),

            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.divider40,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Text(
                  "Subir Selfie",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Container(
              height: 180,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.divider40,
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Center(
                child: Text(
                  "Subir Foto Corporal",
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}