// Di sini pertama-tama kita membuat model json untuk pengguna
// Untuk mengurai data JSON ini, lakukan sebagai berikut:
//

class Users {
  final int? usrId; // ID pengguna
  final String usrName; // Nama pengguna
  final String usrPassword; // Kata sandi pengguna

  // Konstruktor untuk Users
  Users({
    this.usrId,
    required this.usrName,
    required this.usrPassword,
  });

  // Method factory untuk membuat Users dari Map
  factory Users.fromMap(Map<String, dynamic> json) => Users(
        usrId: json["usrId"],
        usrName: json["usrName"],
        usrPassword: json["usrPassword"],
      );

  // Method untuk mengonversi Users menjadi Map
  Map<String, dynamic> toMap() => {
        "usrId": usrId,
        "usrName": usrName,
        "usrPassword": usrPassword,
      };
}
