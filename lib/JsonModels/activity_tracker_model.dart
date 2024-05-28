class ActivityTrackerModel {
  final int? activityId; // ID kegiatan
  final int? userId; // ID pengguna
  final String activityName; // Nama kegiatan
  final String activityDescription; // Deskripsi kegiatan
  final String createdAt; // Tanggal dan waktu kegiatan dibuat
  final int? durationInMinutes; // Durasi kegiatan dalam menit

  // Konstruktor untuk ActivityTrackerModel
  ActivityTrackerModel({
    this.activityId,
    this.userId,
    required this.activityName,
    required this.activityDescription,
    required this.createdAt,
    required this.durationInMinutes, // Tambahkan parameter durationInMinutes pada konstruktor
  });

  // Method factory untuk membuat ActivityTrackerModel dari Map
  factory ActivityTrackerModel.fromMap(Map<String, dynamic> json) =>
      ActivityTrackerModel(
        activityId: json["activityId"],
        userId: json["userId"],
        activityName: json["activityName"],
        activityDescription: json["activityDescription"],
        createdAt: json["createdAt"],
        durationInMinutes:
            json["durationInMinutes"], // Mendapatkan durationInMinutes dari Map
      );

  // Method untuk mengonversi ActivityTrackerModel menjadi Map
  Map<String, dynamic> toMap() => {
        "activityId": activityId,
        "userId": userId,
        "activityName": activityName,
        "activityDescription": activityDescription,
        "createdAt": createdAt,
        "durationInMinutes":
            durationInMinutes, // Menambahkan durationInMinutes ke dalam Map
      };

  // Getter untuk mengambil jumlah kegiatan
  int get activityCount => activityId ?? 0;
}
