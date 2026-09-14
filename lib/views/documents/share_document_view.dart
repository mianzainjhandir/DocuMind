import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ShareDocumentScreen extends StatefulWidget {
  final String title;
  final String fileName;

  const ShareDocumentScreen({
    super.key,
    required this.title,
    required this.fileName,
  });

  @override
  State<ShareDocumentScreen> createState() => _ShareDocumentScreenState();
}

class _ShareDocumentScreenState extends State<ShareDocumentScreen> {
  String shareType = "People"; // Default active share type mode selector
  String selectedPermission = "View Only";

  final List<String> permissions = ["View Only", "Can Edit", "Full Access"];
  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const Color activeBlue = Color(0xFF1D4ED8);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Share Document',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 15),
              // 1. Top File Identity Rounded Box Banner Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.shade100),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.015),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 50,
                      height: 55,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE53935),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Icon(Icons.picture_as_pdf, color: Colors.white, size: 26),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "2.4 MB",
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),

              // 2. "Share with" Section Header and Toggle Buttons Row
              _buildSectionLabel("Share with"),
              Row(
                children: [
                  Expanded(
                    child: _buildShareTypeButton(
                      label: "People",
                      icon: Icons.person_add_alt_1_outlined,
                      isActive: shareType == "People",
                    ),
                  ),
                  const SizedBox(width: 15),
                  Expanded(
                    child: _buildShareTypeButton(
                      label: "Link",
                      icon: Icons.link_outlined,
                      isActive: shareType == "Link",
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // 3. Email input form block
              _buildSectionLabel("Enter email or user name"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: TextField(
                  controller: emailController,
                  style: GoogleFonts.poppins(fontSize: 14),
                  decoration: InputDecoration(
                    hintText: 'example@domain.com',
                    hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                ),
              ),
              const SizedBox(height: 25),

              // 4. Access Permission dropdown selectors row
              _buildSectionLabel("Access Permission"),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: selectedPermission,
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade600),
                    items: permissions.map((String val) {
                      return DropdownMenuItem<String>(
                        value: val,
                        child: Text(
                          val,
                          style: GoogleFonts.poppins(fontSize: 14, color: const Color(0xFF334155)),
                        ),
                      );
                    }).toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => selectedPermission = value);
                      }
                    },
                  ),
                ),
              ),
              const Spacer(),

              // 5. Grand Blue Bottom Share Action Button
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: () {
                    Get.back();
                    Get.snackbar(
                      "Success", 
                      "Document shared successfully with $selectedPermission permission!",
                      backgroundColor: Colors.green,
                      colorText: Colors.white,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    "Share",
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: const Color(0xFF0F172A),
        ),
      ),
    );
  }

  Widget _buildShareTypeButton({required String label, required IconData icon, required bool isActive}) {
    const Color activeBlue = Color(0xFF1D4ED8);
    return GestureDetector(
      onTap: () => setState(() => shareType = label),
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isActive ? activeBlue : Colors.grey.shade200,
            width: isActive ? 1.5 : 1.0,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: isActive ? activeBlue : Colors.grey.shade600, size: 20),
            const SizedBox(width: 10),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isActive ? activeBlue : Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
