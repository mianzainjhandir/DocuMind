import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:documind/views/documents/document_details_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class DocumentAnalyticsScreen extends StatefulWidget {
  const DocumentAnalyticsScreen({super.key});

  @override
  State<DocumentAnalyticsScreen> createState() => _DocumentAnalyticsScreenState();
}

class _DocumentAnalyticsScreenState extends State<DocumentAnalyticsScreen> {
  String selectedPeriod = "7D";
  final List<String> periods = ["7D", "30D", "90D"];

  @override
  Widget build(BuildContext context) {
    const Color activeBlue = Color(0xFF1D4ED8);
    final String uid = FirebaseAuth.instance.currentUser?.uid ?? "";

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () {},
        ),
        title: Text(
          'Document Analytics',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 22,
          ),
        ),
        centerTitle: false,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('documents')
            .where('userId', isEqualTo: uid)
            .snapshots(),
        builder: (context, snapshot) {
          int docCount = 0;
          if (snapshot.hasData) {
            docCount = snapshot.data!.docs.length;
          }

          // Dynamic mock logic derived linearly for total stats match as per screen
          int totalViews = docCount * 31 + 31; 
          int downloads = docCount * 12 + 12;

          final allDocs = snapshot.hasData ? snapshot.data!.docs : [];

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Double Top Stats Grid Cards (Total Views, Downloads)
                Row(
                  children: [
                    Expanded(
                      child: _buildHeaderStatCard(
                        title: "Total Views",
                        value: "$totalViews",
                        percentage: "+ 12%",
                        isPositive: true,
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildHeaderStatCard(
                        title: "Downloads",
                        value: "$downloads",
                        percentage: "+ 8%",
                        isPositive: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 25),

                // 2. Document Activity Analytics Line Chart Box Layout
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Document Activity",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF0F172A),
                            ),
                          ),
                          // Horizontal Period Chips Row
                          Row(
                            children: periods.map((p) {
                              bool isSelected = selectedPeriod == p;
                              return GestureDetector(
                                onTap: () => setState(() => selectedPeriod = p),
                                child: Container(
                                  margin: const EdgeInsets.only(left: 8),
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: isSelected ? activeBlue : Colors.grey.shade50,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? activeBlue : Colors.grey.shade200,
                                    ),
                                  ),
                                  child: Text(
                                    p,
                                    style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: isSelected ? Colors.white : Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          )
                        ],
                      ),
                      const SizedBox(height: 25),
                      // Custom Vector Drawing Line Graph Matching Image Exactly
                      SizedBox(
                        height: 160,
                        width: double.infinity,
                        child: CustomPaint(
                          painter: ActivityGraphPainter(activeBlue: activeBlue),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),

                // 3. Top Documents List Grid Layout Box
                Text(
                  "Top Documents",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 12),
                
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.grey.shade100),
                  ),
                  child: allDocs.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: Text(
                              "No document analytics stats yet.",
                              style: GoogleFonts.poppins(color: Colors.grey),
                            ),
                          ),
                        )
                      : ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: allDocs.length.clamp(0, 3),
                          separatorBuilder: (context, index) => const Divider(height: 24, color: Color(0xFFF1F5F9)),
                          itemBuilder: (context, index) {
                            final doc = allDocs[index];
                            final data = doc.data() as Map<String, dynamic>;
                            final title = data['title'] ?? 'Untitled Document';
                            final fileName = data['fileName'] ?? '';

                            // Mocked descending views for top visual rows
                            int views = (32 - (index * 11)).clamp(5, 50);

                            return InkWell(
                              onTap: () => Get.to(() => DocumentDetailsScreen(
                                    title: title,
                                    fileName: fileName,
                                    data: data,
                                  )),
                              borderRadius: BorderRadius.circular(12),
                              child: Row(
                                children: [
                                  _buildSmallIconBadge(fileName),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          title,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: const Color(0xFF1E293B),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          "2 days ago",
                                          style: GoogleFonts.poppins(
                                            fontSize: 11,
                                            color: Colors.grey.shade400,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    "$views views",
                                    style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey.shade500,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeaderStatCard({
    required String title,
    required String value,
    required String percentage,
    required bool isPositive,
  }) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade500,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFDCFCE7), // Soft Light Green badge bg
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.arrow_upward, color: Color(0xFF15803D), size: 12),
                const SizedBox(width: 4),
                Text(
                  percentage,
                  style: GoogleFonts.poppins(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF15803D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallIconBadge(String fileName) {
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
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(iconData, color: iconColor, size: 20),
    );
  }
}

// Custom Painter vector logic to render exact gorgeous curved activity wave chart
class ActivityGraphPainter extends CustomPainter {
  final Color activeBlue;
  ActivityGraphPainter({required this.activeBlue});

  @override
  void paint(Canvas canvas, Size size) {
    final gridPaint = Paint()
      ..color = Colors.grey.shade100
      ..strokeWidth = 1;

    // Draw horizontal grid helper lines
    for (int i = 0; i <= 3; i++) {
      double y = size.height * (i / 3);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final path = Path();
    // Smooth custom curved coordinate wave paths matching screenshot visual curve
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(
      size.width * 0.2, size.height * 0.4, 
      size.width * 0.3, size.height * 0.8, 
      size.width * 0.45, size.height * 0.55,
    );
    path.cubicTo(
      size.width * 0.6, size.height * 0.2, 
      size.width * 0.75, size.height * 0.6, 
      size.width * 1.0, size.height * 0.1,
    );

    // Draw gradient fill region inside curve graph
    final fillPath = Path.from(path)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          activeBlue.withOpacity(0.2),
          activeBlue.withOpacity(0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    canvas.drawPath(fillPath, fillPaint);

    // Draw primary wavy blue solid indicator line stroke
    final strokePaint = Paint()
      ..color = activeBlue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
