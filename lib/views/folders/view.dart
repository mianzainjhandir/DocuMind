import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:documind/views/folders/logic.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class FoldersScreen extends StatelessWidget {
  const FoldersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final FoldersController controller = Get.put(FoldersController());
    const Color indigoTheme = Color(0xFF3F51B5);

    // Call init default folders
    controller.initDefaultFolders();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'Folders',
          style: GoogleFonts.poppins(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 10),
            // Create Folder Button
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () => _showCreateFolderDialog(context, controller),
                icon: const Icon(Icons.add, color: Colors.white),
                label: Text(
                  'Create Folder',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: indigoTheme,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Folders List
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: controller.getFolders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text(
                        "No folders found",
                        style: GoogleFonts.poppins(color: Colors.grey),
                      ),
                    );
                  }

                  final folders = snapshot.data!.docs;

                  return ListView.separated(
                    itemCount: folders.length,
                    separatorBuilder: (context, index) => const SizedBox(height: 15),
                    itemBuilder: (context, index) {
                      final folder = folders[index];
                      final folderName = folder['name'];

                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade100),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            // Folder Icon Container
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF3E0), // Light Orange
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(
                                Icons.folder,
                                color: Colors.orange,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 15),
                            // Folder Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    folderName,
                                    style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  // Document Count
                                  StreamBuilder<QuerySnapshot>(
                                    stream: controller.getDocumentsInFolder(folderName),
                                    builder: (context, docSnapshot) {
                                      int count = 0;
                                      if (docSnapshot.hasData) {
                                        count = docSnapshot.data!.docs.length;
                                      }
                                      return Text(
                                        "$count documents",
                                        style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            // Menu Button
                            IconButton(
                              icon: const Icon(Icons.more_vert, color: Colors.grey),
                              onPressed: () {},
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showCreateFolderDialog(BuildContext context, FoldersController controller) {
    final TextEditingController folderNameController = TextEditingController();
    Get.dialog(
      AlertDialog(
        title: Text("Create Folder", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        content: TextField(
          controller: folderNameController,
          decoration: const InputDecoration(hintText: "Enter folder name"),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              controller.createFolder(folderNameController.text.trim());
              Get.back();
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }
}
