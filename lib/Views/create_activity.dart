import 'package:flutter/material.dart';
import 'package:catetin/JsonModels/activity_tracker_model.dart'; // Ubah impor menjadi activity_tracker_model.dart
import 'package:catetin/SQLite/sqlite.dart'; // Perbarui impor ke DatabaseHelper

class CreateActivity extends StatefulWidget {
  const CreateActivity({Key? key}) : super(key: key);

  @override
  State<CreateActivity> createState() => _CreateActivityState();
}

class _CreateActivityState extends State<CreateActivity> {
  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final durationController =
      TextEditingController(); // Tambahkan controller untuk durasi aktivitas
  final formKey = GlobalKey<FormState>();

  final db = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Activity"),
        actions: [
          IconButton(
            onPressed: () {
              if (formKey.currentState!.validate()) {
                db
                    .createActivity(
                  ActivityTrackerModel(
                    activityName: nameController.text,
                    activityDescription: descriptionController.text,
                    createdAt: DateTime.now().toIso8601String(),
                    durationInMinutes: int.parse(durationController
                        .text), // Ambil nilai durasi dari input dan konversi ke integer
                  ),
                )
                    .whenComplete(() {
                  Navigator.of(context).pop(true);
                });
              }
            },
            icon: const Icon(Icons.check),
          )
        ],
      ),
      body: Form(
        key: formKey,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              TextFormField(
                controller: nameController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Name is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Name",
                ),
              ),
              TextFormField(
                controller: descriptionController,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Description is required";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Description",
                ),
              ),
              TextFormField(
                controller: durationController,
                keyboardType: TextInputType
                    .number, // Tipe keyboard untuk memasukkan angka
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Duration is required";
                  }
                  if (int.tryParse(value) == null) {
                    return "Invalid duration"; // Validasi jika durasi tidak valid
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  labelText: "Duration (minutes)",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
