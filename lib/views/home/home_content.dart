import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:documind/views/home/home_logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class HomeContent extends StatelessWidget {
  const HomeContent({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    const Color activeBlue = Color(0xFF1D4ED8);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Top Header Row (Greeting, Name, Avatar)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Good Morning,',
                        style: GoogleFonts.poppins(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1E293B),
                        ),
                      ),
                      Obx(() => Row(
                            children: [
                              Text(
                                controller.userName.value,
                                style: GoogleFonts.poppins(
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 5),
                              Text(
                                '👋',
                                style: GoogleFonts.poppins(fontSize: 24),
                              ),
                            ],
                          )),
                    ],
                  ),
                  CircleAvatar(
                    radius: 26,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: const AssetImage('assets/images/zain.jpg'), // Default image.asset path as asked
                  ),
                ],
              ),
              const SizedBox(height: 12),
              
              // Subtitle Text
              Text(
                'Find, manage and explore your documents\nwith the power of AI.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.grey.shade500,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 25),

              // 2. Search Field and Filter Action Box Row
              Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: TextField(
                        style: GoogleFonts.poppins(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search documents, folders, or ask AI...',
                          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 13),
                          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400, size: 22),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: activeBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.tune, color: Colors.white, size: 24),
                  ),
                ],
              ),
              const SizedBox(height: 25),

              // 3. Stats Grid Rows (Total Docs, Folders, Shared)
              Row(
                children: [
                  // Total Docs Card
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.description_outlined,
                      label: "Total Docs",
                      countObs: controller.totalDocsCount,
                      bgColor: const Color(0xFFEEF2FF), // Soft Indigo Blue
                      iconColor: const Color(0xFF4F46E5),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Folders Card
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.folder_open_outlined,
                      label: "Folders",
                      countObs: controller.foldersCount,
                      bgColor: const Color(0xFFECFDF5), // Soft Light Emerald Green
                      iconColor: const Color(0xFF059669),
                    ),
                  ),
                  const SizedBox(width: 15),
                  // Shared Card
                  Expanded(
                    child: _buildStatCard(
                      icon: Icons.share_outlined,
                      label: "Shared",
                      countObs: controller.sharedCount,
                      bgColor: const Color(0xFFF3E8FF), // Soft Light Purple
                      iconColor: const Color(0xFF9333EA),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 4. Recent Documents Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Recent Documents',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'View All',
                    style: GoogleFonts.poppins(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: activeBlue,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // 5. Recent Realtime Firestore Documents List
              StreamBuilder<QuerySnapshot>(
                stream: controller.getRecentDocuments(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Center(child: CircularProgressIndicator(color: activeBlue)),
                    );
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 35),
                      child: Center(
                        child: Text(
                          "No recent documents found",
                          style: GoogleFonts.poppins(color: Colors.grey.shade400, fontSize: 14),
                        ),
                      ),
                    );
                  }

                  final docs = snapshot.data!.docs;
                  // Take top 4 items for preview
                  final displayDocs = docs.take(4).toList();

                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: displayDocs.length,
                    separatorBuilder: (context, index) => const Divider(height: 1, color: Color(0xFFF3F4F6)),
                    itemBuilder: (context, index) {
                      final doc = displayDocs[index];
                      final data = doc.data() as Map<String, dynamic>;

                      final title = data['title'] ?? 'Untitled Document';
                      final fileName = data['fileName'] ?? '';
                      final createdAt = data['createdAt'] as Timestamp?;

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

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            _buildFileIcon(fileName),
                            const SizedBox(width: 14),
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
                                  const SizedBox(height: 4),
                                  Text(
                                    "Updated $timeAgo",
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.more_vert, color: Colors.grey, size: 20),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String label,
    required RxInt countObs,
    required Color bgColor,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: iconColor, size: 22),
          ),
          const SizedBox(height: 12),
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 2),
          Obx(() => Text(
                '${countObs.value}',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0F172A),
                ),
              )),
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
        size: 24,
      ),
    );
  }
}
