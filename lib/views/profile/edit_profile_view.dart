import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:documind/views/profile/logic.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _ShareBase64ImageUtility {
  // In a metadata-only storage design, picker returns file details. 
  // We mock a local base64/placeholder asset string profile avatar data.
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final ProfileController controller = Get.find<ProfileController>();
  final TextEditingController nameController = TextEditingController();
  
  bool isSaving = false;

  @override
  void initState() {
    super.initState();
    nameController.text = controller.userName.value;
  }

  Future<void> _pickProfileImage() async {
    // Pick real image from Mobile Gallery using the project's file_picker package.
    // To ensure full 100% free operation without utilizing paid Firebase Storage buckets,
    // we save the local file path dynamically to Firestore metadata document.
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
      );

      if (result != null && result.files.single.path != null) {
        String galleryImagePath = result.files.single.path!;
        controller.updateProfileImageString(galleryImagePath);
        
        Get.snackbar(
          "Success", 
          "Image selected successfully from Gallery!", 
          backgroundColor: Colors.green.shade50,
          colorText: Colors.green.shade800,
        );
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick image from gallery: $e");
    }
  }

  Future<void> _saveProfileChanges() async {
    String newName = nameController.text.trim();
    if (newName.isEmpty) {
      Get.snackbar("Warning", "Name cannot be empty", backgroundColor: Colors.orange, colorText: Colors.white);
      return;
    }

    setState(() => isSaving = true);
    
    // Save to Firestore completely free without using Firebase Storage paid bucket layers
    bool success = await controller.saveProfileToFirestore(newName);
    
    setState(() => isSaving = false);

    if (success) {
      Get.back();
      Get.snackbar("Success", "Profile updated successfully!", backgroundColor: Colors.green, colorText: Colors.white);
    }
  }

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
          'Edit Profile',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: isSaving
            ? const Center(child: CircularProgressIndicator(color: activeBlue))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    
                    // 1. Dynamic Editable Interactive Profile Avatar Icon Selector
                    Stack(
                      children: [
                        Obx(() {
                          String imgPath = controller.profileImageString.value;
                          
                          // Check if the path is a local file picked from gallery or an asset path
                          bool isLocalFile = imgPath.contains('/') && !imgPath.startsWith('assets/');
                          
                          return Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFDBEAFE),
                              border: Border.all(color: Colors.grey.shade200, width: 2),
                              image: DecorationImage(
                                image: isLocalFile 
                                    ? FileImage(File(imgPath)) as ImageProvider
                                    : AssetImage(imgPath),
                                fit: BoxFit.cover,
                              ),
                            ),
                          );
                        }),
                        Positioned(
                          bottom: 0,
                          right: 4,
                          child: GestureDetector(
                            onTap: _pickProfileImage,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: activeBlue,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.camera_alt, color: Colors.white, size: 18),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),

                    // 2. Full Name Input Form Field Layer
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Full Name",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        controller: nameController,
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // 3. Locked User Gmail Account Indicator Row
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Email Account (Locked)",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: Obx(() => Text(
                            controller.userEmail.value,
                            style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade500),
                          )),
                    ),
                    
                    const SizedBox(height: 50),

                    // 4. Grand Premium Update Save Button Layer
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: _saveProfileChanges,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: activeBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          "Save Changes",
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
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
}
