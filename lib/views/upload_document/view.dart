import 'package:dotted_border/dotted_border.dart';
import 'package:documind/views/upload_document/logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class UploadDocumentPage extends StatelessWidget {
  const UploadDocumentPage({super.key});

  @override
  Widget build(BuildContext context) {
    final UploadDocumentController controller = Get.put(UploadDocumentController());
    const Color indigoTheme = Color(0xFF3F51B5);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Upload Document',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: false,
      ),
      body: Obx(() => Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),
                    // Upload Area
                    GestureDetector(
                      onTap: () => controller.pickFile(),
                      child: DottedBorder(
                        options: RoundedRectDottedBorderOptions(
                          color: indigoTheme.withValues(alpha: 0.5),
                          strokeWidth: 1.5,
                          dashPattern: const [8, 4],
                          radius: const Radius.circular(16),
                        ),
                        child: Container(
                          width: double.infinity,
                          height: 150,
                          decoration: BoxDecoration(
                            color: indigoTheme.withValues(alpha: 0.02),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud_upload_outlined, color: indigoTheme, size: 40),
                              const SizedBox(height: 10),
                              Obx(() => Text(
                                    controller.selectedFileName.value.isEmpty
                                        ? 'Tap to upload or browse'
                                        : controller.selectedFileName.value,
                                    style: GoogleFonts.poppins(
                                      color: indigoTheme,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  )),
                              const SizedBox(height: 5),
                              Text(
                                'Supports PDF, DOCX, TXT, XLS, PPT etc.',
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 25),
                    
                    _buildLabel("Document Title"),
                    _buildTextField(controller.titleController, "Enter document title"),
                    
                    const SizedBox(height: 20),
                    _buildLabel("Description (optional)"),
                    _buildTextField(controller.descriptionController, "Add a short description...", maxLines: 3),
                    
                    const SizedBox(height: 20),
                    _buildLabel("Select Folder"),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedFolder.value == "Select folder" ? null : controller.selectedFolder.value,
                          hint: Text("Select folder", style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey)),
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: <String>['Work', 'Personal', 'Study', 'Finance']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value, style: GoogleFonts.poppins(fontSize: 14)),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            controller.selectedFolder.value = newValue!;
                          },
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    _buildLabel("Tags (optional)"),
                    _buildTextField(controller.tagController, "Add tags..."),
                    
                    const SizedBox(height: 15),
                    Wrap(
                      spacing: 10,
                      children: [
                        ...controller.tags.map((tag) => _buildTagChip(tag)),
                        GestureDetector(
                          onTap: () {
                            if (controller.tagController.text.isNotEmpty) {
                              controller.addTag(controller.tagController.text.trim());
                              controller.tagController.clear();
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.add, size: 20, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Upload Button
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () => controller.uploadDocument(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: indigoTheme,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Upload',
                          style: GoogleFonts.poppins(
                            fontSize: 18,
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
              if (controller.isUploading.value)
                const Center(child: CircularProgressIndicator(color: indigoTheme)),
            ],
          )),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: GoogleFonts.poppins(fontSize: 14),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
        filled: true,
        fillColor: Colors.grey.shade50,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFF3F51B5), width: 1.5),
        ),
      ),
    );
  }

  Widget _buildTagChip(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EAF6),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 13,
          color: const Color(0xFF3F51B5),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
