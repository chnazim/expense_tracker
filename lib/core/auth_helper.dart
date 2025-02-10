// import 'package:shared_preferences/shared_preferences.dart';
//
// class AuthHelper {
//   static Future<void> saveUser(String username) async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.setString('username', username);
//   }
//
//   static Future<String?> getUser() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     return prefs.getString('username');
//   }
//
//   static Future<void> logout() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     await prefs.remove('username');
//   }
// }


import 'package:shared_preferences/shared_preferences.dart';

class AuthHelper {
  static Future<void> saveUser(String username) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('username', username); // Saving the username
  }

  static Future<String?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username');  // Retrieving the saved username
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');  // Remove username when logging out
  }

  // Save expenses for a specific user
  static Future<void> saveUserData(String username, List<String> expenses) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList(username, expenses);  // Save the expenses under the username key
  }

  // Get expenses for a specific user
  static Future<List<String>?> getUserData(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(username);  // Retrieve the expenses list for the specific username
  }
}
