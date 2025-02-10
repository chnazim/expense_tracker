// import 'package:flutter/material.dart';
// import 'home_screen.dart';
// import '../core/auth_helper.dart';
//
// class LoginScreen extends StatelessWidget {
//   final TextEditingController usernameController = TextEditingController();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text("Login")),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               controller: usernameController,
//               decoration: InputDecoration(labelText: "Username"),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () async {
//                 if (usernameController.text.isNotEmpty) {
//                   await AuthHelper.saveUser(usernameController.text);
//                   Navigator.pushReplacement(
//                       context, MaterialPageRoute(builder: (context) => HomeScreen()));
//                 }
//               },
//               child: Text("Login"),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';
import '../core/auth_helper.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController usernameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[900], // Dark background
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // App Logo / Icon
              Icon(Icons.account_balance_wallet_rounded,
                  size: 80, color: Colors.white),

              SizedBox(height: 20),

              // Welcome Text
              Text(
                "Welcome Back!",
                style: GoogleFonts.poppins(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),

              Text(
                "Track your expenses effortlessly.",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),

              SizedBox(height: 40),

              // Username Field
              TextField(
                controller: usernameController,
                style: TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Username",
                  labelStyle: TextStyle(color: Colors.white70),
                  prefixIcon: Icon(Icons.person, color: Colors.white70),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Login Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (usernameController.text.isNotEmpty) {
                      await AuthHelper.saveUser(usernameController.text);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => HomeScreen())
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.tealAccent[700],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Login",
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              SizedBox(height: 20),

              // Signup / Forgot Password
              TextButton(
                onPressed: () {},
                child: Text(
                  "Don't have an account? Sign up",
                  style: TextStyle(color: Colors.tealAccent[700]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
