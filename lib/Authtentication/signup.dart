import 'package:flutter/material.dart';
import 'package:catetin/Authtentication/login.dart'; // Import kelas LoginScreen untuk navigasi
import 'package:catetin/JsonModels/users.dart'; // Import model pengguna
import 'package:catetin/SQLite/sqlite.dart'; // Import kelas DatabaseHelper untuk akses database

// Kelas SignUp adalah StatefulWidget untuk halaman pendaftaran
class SignUp extends StatefulWidget {
  const SignUp({Key? key});

  @override
  State<SignUp> createState() => _SignUpState();
}

// State dari SignUp
class _SignUpState extends State<SignUp> {
  final username = TextEditingController(); // Controller untuk input username
  final password = TextEditingController(); // Controller untuk input password
  final confirmPassword =
      TextEditingController(); // Controller untuk input konfirmasi password

  final formKey =
      GlobalKey<FormState>(); // GlobalKey untuk mengakses dan memvalidasi form
  bool isVisible = false; // Variabel untuk mengatur keberadaan teks tersembunyi

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(26, 18, 11, 1), // Warna latar belakang
      body: Center(
        child: SingleChildScrollView(
          child: Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Gunakan widget Center untuk membuat teks berada di tengah
                  Center(
                    child: Text(
                      "REGISTER", // Teks Pendaftaran
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(213, 206, 163, 1), // Warna teks
                      ),
                    ),
                  ),

                  // Container untuk field username
                  Container(
                    margin: EdgeInsets.all(8),
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

                  // Container untuk field password
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "Password", // Teks Password
                                style: TextStyle(
                                  color: Color.fromRGBO(
                                      229, 229, 203, 1), // Warna teks
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
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
                                  border: InputBorder.none,
                                  hintText: "****",
                                  hintStyle: TextStyle(
                                      color: Color.fromRGBO(229, 229, 203,
                                          1)), // Warna teks petunjuk
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isVisible = !isVisible;
                                      });
                                    },
                                    icon: Icon(
                                      isVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Color.fromRGBO(213, 206, 163, 1),
                                    ), // Warna ikon
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                "Confirm Password", // Teks Konfirmasi Password
                                style: TextStyle(
                                  color: Color.fromRGBO(
                                      229, 229, 203, 1), // Warna teks
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.all(8),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  color: Color.fromRGBO(
                                      60, 42, 33, 1)), // Warna bidang input
                              child: TextFormField(
                                controller: confirmPassword,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Password diperlukan";
                                  } else if (password.text !=
                                      confirmPassword.text) {
                                    return "Password tidak cocok";
                                  }
                                  return null;
                                },
                                obscureText: !isVisible,
                                style: TextStyle(
                                    color: Color.fromRGBO(
                                        229, 229, 203, 1)), // Warna teks input
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: "****",
                                  hintStyle: TextStyle(
                                      color: Color.fromRGBO(229, 229, 203,
                                          1)), // Warna teks petunjuk
                                  suffixIcon: IconButton(
                                    onPressed: () {
                                      setState(() {
                                        isVisible = !isVisible;
                                      });
                                    },
                                    icon: Icon(
                                      isVisible
                                          ? Icons.visibility
                                          : Icons.visibility_off,
                                      color: Color.fromRGBO(213, 206, 163, 1),
                                    ), // Warna ikon
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  // Tombol Sign Up
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
                            // Proses pendaftaran pengguna
                            final db = DatabaseHelper();
                            db
                                .signup(Users(
                              usrName: username.text,
                              usrPassword: password.text,
                            ))
                                .whenComplete(() {
                              // Setelah berhasil membuat pengguna, pindah ke layar masuk
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const LoginScreen()));
                            });
                          }
                        },
                        child: const Text(
                          "SIGN UP",
                          style: TextStyle(
                              color:
                                  Color.fromRGBO(26, 18, 11, 1)), // Warna teks
                        )),
                  ),

                  // Tombol Login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sudah punya akun?", // Teks Sudah punya akun?
                        style:
                            TextStyle(color: Color.fromRGBO(213, 206, 163, 1)),
                      ), // Warna teks
                      TextButton(
                        onPressed: () {
                          // Navigasi ke halaman masuk
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginScreen()));
                        },
                        child: const Text(
                          "Masuk",
                          style: TextStyle(
                              color: Color.fromRGBO(229, 229, 203, 1)),
                        ), // Warna teks
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
