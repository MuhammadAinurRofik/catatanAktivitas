// Mengimpor paket-paket yang diperlukan untuk mengelola database SQLite
import 'package:path/path.dart'; // Import path untuk mengelola path file
import 'package:sqflite/sqflite.dart'; // Import sqflite untuk mengakses dan mengelola database SQLite
import 'package:catetin/JsonModels/activity_tracker_model.dart'; // Import model kegiatan untuk mengelola data kegiatan
import 'package:catetin/JsonModels/users.dart'; // Import model pengguna untuk mengelola data pengguna

// Kelas DatabaseHelper digunakan untuk melakukan operasi-operasi database
class DatabaseHelper {
  final databaseName = "activity_tracker.db"; // Nama database
  String activityTable =
      "CREATE TABLE activities (activityId INTEGER PRIMARY KEY AUTOINCREMENT, userId INTEGER, activityName TEXT NOT NULL, activityDescription TEXT NOT NULL, createdAt TEXT DEFAULT CURRENT_TIMESTAMP, durationInMinutes INTEGER DEFAULT 0)"; // Tabel kegiatan
  String users =
      "create table users (usrId INTEGER PRIMARY KEY AUTOINCREMENT, usrName TEXT UNIQUE, usrPassword TEXT)"; // Tabel pengguna

  // Method initDB digunakan untuk inisialisasi database
  Future<Database> initDB() async {
    final databasePath = await getDatabasesPath(); // Mendapatkan path database
    final path = join(databasePath,
        databaseName); // Menggabungkan path database dengan nama database

    return openDatabase(path, version: 3, onCreate: (db, version) async {
      await db.execute(users); // Membuat tabel pengguna jika belum ada
      await db.execute(activityTable); // Membuat tabel kegiatan jika belum ada
    }, onUpgrade: (db, oldVersion, newVersion) async {
      if (oldVersion < 2) {
        await db.execute(
            "ALTER TABLE activities ADD COLUMN durationInMinutes INTEGER DEFAULT 0"); // Menambah kolom durationInMinutes jika versi database sebelumnya kurang dari 2
      }
    });
  }

  // Method login digunakan untuk melakukan proses login pengguna
  Future<bool> login(Users user) async {
    final Database db = await initDB(); // Mendapatkan instance database
    var result = await db.rawQuery(
        "select * from users where usrName = '${user.usrName}' AND usrPassword = '${user.usrPassword}'"); // Mengecek apakah pengguna terdaftar
    if (result.isNotEmpty) {
      return true; // Jika pengguna ditemukan, kembalikan true
    } else {
      return false; // Jika pengguna tidak ditemukan, kembalikan false
    }
  }

  // Method signup digunakan untuk melakukan proses pendaftaran pengguna baru
  Future<int> signup(Users user) async {
    final Database db = await initDB(); // Mendapatkan instance database

    return db.insert(
        'users', user.toMap()); // Menambahkan pengguna baru ke dalam database
  }

  // Method searchActivities digunakan untuk mencari kegiatan berdasarkan kata kunci
  Future<List<ActivityTrackerModel>> searchActivities(String keyword) async {
    final Database db = await initDB(); // Mendapatkan instance database
    List<Map<String, Object?>> searchResult = await db.rawQuery(
        "select * from activities where activityName LIKE ?",
        ["%$keyword%"]); // Mencari kegiatan berdasarkan nama kegiatan
    return searchResult
        .map((e) => ActivityTrackerModel.fromMap(e))
        .toList(); // Mengonversi hasil pencarian ke dalam model kegiatan
  }

  // Method createActivity digunakan untuk menambahkan kegiatan baru ke dalam database
  Future<int> createActivity(ActivityTrackerModel activity) async {
    final Database db = await initDB(); // Mendapatkan instance database
    return db.insert('activities',
        activity.toMap()); // Menambahkan kegiatan baru ke dalam database
  }

  // Method getActivities digunakan untuk mendapatkan daftar kegiatan berdasarkan tanggal
  Future<List<ActivityTrackerModel>> getActivities(DateTime date) async {
    final Database db = await initDB(); // Mendapatkan instance database
    String formattedDate =
        "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}"; // Format tanggal
    List<Map<String, Object?>> result = await db.rawQuery(
        'SELECT * FROM activities WHERE createdAt LIKE ?',
        ["$formattedDate%"]); // Mendapatkan kegiatan berdasarkan tanggal
    return result
        .map((e) => ActivityTrackerModel.fromMap(e))
        .toList(); // Mengonversi hasil ke dalam model kegiatan
  }

  // Method getActivitiesInRange digunakan untuk mendapatkan daftar kegiatan dalam rentang tanggal tertentu
  Future<List<ActivityTrackerModel>> getActivitiesInRange(
      DateTime startDate, DateTime endDate) async {
    final Database db = await initDB(); // Mendapatkan instance database
    String formattedStartDate =
        "${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}"; // Format tanggal awal
    String formattedEndDate =
        "${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}"; // Format tanggal akhir

    List<Map<String, Object?>> result = await db.rawQuery(
        'SELECT * FROM activities WHERE createdAt BETWEEN ? AND ?', [
      formattedStartDate,
      formattedEndDate
    ]); // Mendapatkan kegiatan dalam rentang tanggal tertentu
    return result
        .map((e) => ActivityTrackerModel.fromMap(e))
        .toList(); // Mengonversi hasil ke dalam model kegiatan
  }

  // Method deleteActivity digunakan untuk menghapus kegiatan berdasarkan ID
  Future<int> deleteActivity(int id) async {
    final Database db = await initDB(); // Mendapatkan instance database
    return db.delete('activities',
        where: 'activityId = ?',
        whereArgs: [id]); // Menghapus kegiatan dari database
  }

  // Method updateActivity digunakan untuk memperbarui informasi kegiatan
  Future<int> updateActivity(
      String name, String description, int duration, int activityId) async {
    final Database db = await initDB(); // Mendapatkan instance database
    // Memperbarui informasi kegiatan dengan nama, deskripsi, dan durasi baru
    return db.rawUpdate(
        'update activities set activityName = ?, activityDescription = ?, durationInMinutes = ? where activityId = ?',
        [name, description, duration, activityId]);
  }
}
