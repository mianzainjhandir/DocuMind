import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SocialLoginButtons extends StatelessWidget {
  final VoidCallback onGoogleTap;
  final VoidCallback onFacebookTap;

  const SocialLoginButtons({
    super.key,
    required this.onGoogleTap,
    required this.onFacebookTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [

        // ================= OR CONTINUE WITH =================
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.grey.shade300,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Text(
                "Or continue with",
                style: GoogleFonts.poppins(
                  fontSize: 11,
                  color: Colors.grey.shade600,
                ),
              ),
            ),

            Expanded(
              child: Divider(
                color: Colors.grey.shade300,
              ),
            ),
          ],
        ),

        const SizedBox(height: 15),

        // ================= GOOGLE + FACEBOOK =================
        Row(
          children: [

            // Google
            Expanded(

              child: _socialButton(
                imagePath: "assets/images/google1.png",
                text: "Google",
                onTap: onGoogleTap,
              ),
            ),

            const SizedBox(width: 10),

            // Facebook
            Expanded(
              child: _socialButton(
                imagePath: "assets/images/img.png",
                text: "Facebook",
                onTap: onFacebookTap,
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ================= SOCIAL BUTTON =================

  Widget _socialButton({
    required String imagePath,
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: 50,
      child: ElevatedButton(
        onPressed: onTap,

        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.grey.shade100,
          foregroundColor: Colors.black87,
          elevation: 0,

          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Image.asset(
              imagePath,
              height: 30,
              width: 30,
              fit: BoxFit.contain,
            ),

            const SizedBox(width: 10),

            Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
