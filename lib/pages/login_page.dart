import 'package:flutter/material.dart';
import 'package:pertemuan10_2306064/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State <LoginPage> createState() =>  _LoginPageState();
}

class  _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formkey = GlobalKey<FormState>();
 
  Future<void> login() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isLogin", true);
    await  prefs.setString("username", usernameController.text);
    await prefs.setString("password", passwordController.text);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_)=> const HomePage())
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Card(
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: .circular(15),
            ),
            child: Padding(
              padding: const .all(25),
              child: Form(
                key: _formkey,
                child: Column(
                  mainAxisSize: .min,
                  children: [
                    const Icon(Icons.person, size: 80, color: Colors.green),
                  const SizedBox(height: 20),

                  // form username
                  TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(Icons.person),
                      border: OutlineInputBorder(
                        borderRadius: .circular(10),
                      )
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Username tidak boleh Kosong!";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // form password
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      border: OutlineInputBorder(
                        borderRadius: .circular(10),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password tidak boleh kosong";
                      }
                      if (value.length < 6) {
                        return "Password tidak boleh kurang dari 6 karakter";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                   SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: login, 
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: .circular(10),
                        ),
                      ),
                      child: const Text(
                        "Login",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white
                        ),
                      ),
                    ),
                  )
                  ],
                ),
              )
           ),
          ),
        ),
      ), 
    );
  }
}