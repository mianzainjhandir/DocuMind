import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:documind/views/documents/document_details_view.dart';
import 'package:documind/views/documents/logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DocumentsTabScreen extends StatelessWidget {
  const DocumentsTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final DocumentsTabController controller = Get.put(DocumentsTabController());
    const Color indigoTheme = Color(0xFF1E3A8A); // Dark deep indigo/blue like image
    const Color activeBlue = Color(0xFF1D4ED8);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Documents',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 26,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black87, size: 26),
            onPressed: () {},
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Horizontal Document Types Selector (All, PDF, DOCX, XLS, PPT)
          const SizedBox(height: 10),
          SizedBox(
            height: 45,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: controller.documentTypes.length,
              itemBuilder: (context, index) {
                final type = controller.documentTypes[index];
                return Obx(() {
                  bool isSelected = controller.selectedType.value == type;
                  return Padding(
                    padding: const EdgeInsets.only(right: 12),
                    child: ChoiceChip(
                      label: Text(
                        type,
                        style: GoogleFonts.poppins(
                          color: isSelected ? Colors.white : Colors.grey.shade600,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                          fontSize: 14,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: activeBlue,
                      backgroundColor: Colors.grey.shade50,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(
                          color: isSelected ? activeBlue : Colors.grey.shade200,
                        ),
                      ),
                      showCheckmark: false,
                      onSelected: (bool selected) {
                        if (selected) {
                          controller.selectedType.value = type;
                        }
                      },
                    ),
                  );
                });
              },
            ),
          ),

          // 2. Search Field and Filter Icon Row
          const SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: TextField(
                      onChanged: (value) {
                        controller.searchQuery.value = value;
                      },
                      style: GoogleFonts.poppins(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: 'Search documents...',
                        hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
                        prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 22),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Icon(Icons.tune, color: Colors.grey.shade600, size: 22),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // 3. Realtime Documents Stream List
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: controller.getDocumentsStream(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator(color: activeBlue));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return _buildEmptyState();
                }

                return Obx(() {
                  // Apply type and search query filter locally
                  final filteredDocs = controller.filterDocuments(snapshot.data!.docs);

                  if (filteredDocs.isEmpty) {
                    return _buildEmptyState();
                  }

                  return ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    itemCount: filteredDocs.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    itemBuilder: (context, index) {
                      final doc = filteredDocs[index];
                      final data = doc.data() as Map<String, dynamic>;
                      
                      final title = data['title'] ?? 'Untitled Document';
                      final fileName = data['fileName'] ?? '';
                      final tags = data['tags'] != null ? List<String>.from(data['tags']) : [];
                      final createdAt = data['createdAt'] as Timestamp?;
                      
                      // Time format formatting
                      String timeAgo = "Just now";
                      if (createdAt != null) {
                        final date = createdAt.toDate();
                        final difference = DateTime.now().difference(date);
                        if (difference.inDays > 0) {
                          timeAgo = "${difference.inDays} days ago";
                        } else if (difference.inHours > 0) {
                          timeAgo = "${difference.inHours} hours ago";
                        } else if (difference.inMinutes > 0) {
                          timeAgo = "${difference.inMinutes} minutes ago";
                        }
                      }

                      return InkWell(
                        onTap: () => Get.to(() => DocumentDetailsScreen(
                              title: title,
                              fileName: fileName,
                              data: data,
                            )),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          child: Row(
                            children: [
                              // Document Type Color Coded Icon
                              _buildFileIcon(fileName),
                              const SizedBox(width: 14),
                              
                              // Document Titles, Tags and Metadata
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15,
                                        color: Colors.black87,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      children: [
                                        if (tags.isNotEmpty) ...[
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                                            decoration: BoxDecoration(
                                              color: _getTagBackgroundColor(tags.first),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: Text(
                                              tags.first,
                                              style: GoogleFonts.poppins(
                                                fontSize: 11,
                                                color: _getTagTextColor(tags.first),
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                        ],
                                        Text(
                                          timeAgo,
                                          style: GoogleFonts.poppins(
                                            fontSize: 12,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              // More Actions Option
                              IconButton(
                                icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                                onPressed: () => _showActionsMenu(context, title, fileName, data),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.description_outlined, size: 60, color: Colors.grey.shade200),
          const SizedBox(height: 15),
          Text(
            "No documents found",
            style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 15),
          ),
        ],
      ),
    );
  }

  Widget _buildFileIcon(String fileName) {
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
    } else if (ext == 'ppt' || ext == 'pptx') {
      iconData = Icons.slideshow;
      iconColor = const Color(0xFFFB8C00);
      bgColor = const Color(0xFFFFF3E0);
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        iconData,
        color: iconColor,
        size: 26,
      ),
    );
  }

  Color _getTagBackgroundColor(String tag) {
    String t = tag.toLowerCase();
    if (t.contains('policy')) return const Color(0xFFFFF8E1); // Light Amber
    if (t.contains('report')) return const Color(0xFFE8F5E9); // Light Green
    if (t.contains('manual')) return const Color(0xFFF3E5F5); // Light Purple
    return const Color(0xFFE8EAF6); // Light Indigo
  }

  Color _getTagTextColor(String tag) {
    String t = tag.toLowerCase();
    if (t.contains('policy')) return const Color(0xFFFFB300);
    if (t.contains('report')) return const Color(0xFF43A047);
    if (t.contains('manual')) return const Color(0xFF8E24AA);
    return const Color(0xFF3F51B5);
  }

  void _showActionsMenu(BuildContext context, String title, String fileName, Map<String, dynamic> data) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            if (fileName.isNotEmpty)
              Text(
                fileName,
                style: GoogleFonts.poppins(fontSize: 13, color: Colors.grey),
              ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.info_outline, color: Color(0xFF3F51B5)),
              title: Text("View Details", style: GoogleFonts.poppins()),
              onTap: () {
                Get.back();
                _showDetailsDialog(title, fileName, data);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete_outline, color: Colors.red),
              title: Text("Delete Document", style: GoogleFonts.poppins(color: Colors.red)),
              onTap: () {
                Get.back();
                // Future enhancement: add delete logic if required
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDetailsDialog(String title, String fileName, Map<String, dynamic> data) {
    final description = data['description'] ?? 'No description provided';
    final folder = data['folder'] ?? 'None';
    final tags = data['tags'] != null ? List<String>.from(data['tags']) : <String>[];

    Get.dialog(
      AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(title, style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("File Name:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
              Text(fileName, style: GoogleFonts.poppins()),
              const SizedBox(height: 12),
              Text("Folder:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
              Text(folder, style: GoogleFonts.poppins()),
              const SizedBox(height: 12),
              Text("Description:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
              Text(description, style: GoogleFonts.poppins()),
              if (tags.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text("Tags:", style: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 6,
                  children: tags.map((t) => Chip(label: Text(t, style: GoogleFonts.poppins(fontSize: 12)))).toList(),
                )
              ]
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Close")),
        ],
      ),
    );
  }
}
