import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class UploadDocumentController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController tagController = TextEditingController();

  var selectedFileName = "".obs;
  File? selectedFile;
  var selectedFolder = "Select folder".obs;
  var tags = <String>["Policy", "HR", "Report"].obs;
  var isUploading = false.obs;

  Future<void> pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      selectedFile = File(result.files.single.path!);
      selectedFileName.value = result.files.single.name;
    }
  }

  Future<void> uploadDocument() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (selectedFile == null) {
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
      String fileName = "${DateTime.now().millisecondsSinceEpoch}_${selectedFileName.value}";
      
      // 1. Upload to Firebase Storage
      Reference ref = _storage.ref().child("documents/$uid/$fileName");
      UploadTask uploadTask = ref.putFile(selectedFile!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      // 2. Save Metadata to Firestore
      await _firestore.collection('documents').add({
        'userId': uid,
        'title': title,
        'description': description,
        'folder': selectedFolder.value,
        'tags': tags,
        'fileUrl': downloadUrl,
        'fileName': selectedFileName.value,
        'createdAt': FieldValue.serverTimestamp(),
      });

      isUploading.value = false;
      Get.back();
      Get.snackbar("Success", "Document uploaded successfully!", backgroundColor: Colors.green, colorText: Colors.white);
      
      // Reset fields
      titleController.clear();
      descriptionController.clear();
      selectedFile = null;
      selectedFileName.value = "";
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
