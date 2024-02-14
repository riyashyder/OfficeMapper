import 'dart:convert';

import 'package:attendance_login/office_location.dart';
import 'package:attendance_login/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

final Color primaryColor = Colors.blue;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: SplashScreen(),
    );
  }
}

class SignUpScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _signUp(BuildContext context) async {
    final String username = _emailController.text;
    final String password = _passwordController.text;

    final response = await http.post(
      Uri.parse('https://mis.webilesk.com/mobile_api/login.php?username=$username&password=$password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );
    print("signup");
    print(response);

    if (response.statusCode == 200) {
      Get.snackbar('Success', 'Sign up successful');
      print("account created");
    } else {
      Get.snackbar('Error', 'Failed to sign up');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sign Up'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'username',border: OutlineInputBorder(),),

            ),
            SizedBox(
              height: 20,
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password',border: OutlineInputBorder(),),
              obscureText: true,
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () => _signUp(context),
              child: Text('Sign Up'),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(primaryColor),
              ),
            ),
            TextButton(
              onPressed: () {
                Get.off(LoginScreen());
              },
              child: Text('Already have an account? Log in'),
            ),
          ],
        ),
      ),
    );
  }
}

class GlobalVariables {
  static String username = '';
  static String password = '';
}

class LoginScreen extends StatelessWidget {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login(BuildContext context) async {
    final String username = _usernameController.text;
    final String password = _passwordController.text;

    final response = await http.post(
      Uri.parse('https://mis.webilesk.com/mobile_api/login.php?username=$username&password=$password'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse);
      if (jsonResponse['response'] != null && jsonResponse['response']['status'] == 1) {

        // Save the username in shared preferences
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('username', username);
        GlobalVariables.username = username;
        GlobalVariables.password = password;
        Get.snackbar('Success', 'Login successful');
        print('login successfully');
        Get.off(OfficeLocation(officeLatitude: 13.027964, officeLongitude: 80.108127, username: '',));
        // Navigate to home screen or do whatever you want after successful login
      } else {
        Get.snackbar('Error', 'Invalid username or password');
      }
    } else {
      Get.snackbar('Error', 'Failed to log in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () => _login(context),
              child: Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Get.off(SignUpScreen());
              },
              child: Text('Don\'t have an account? Sign up'),
            ),
          ],
        ),
      ),
    );
  }
}










//
// import 'dart:convert';
//
// import 'package:attendance_login/office_location.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:http/http.dart' as http;
//
//
// import 'home_screen.dart';
//
// final Color primaryColor = Colors.blue;
// final Color accentColor = Colors.green;
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Flutter Demo',
//       home: SignUpScreen(),
//     );
//   }
// }
//
// class SignUpScreen extends StatelessWidget {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   Future<void> _signUp(BuildContext context) async {
//     final String email = _emailController.text;
//     final String password = _passwordController.text;
//
//     final response = await http.post(
//       Uri.parse('https://reqres.in/api/register'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'email': email,
//         'password': password,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       Get.snackbar('Success', 'Sign up successful');
//       print("account created");
//     } else {
//       Get.snackbar('Error', 'Failed to sign up');
//     }
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         decoration: BoxDecoration(
//         image: DecorationImage(
//         image: AssetImage('assets/webileskinfotech.png'), // Replace with your background image path
//     fit: BoxFit.cover,
//     ),
//     ),
//     child : Scaffold(
//       appBar: AppBar(
//         title: Text('Sign Up'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                 labelText: 'Email',
//                 labelStyle: GoogleFonts.openSans(color: primaryColor), // Apply custom font and color
//                 border: OutlineInputBorder(),
//               ),
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(
//                 labelText: 'Password',
//                 labelStyle: GoogleFonts.openSans(color: primaryColor), // Apply custom font and color
//                 border: OutlineInputBorder(),
//               ),
//               obscureText: true,
//             ),
//             SizedBox(
//               height: 20,
//             ),
//             ElevatedButton(
//               onPressed: () => _signUp(context),
//               child: Text(
//                 'Sign Up',
//                 style: GoogleFonts.openSans(color: Colors.white), // Apply custom font and color
//               ),
//               style: ButtonStyle(
//                 backgroundColor: MaterialStateProperty.all(primaryColor),
//               ),
//             ),
//
//             TextButton(
//               onPressed: () {
//                 Get.off(LoginScreen());
//               },
//               child: Text('Already have an account? Log in'),
//             ),
//           ],
//         ),
//       ),
//     ));
//   }
// }
//
// class LoginScreen extends StatelessWidget {
//   final TextEditingController _usernameController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   Future<void> _login(BuildContext context) async {
//     final String email = _usernameController.text;
//     final String password = _passwordController.text;
//
//     final response = await http.post(
//       Uri.parse('https://reqres.in/api/login'),
//       headers: <String, String>{
//         'Content-Type': 'application/json; charset=UTF-8',
//       },
//       body: jsonEncode(<String, String>{
//         'email': email,
//         'password': password,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       Get.snackbar('Success', 'Login successful');
//       print('login sucessfully');
//       Get.to(OfficeLocation(officeLatitude: 13.02796125669909, officeLongitude: 80.10813600373346));
//       // Navigate to home screen or do whatever you want after successful login
//     } else {
//       Get.snackbar('Error', 'Invalid username or password');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Padding(
//         padding: EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             TextField(
//               controller: _usernameController,
//               decoration: InputDecoration(labelText: 'email'),
//             ),
//             TextField(
//               controller: _passwordController,
//               decoration: InputDecoration(labelText: 'Password'),
//               obscureText: true,
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () => _login(context),
//               child: Text('Login'),
//             ),
//             TextButton(
//               onPressed: () {
//                 Get.off(SignUpScreen());
//               },
//               child: Text('Don\'t have an account? Sign up'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
