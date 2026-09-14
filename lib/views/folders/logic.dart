import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class FoldersController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Stream to get folders
  Stream<QuerySnapshot> getFolders() {
    String uid = _auth.currentUser!.uid;
    return _firestore
        .collection('folders')
        .where('userId', isEqualTo: uid)
        .snapshots();
  }

  // Stream to get document count for a specific folder
  Stream<QuerySnapshot> getDocumentsInFolder(String folderName) {
    String uid = _auth.currentUser!.uid;
    return _firestore
        .collection('documents')
        .where('userId', isEqualTo: uid)
        .where('folder', isEqualTo: folderName)
        .snapshots();
  }

  Future<void> createFolder(String folderName) async {
    if (folderName.isEmpty) return;
    
    String uid = _auth.currentUser!.uid;
    
    try {
      // Check if folder already exists
      var existing = await _firestore
          .collection('folders')
          .where('userId', isEqualTo: uid)
          .where('name', isEqualTo: folderName)
          .get();
          
      if (existing.docs.isEmpty) {
        await _firestore.collection('folders').add({
          'name': folderName,
          'userId': uid,
          'createdAt': FieldValue.serverTimestamp(),
        });
      } else {
        Get.snackbar("Info", "Folder already exists");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    }
  }
  
  // Initialize default folders if none exist
  Future<void> initDefaultFolders() async {
    String uid = _auth.currentUser!.uid;
    var existing = await _firestore
        .collection('folders')
        .where('userId', isEqualTo: uid)
        .get();
        
    if (existing.docs.isEmpty) {
      List<String> defaults = ["Company Policies", "HR Documents", "Project Files", "Reports", "Personal"];
      for (var name in defaults) {
        await createFolder(name);
      }
    }
  }
}
