import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:documind/views/ai_agent/view.dart';
import 'package:documind/views/documents/share_document_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DocumentDetailsScreen extends StatelessWidget {
  final String title;
  final String fileName;
  final Map<String, dynamic> data;

  const DocumentDetailsScreen({
    super.key,
    required this.title,
    required this.fileName,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    const Color activeBlue = Color(0xFF1D4ED8);
    const Color bgSummaryBox = Color(0xFFEFF6FF);

    final tags = data['tags'] != null ? List<String>.from(data['tags']) : <String>[];
    final description = data['description'] ?? 'No description provided for this document.';
    final createdAt = data['createdAt'] as Timestamp?;
    
    // Calculate extension and details
    String ext = fileName.split('.').last.toUpperCase();
    if (ext.isEmpty || !fileName.contains('.')) ext = "PDF";

    String uploadedAtStr = "Just now";
    if (createdAt != null) {
      final date = createdAt.toDate();
      // Simple date formatting matching image style Apr 25, 2025 • 2:14 PM
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      String period = date.hour >= 12 ? 'PM' : 'AM';
      int hour = date.hour > 12 ? date.hour - 12 : (date.hour == 0 ? 12 : date.hour);
      String minute = date.minute.toString().padLeft(2, '0');
      uploadedAtStr = "${months[date.month - 1]} ${date.day}, ${date.year} • $hour:$minute $period";
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.black87),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // 1. Large Top File Icon and Title Row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildBigFileIcon(fileName),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                style: GoogleFonts.poppins(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(height: 10),
                              // Tags Row
                              if (tags.isNotEmpty)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children: tags.map((tag) => _buildOutlineTag(tag)).toList(),
                                )
                              else
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    _buildOutlineTag("Document"),
                                    _buildOutlineTag("File"),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 35),

                    // 2. Metadata Rows (File Type, Size, Uploaded By, Uploaded At)
                    _buildMetadataRow(Icons.description_outlined, "File Type", ext),
                    _buildMetadataRow(Icons.insert_drive_file_outlined, "Size", "2.4 MB"), // Mocked size matching requirement
                    _buildMetadataRow(Icons.person_outline, "Uploaded By", "You"),
                    _buildMetadataRow(Icons.calendar_today_outlined, "Uploaded At", uploadedAtStr),
                    
                    const SizedBox(height: 30),

                    // 3. Beautiful AI Summary Box Container
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: bgSummaryBox,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.psychology, color: activeBlue, size: 24),
                              const SizedBox(width: 10),
                              Text(
                                "AI Summary",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: const Color(0xFF1E3A8A),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Text(
                            description.isNotEmpty ? description : "This document contains relevant user notes, uploaded metadata, and system details parsed smoothly with the power of AI analysis infrastructure setup.",
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              color: const Color(0xFF3B82F6).withValues(alpha: 0.9),
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 20),
                          // View Full Summary Button inside box
                          SizedBox(
                            width: double.infinity,
                            height: 48,
                            child: OutlinedButton(
                              onPressed: () {},
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Color(0xFFBFDBFE), width: 1.2),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                backgroundColor: Colors.white,
                              ),
                              child: Text(
                                "View Full Summary",
                                style: GoogleFonts.poppins(
                                  color: activeBlue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // 4. Bottom Actions Control Panel (Share, Ask AI, More)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(child: _buildActionButton(context, Icons.share_outlined, "Share")),
                  const SizedBox(width: 12),
                  Expanded(child: _buildActionButton(context, Icons.lightbulb_outline, "Ask AI")),
                  const SizedBox(width: 12),
                  Expanded(child: _buildActionButton(context, Icons.tune_outlined, "More")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOutlineTag(String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBFDBFE), width: 1.2),
      ),
      child: Text(
        label,
        style: GoogleFonts.poppins(
          fontSize: 12,
          color: const Color(0xFF2563EB),
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildMetadataRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade500, size: 22),
          const SizedBox(width: 14),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(BuildContext context, IconData icon, String label) {
    return GestureDetector(
      onTap: () {
        if (label == "Share") {
          Get.to(() => ShareDocumentScreen(title: title, fileName: fileName));
        } else if (label == "Ask AI") {
          Get.to(() => AIAgentScreen(documentTitle: title));
        }
      },
      child: Container(
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade100),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.015),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: const Color(0xFF1E3A8A), size: 22),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBigFileIcon(String fileName) {
    String ext = fileName.split('.').last.toLowerCase();
    IconData iconData = Icons.description;
    Color iconColor = Colors.red;
    Color bgColor = const Color(0xFFFFEBEE);

    if (ext == 'pdf') {
      iconData = Icons.picture_as_pdf;
      iconColor = const Color(0xFFE53935);
      bgColor = const Color(0xFFFFEBEE);
    } else if (ext == 'docx' || ext == 'doc') {
      iconData = Icons.article;
      iconColor = const Color(0xFF1E88E5);
      bgColor = const Color(0xFFE3F2FD);
    } else if (ext == 'xls' || ext == 'xlsx') {
      iconData = Icons.table_view;
      iconColor = const Color(0xFF43A047);
      bgColor = const Color(0xFFE8F5E9);
    }

    return Container(
      width: 60,
      height: 65,
      decoration: BoxDecoration(
        color: iconColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Center(
        child: Icon(
          Icons.picture_as_pdf, // Display style pdf matching image layout
          color: Colors.white,
          size: 32,
        ),
      ),
    );
  }
}
