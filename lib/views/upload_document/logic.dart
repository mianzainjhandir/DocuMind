import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadDocumentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  var selectedFileName = "".obs;
  var selectedFilePath = "".obs;
  var selectedFolder = "Select folder".obs;
  var tags = <String>["Policy", "HR", "Report"].obs;
  var isUploading = false.obs;
  var availableFolders = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchFolders();
  }

  void fetchFolders() {
    String uid = _auth.currentUser!.uid;
    _firestore.collection('folders').where('userId', isEqualTo: uid).snapshots().listen((snapshot) {
      availableFolders.value = snapshot.docs.map((doc) => doc['name'] as String).toList();
    });
  }

  Future<void> pickFile() async {
    try {
      // In file_picker 12.3.0, use static pickFile method for single file selection.
      final PlatformFile? file = await FilePicker.pickFile(
        type: FileType.any,
      );

      if (file != null && file.name.isNotEmpty) {
        selectedFileName.value = file.name;
        // path might be null on Web, which is fine for our metadata-only storage.
        selectedFilePath.value = file.path ?? "";
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to pick file: $e");
    }
  }

  Future<void> uploadDocument() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (selectedFileName.value.isEmpty) {
      Get.snackbar("Error", "Please select a file to upload", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    if (title.isEmpty) {
      Get.snackbar("Error", "Please enter a document title", backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    isUploading.value = true;

    try {
      String uid = _auth.currentUser!.uid;
      
      // Save Metadata to Firestore
      await _firestore.collection('documents').add({
        'userId': uid,
        'title': title,
        'description': description,
        'folder': selectedFolder.value,
        'tags': List<String>.from(tags),
        'fileName': selectedFileName.value,
        'createdAt': FieldValue.serverTimestamp(),
      });

      isUploading.value = false;
      Get.back();
      Get.snackbar("Success", "Document information saved successfully!", backgroundColor: Colors.green, colorText: Colors.white);
      
      // Reset fields
      titleController.clear();
      descriptionController.clear();
      selectedFileName.value = "";
      selectedFilePath.value = "";
    } catch (e) {
      isUploading.value = false;
      Get.snackbar("Error", e.toString(), backgroundColor: Colors.red, colorText: Colors.white);
    }
  }

  void addTag(String tag) {
    if (tag.isNotEmpty && !tags.contains(tag)) {
      tags.add(tag);
    }
  }
}
