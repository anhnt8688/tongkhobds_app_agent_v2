import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/models/verification_models.dart';
import 'widgets/verification_widgets.dart';

/// Shown after an approval succeeds (mirrors v1 approve-success page).
class VerificationApproveSuccessScreen extends StatelessWidget {
  const VerificationApproveSuccessScreen({super.key, required this.realEstate});
  final VerificationRealEstateDetail realEstate;

  @override
  Widget build(BuildContext context) {
    final address = realEstate.streetAddress.isNotEmpty
        ? realEstate.streetAddress
        : 'Chưa có địa chỉ';
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
          child: Column(
            children: [
              const Spacer(),
              Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                    color: Color(0xFFD1FAE5), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded,
                    color: Color(0xFF16A34A), size: 84),
              ),
              const SizedBox(height: 20),
              Text('Phê duyệt xác thực BĐS thành công',
                  textAlign: TextAlign.center,
                  style: vText(20, FontWeight.w600, VColors.n800)),
              const SizedBox(height: 10),
              Text(
                realEstate.title.isNotEmpty ? realEstate.title : 'Bất động sản',
                textAlign: TextAlign.center,
                style: vText(16, FontWeight.w600, VColors.n700),
              ),
              const SizedBox(height: 6),
              Text(address,
                  textAlign: TextAlign.center,
                  style: vText(13, FontWeight.w400, VColors.n500)),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: () => context.push('/appointments/create'),
                  style: FilledButton.styleFrom(
                    backgroundColor: VColors.orange,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Tạo lịch hẹn',
                      style: vText(16, FontWeight.w600, Colors.white)),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: OutlinedButton(
                  onPressed: () => context.go('/real-estate-verification'),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: VColors.n300),
                    foregroundColor: VColors.n700,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  child: Text('Quay lại danh sách',
                      style: vText(16, FontWeight.w600, VColors.n700)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
