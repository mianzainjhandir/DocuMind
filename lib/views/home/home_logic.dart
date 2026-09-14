import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var userName = "Zain".obs;
  var totalDocsCount = 0.obs;
  var foldersCount = 0.obs;
  var sharedCount = 3.obs; // Placeholder static or dynamic count as needed

  @override
  void onInit() {
    super.onInit();
    fetchUserDataAndStats();
  }

  void fetchUserDataAndStats() {
    String? uid = _auth.currentUser?.uid;
    if (uid == null) return;

    // 1. Fetch User Name
    _firestore.collection('users').doc(uid).snapshots().listen((snapshot) {
      if (snapshot.exists && snapshot.data() != null) {
        final data = snapshot.data()!;
        if (data.containsKey('name')) {
          userName.value = data['name'] ?? "Zain";
        }
      }
    });

    // 2. Realtime Documents Count
    _firestore.collection('documents').where('userId', isEqualTo: uid).snapshots().listen((snapshot) {
      totalDocsCount.value = snapshot.docs.length;
    });

    // 3. Realtime Folders Count
    _firestore.collection('folders').where('userId', isEqualTo: uid).snapshots().listen((snapshot) {
      foldersCount.value = snapshot.docs.length;
    });
  }

  // Stream to get top 4 Recent Documents for Home Screen
  Stream<QuerySnapshot> getRecentDocuments() {
    String uid = _auth.currentUser!.uid;
    return _firestore
        .collection('documents')
        .where('userId', isEqualTo: uid)
        .snapshots();
  }
}
