// Import paket yang diperlukan untuk pengembangan Flutter
import 'package:flutter/material.dart'; // Paket dasar Flutter
import 'package:catetin/Authtentication/signup.dart'; // Import SignUp untuk navigasi
import 'package:catetin/JsonModels/users.dart'; // Model pengguna
import 'package:catetin/SQLite/sqlite.dart'; // Database SQLite
import 'package:catetin/Views/activities.dart'; // Halaman Activities

// Kelas LoginScreen merupakan StatefulWidget untuk halaman masuk
class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

// State dari LoginScreen
class _LoginScreenState extends State<LoginScreen> {
  final username = TextEditingController(); // Controller untuk input username
  final password = TextEditingController(); // Controller untuk input password
  bool isVisible = false; // Variabel untuk mengatur keberadaan teks tersembunyi
  bool isLoginTrue = false; // Variabel untuk menangani kebenaran login
  final db = DatabaseHelper(); // Instance dari DatabaseHelper
  final formKey = GlobalKey<FormState>(); // GlobalKey untuk form

  // Fungsi untuk melakukan login
  login() async {
    var response = await db
        .login(Users(usrName: username.text, usrPassword: password.text));
    if (response == true) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  const Activities())); // Navigasi ke halaman Activities setelah login berhasil
    } else {
      setState(() {
        isLoginTrue = true; // Set state jika login gagal
      });
    }
  }

  // Menggunakan widget Scaffold sebagai kerangka tampilan
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 18, 11, 1), // Warna latar belakang
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Text(
                    "LOG-IN", // Teks untuk masuk
                    style: TextStyle(
                      color: Color.fromRGBO(229, 229, 203, 1),
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromRGBO(
                            60, 42, 33, 1)), // Warna bidang input
                    child: TextFormField(
                      controller: username,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Username diperlukan";
                        }
                        return null;
                      },
                      style: TextStyle(
                          color: Color.fromRGBO(
                              229, 229, 203, 1)), // Warna teks input
                      decoration: const InputDecoration(
                        icon: Icon(Icons.person,
                            color:
                                Color.fromRGBO(213, 206, 163, 1)), // Warna ikon
                        border: InputBorder.none,
                        hintText: "Username",
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(
                                229, 229, 203, 1)), // Warna teks petunjuk
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(8),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Color.fromRGBO(
                            60, 42, 33, 1)), // Warna bidang input
                    child: TextFormField(
                      controller: password,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password diperlukan";
                        }
                        return null;
                      },
                      obscureText: !isVisible,
                      style: TextStyle(
                          color: Color.fromRGBO(
                              229, 229, 203, 1)), // Warna teks input
                      decoration: InputDecoration(
                        icon: const Icon(Icons.lock,
                            color:
                                Color.fromRGBO(213, 206, 163, 1)), // Warna ikon
                        border: InputBorder.none,
                        hintText: "Password",
                        hintStyle: TextStyle(
                            color: Color.fromRGBO(
                                229, 229, 203, 1)), // Warna teks petunjuk
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isVisible = !isVisible;
                            });
                          },
                          icon: Icon(
                            isVisible ? Icons.visibility : Icons.visibility_off,
                            color: Color.fromRGBO(213, 206, 163, 1),
                          ), // Warna ikon
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 55,
                    width: MediaQuery.of(context).size.width * .9,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color:
                            Color.fromRGBO(213, 206, 163, 1)), // Warna tombol
                    child: TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            login();
                          }
                        },
                        child: const Text(
                          "LOGIN",
                          style: TextStyle(
                              color:
                                  Color.fromRGBO(26, 18, 11, 1)), // Warna teks
                        )),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Belum punya akun?", // Teks
                        style: TextStyle(
                            color:
                                Color.fromRGBO(213, 206, 163, 1)), // Warna teks
                      ),
                      TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SignUp())); // Navigasi ke halaman pendaftaran
                          },
                          child: const Text(
                            "SIGN UP",
                            style: TextStyle(
                                color: Color.fromRGBO(229, 229, 203, 1)),
                          )), // Warna teks
                    ],
                  ),
                  isLoginTrue
                      ? const Text(
                          "Username atau password salah",
                          style: TextStyle(color: Colors.red),
                        )
                      : const SizedBox(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
