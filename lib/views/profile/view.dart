import 'package:documind/views/profile/logic.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());
    const Color activeBlue = Color(0xFF1D4ED8);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // 1. User Info Header Row (Avatar, Name, Email)
              Row(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFDBEAFE), // Light blue avatar bg
                    ),
                    child: const Icon(
                      Icons.person,
                      color: Color(0xFF1E40AF),
                      size: 42,
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(() => Text(
                              controller.userName.value,
                              style: GoogleFonts.poppins(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF0F172A),
                              ),
                            )),
                        const SizedBox(height: 3),
                        Obx(() => Text(
                              controller.userEmail.value,
                              style: GoogleFonts.poppins(
                                fontSize: 14,
                                color: Colors.grey.shade500,
                                fontWeight: FontWeight.w400,
                              ),
                            )),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 2. Profile Options White Menu Container Card Box
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.01),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    _buildMenuOption(
                      Icons.person_outline,
                      "My Profile",
                      hasTrailingArrow: true,
                      onTap: () {},
                    ),
                    _buildDivider(),
                    
                    // Notifications Row with iOS Switch Toggle Button
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                      child: Row(
                        children: [
                          Icon(Icons.notifications_none, color: const Color(0xFF1E3A8A), size: 24),
                          const SizedBox(width: 16),
                          Text(
                            "Notifications",
                            style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF334155),
                            ),
                          ),
                          const Spacer(),
                          Obx(() => CupertinoSwitch(
                                value: controller.isNotificationEnabled.value,
                                activeColor: activeBlue,
                                onChanged: (value) {
                                  controller.isNotificationEnabled.value = value;
                                },
                              )),
                        ],
                      ),
                    ),
                    _buildDivider(),
                    
                    _buildMenuOption(
                      Icons.security_outlined,
                      "Security",
                      hasTrailingArrow: true,
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildMenuOption(
                      Icons.timelapse_outlined,
                      "Appearance",
                      trailingText: "Light",
                      hasTrailingArrow: true,
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildMenuOption(
                      Icons.help_outline,
                      "Help & Support",
                      hasTrailingArrow: true,
                      onTap: () {},
                    ),
                    _buildDivider(),
                    _buildMenuOption(
                      Icons.info_outline,
                      "About App",
                      hasTrailingArrow: true,
                      onTap: () => _showAboutAppDialog(context),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 35),

              // 3. Log Out Action Button Container Box Layout
              SizedBox(
                width: double.infinity,
                height: 58,
                child: ElevatedButton.icon(
                  onPressed: () => controller.logOutUser(),
                  icon: const Icon(Icons.logout, color: Colors.redAccent, size: 20),
                  label: Text(
                    "Log Out",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFEF2F2), // Light soft red bg matching image
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuOption(IconData icon, String label, {String? trailingText, bool hasTrailingArrow = false, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            Icon(icon, color: const Color(0xFF1E3A8A), size: 24),
            const SizedBox(width: 16),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF334155),
              ),
            ),
            const Spacer(),
            if (trailingText != null)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  trailingText,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade400,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            if (hasTrailingArrow)
              Icon(Icons.arrow_forward_ios, color: Colors.grey.shade400, size: 14),
          ],
        ),
      ),
    );
  }

  void _showAboutAppDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFF1D4ED8), size: 26),
            const SizedBox(width: 10),
            Text(
              "About DocuMind",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "DocuMind is an advanced, next-generation AI-powered document management system designed to make file organization, analytics, and summary generation frictionless.",
              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700, height: 1.5),
            ),
            const SizedBox(height: 15),
            Text(
              "Key Features:",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF0F172A)),
            ),
            const SizedBox(height: 6),
            _buildFeatureBullet("📁 Intelligent Folder Management"),
            _buildFeatureBullet("📑 Realtime Firebase synchronization"),
            _buildFeatureBullet("🧠 Instant AI-powered Summary generation"),
            _buildFeatureBullet("📊 Detailed graphical Document Analytics"),
            _buildFeatureBullet("🔒 Secure cloud infrastructure & sharing controls"),
            const SizedBox(height: 20),
            Center(
              child: Text(
                "Version 1.0.0",
                style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade400, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              "Close",
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: const Color(0xFF1D4ED8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureBullet(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey.shade600),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: Colors.grey.shade100,
      indent: 20,
      endIndent: 20,
    );
  }
}
