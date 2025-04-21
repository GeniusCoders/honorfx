import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/comman_appbar.dart';
import 'package:honorfx/screens/dashboard/dashboard_screens/dashboard_widgets/user_name.dart';
import 'package:honorfx/utils/colors.dart';
import 'package:honorfx/utils/comman_texfield.dart';
import 'package:honorfx/widgets/gradient_background.dart';

class VerifyIdentityScreen extends StatelessWidget {
  const VerifyIdentityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const CommanAppbar(),
                const SizedBox(height: 20),
                const UserName(),
                const SizedBox(height: 30),
                // Identity Verification UI
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Verify your identity',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'You name and address',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: const CommanTexfield(
                            hintText: 'Full Legal Name',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: const CommanTexfield(hintText: 'Address'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Proof of Address',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        _buildOptionButton('Bank statement', false),
                        const SizedBox(width: 10),
                        _buildOptionButton('Utility bill', true),
                        const SizedBox(width: 10),
                        _buildOptionButton('Insurance statement', false),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const CommanTexfield(hintText: 'ID Number'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _actionButton(
                            'Take a photo',
                            Colors.white,
                            Colors.black,
                            'gallery.svg',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _actionButton(
                            'Upload a document',
                            Colors.black,
                            Colors.white,
                            'upload.svg',
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'Proof of Identity',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildOptionButton('Passport', false),
                        const SizedBox(width: 10),
                        _buildOptionButton('Driver\'s License', true),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const CommanTexfield(hintText: 'ID Number'),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: _actionButton(
                            'Take a photo',
                            Colors.white,
                            Colors.black,
                            'gallery.svg',
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _actionButton(
                            'Upload a document',
                            Colors.black,
                            Colors.white,
                            'upload.svg',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildOptionButton(String title, bool isSelected) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.grey),
        ),
        child: Row(
          children: [
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_unchecked,
              color: isSelected ? const Color(0xFF9BC547) : Colors.black,
              size: 20,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionButton(String text, Color color, Color textColor, String icon) {
    return ElevatedButton.icon(
      onPressed: () {},
      icon: SvgPicture.asset('assets/icons/$icon', width: 20, height: 20),
      label: Text(text, style: TextStyle(color: textColor)),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
      ),
    );
  }
}
