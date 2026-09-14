import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class DocumentsTabController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  var selectedType = "All".obs;
  var searchQuery = "".obs;

  final List<String> documentTypes = ["All", "PDF", "DOCX", "XLS", "PPT"];

  // Stream to get all documents for the current user
  Stream<QuerySnapshot> getDocumentsStream() {
    String uid = _auth.currentUser!.uid;
    return _firestore
        .collection('documents')
        .where('userId', isEqualTo: uid)
        .snapshots();
  }

  // Filter and search logic on the list of documents
  List<DocumentSnapshot> filterDocuments(List<DocumentSnapshot> docs) {
    return docs.where((doc) {
      final data = doc.data() as Map<String, dynamic>;
      final title = (data['title'] ?? '').toString().toLowerCase();
      final fileName = (data['fileName'] ?? '').toString().toLowerCase();
      final description = (data['description'] ?? '').toString().toLowerCase();
      final query = searchQuery.value.toLowerCase();

      // 1. Search filter
      bool matchesSearch = title.contains(query) ||
          fileName.contains(query) ||
          description.contains(query);

      // 2. Type filter (extension check)
      bool matchesType = true;
      if (selectedType.value != "All") {
        String ext = selectedType.value.toLowerCase();
        matchesType = fileName.endsWith('.$ext') || 
                      fileName.endsWith('.${ext}x') || // for xls/xlsx, doc/docx
                      title.endsWith('.$ext') ||
                      title.endsWith('.${ext}x');
      }

      return matchesSearch && matchesType;
    }).toList();
  }
}
