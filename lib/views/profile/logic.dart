import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:documind/views/logIn/view.dart';
import 'package:get/get.dart';

class ProfileController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  var userName = "Zain Ul Abedine".obs;
  var userEmail = "zain@gmail.com".obs;
  var isNotificationEnabled = true.obs;
  var currentThemeMode = "Light".obs;

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
  }

  void fetchUserProfile() {
    User? currentUser = _auth.currentUser;
    if (currentUser != null) {
      // Set email directly from firebase auth credentials
      userEmail.value = currentUser.email ?? "zain@gmail.com";

      // Fetch name from firestore users collection
      _firestore.collection('users').doc(currentUser.uid).snapshots().listen((snapshot) {
        if (snapshot.exists && snapshot.data() != null) {
          final data = snapshot.data()!;
          if (data.containsKey('name')) {
            userName.value = data['name'] ?? "Zain Ul Abedine";
          }
        }
      });
    }
  }

  Future<void> logOutUser() async {
    try {
      await _auth.signOut();
      Get.offAll(() => const LogInPage());
    } catch (e) {
      Get.snackbar("Error", "Failed to logout: $e");
    }
  }

  void toggleThemeMode(String mode) {
    currentThemeMode.value = mode;
    if (mode == "Dark") {
      Get.changeTheme(ThemeData.dark());
    } else {
      Get.changeTheme(ThemeData.light());
    }
  }
}
