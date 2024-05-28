// Mengimpor paket-paket yang diperlukan untuk mengembangkan aplikasi Flutter
import 'package:flutter/material.dart'; // Paket flutter material untuk membangun UI
import 'package:intl/intl.dart'; // Paket untuk memformat tanggal
import 'package:catetin/Authtentication/login.dart'; // Mengimpor halaman login
import 'package:catetin/JsonModels/activity_tracker_model.dart'; // Mengimpor model kegiatan
import 'package:catetin/SQLite/sqlite.dart'; // Mengimpor kelas DatabaseHelper
import 'package:catetin/Views/create_activity.dart'; // Mengimpor halaman tambah kegiatan
import 'package:charts_flutter/flutter.dart'
    as charts; // Paket untuk membuat grafik

// Kelas Activities adalah StatefulWidget yang menampilkan daftar kegiatan
class Activities extends StatefulWidget {
  const Activities({Key? key});

  @override
  State<Activities> createState() => _ActivitiesState();
}

// Kelas _ActivitiesState adalah State dari Activities yang menangani logika dan tampilan halaman Activities
class _ActivitiesState extends State<Activities> {
  late DatabaseHelper handler; // Instance dari DatabaseHelper
  late Future<List<ActivityTrackerModel>>
      activities; // Future untuk menampung daftar kegiatan
  final db = DatabaseHelper(); // Instance DatabaseHelper

  final nameController =
      TextEditingController(); // Controller untuk nama kegiatan
  final descriptionController =
      TextEditingController(); // Controller untuk deskripsi kegiatan
  final durationController =
      TextEditingController(); // Controller untuk durasi kegiatan
  final keyword =
      TextEditingController(); // Controller untuk kata kunci pencarian

  DateTime selectedDate = DateTime.now(); // Tanggal yang dipilih untuk filter
  DateTime startDate = DateTime.now(); // Tanggal awal rentang filter
  DateTime endDate = DateTime.now(); // Tanggal akhir rentang filter

  bool isDateFilterVisible =
      false; // Status visibility filter berdasarkan tanggal
  bool isChartVisible = false; // Status visibility grafik kegiatan

  @override
  void initState() {
    handler = DatabaseHelper(); // Menginisialisasi handler
    activities =
        handler.getActivities(selectedDate); // Mengambil daftar kegiatan
    // Inisialisasi database ketika halaman pertama kali dibuat
    handler.initDB().whenComplete(() {
      setState(() {
        activities = getAllActivities();
      });
    });
    super.initState();
  }

  // Method untuk mengambil semua kegiatan
  Future<List<ActivityTrackerModel>> getAllActivities() {
    return handler.getActivities(selectedDate);
  }

  // Method untuk mencari kegiatan berdasarkan kata kunci
  Future<List<ActivityTrackerModel>> searchActivity() {
    return handler.searchActivities(keyword.text);
  }

  // Method untuk mengambil kegiatan dalam rentang tanggal tertentu
  Future<List<ActivityTrackerModel>> getActivitiesInRange(
      DateTime startDate, DateTime endDate) {
    return handler.getActivitiesInRange(startDate, endDate);
  }

  // Method untuk merefresh daftar kegiatan
  Future<void> _refresh() async {
    setState(() {
      activities = getAllActivities();
    });
  }

  // Method untuk logout dari aplikasi
  void logout() async {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
      (Route<dynamic> route) => false,
    );
  }

  // Method untuk membuat data sampel untuk grafik
  List<charts.Series<ActivityTrackerModel, String>> _createSampleData(
    List<ActivityTrackerModel> activities,
  ) {
    final List<ActivityTrackerModel> data = [...activities];
    return [
      charts.Series<ActivityTrackerModel, String>(
        id: 'Activities',
        colorFn: (_, __) =>
            charts.ColorUtil.fromDartColor(Color.fromRGBO(60, 42, 33, 1)),
        domainFn: (ActivityTrackerModel activity, _) => activity.activityName,
        measureFn: (ActivityTrackerModel activity, _) =>
            activity.durationInMinutes!,
        data: data,
      )
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // AppBar
        title: const Text(
          "Activities",
          style: TextStyle(color: Color.fromRGBO(60, 42, 33, 1)),
        ),
        automaticallyImplyLeading: false,
        actions: [
          // Tombol Refresh
          IconButton(
            icon: Icon(Icons.refresh, color: Color.fromRGBO(60, 42, 33, 1)),
            onPressed: () {
              setState(() {
                startDate = DateTime.now();
                endDate = DateTime.now();
                activities = getAllActivities();
              });
            },
          ),
          // Tombol Logout
          IconButton(
            icon: const Icon(Icons.exit_to_app,
                color: Color.fromRGBO(60, 42, 33, 1)),
            onPressed: () {
              logout();
            },
          ),
        ],
        backgroundColor: Colors.white,
      ),
      // Bottom Navigation Bar
      bottomNavigationBar: Container(
        height: 73,
        decoration: BoxDecoration(
          color: Color.fromRGBO(229, 229, 203, 1),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Tombol Tampilkan Grafik
            IconButton(
              onPressed: () {
                setState(() {
                  isChartVisible = !isChartVisible;
                });
              },
              icon: Icon(
                isChartVisible ? Icons.bar_chart : Icons.bar_chart,
                color: Color.fromRGBO(60, 42, 33, 1),
              ),
            ),
            // Tombol Tambah Data
            Container(
              padding: EdgeInsets.symmetric(horizontal: 50),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color.fromRGBO(60, 42, 33, 1),
              ),
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CreateActivity(),
                    ),
                  ).then((value) {
                    if (value) {
                      _refresh();
                    }
                  });
                },
                child: Text(
                  'Add Data',
                  style: TextStyle(
                    color: Color.fromRGBO(229, 229, 203, 1),
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            // Tombol Filter Berdasarkan Tanggal
            IconButton(
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: selectedDate,
                  firstDate: DateTime(DateTime.now().year - 1),
                  lastDate: DateTime(DateTime.now().year + 1),
                ).then((pickedDate) {
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                      activities = getAllActivities();
                    });
                  }
                });
              },
              icon: Icon(Icons.calendar_today,
                  color: Color.fromRGBO(60, 42, 33, 1)),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Baris Pencarian
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  margin: const EdgeInsets.only(right: 5.0, left: 15.0),
                  decoration: BoxDecoration(
                      color: Color.fromRGBO(229, 229, 203, 1),
                      borderRadius: BorderRadius.circular(8)),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: keyword,
                          onChanged: (value) {
                            if (value.isNotEmpty) {
                              setState(() {
                                activities = searchActivity();
                              });
                            } else {
                              setState(() {
                                activities = getAllActivities();
                              });
                            }
                          },
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(Icons.search,
                                  color: Color.fromRGBO(60, 42, 33, 1)),
                              hintText: "Search"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                margin: const EdgeInsets.only(left: 5.0, right: 15.0),
                decoration: BoxDecoration(
                    color: Color.fromRGBO(229, 229, 203, 1),
                    borderRadius: BorderRadius.circular(8)),
                child: IconButton(
                  onPressed: () {
                    setState(() {
                      isDateFilterVisible = !isDateFilterVisible;
                    });
                  },
                  icon: Icon(
                    isDateFilterVisible
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color: Color.fromRGBO(60, 42, 33, 1),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          // Widget untuk Filter Berdasarkan Tanggal
          Visibility(
            visible: isDateFilterVisible,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              margin: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                  color: Color.fromRGBO(229, 229, 203, 1),
                  borderRadius: BorderRadius.circular(8)),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: startDate,
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime(DateTime.now().year + 1),
                        ).then((pickedDate) {
                          if (pickedDate != null) {
                            setState(() {
                              startDate = pickedDate;
                            });
                          }
                        });
                      },
                      child: Text(
                        DateFormat.yMMMd().format(startDate),
                        style: TextStyle(
                            color: Color.fromRGBO(60, 42, 33, 1), fontSize: 14),
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        showDatePicker(
                          context: context,
                          initialDate: endDate,
                          firstDate: DateTime(DateTime.now().year - 1),
                          lastDate: DateTime(DateTime.now().year + 1),
                        ).then((pickedDate) {
                          if (pickedDate != null) {
                            setState(() {
                              endDate = pickedDate;
                            });
                          }
                        });
                      },
                      child: Text(
                        DateFormat.yMMMd().format(endDate),
                        style: TextStyle(
                            color: Color.fromRGBO(60, 42, 33, 1), fontSize: 14),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.filter_list_alt,
                        color: Color.fromRGBO(60, 42, 33, 1)),
                    onPressed: () {
                      setState(() {
                        activities = getActivitiesInRange(startDate, endDate);
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          // Widget untuk Menampilkan Daftar Kegiatan
          Expanded(
            child: FutureBuilder<List<ActivityTrackerModel>>(
              future: activities,
              builder: (BuildContext context,
                  AsyncSnapshot<List<ActivityTrackerModel>> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Menampilkan loading indicator jika masih dalam proses loading
                  return const CircularProgressIndicator();
                } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                  // Menampilkan pesan jika tidak ada data kegiatan
                  return const Center(child: Text("No data"));
                } else if (snapshot.hasError) {
                  // Menampilkan pesan jika terjadi error
                  return Text(snapshot.error.toString());
                } else {
                  // Menampilkan daftar kegiatan
                  final items = snapshot.data ?? <ActivityTrackerModel>[];
                  return Column(
                    children: [
                      // Widget untuk Grafik Kegiatan
                      Visibility(
                        visible: isChartVisible,
                        child: Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ActivityBarChart(
                              _createSampleData(items),
                              animate: true,
                            ),
                          ),
                        ),
                      ),
                      // Widget untuk Daftar Kegiatan
                      Expanded(
                        flex: 7,
                        child: ListView.builder(
                            itemCount: items.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Tanggal kegiatan
                                    Text(
                                      DateFormat("yMd").format(DateTime.parse(
                                          items[index].createdAt)),
                                    ),
                                    // Durasi kegiatan
                                    Text(
                                      "Duration: ${items[index].durationInMinutes} minutes",
                                      style: TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                                title: Text(
                                  items[index].activityName,
                                  style: TextStyle(
                                    color: Color.fromRGBO(60, 42, 33, 1),
                                  ),
                                ),
                                trailing: IconButton(
                                  // Tombol hapus kegiatan
                                  icon: const Icon(Icons.delete,
                                      color: Color.fromRGBO(60, 42, 33, 1)),
                                  onPressed: () {
                                    db
                                        .deleteActivity(
                                            items[index].activityId!)
                                        .whenComplete(() {
                                      _refresh();
                                    });
                                  },
                                ),
                                onTap: () {
                                  setState(() {
                                    nameController.text =
                                        items[index].activityName;
                                    descriptionController.text =
                                        items[index].activityDescription;
                                    durationController.text = items[index]
                                        .durationInMinutes!
                                        .toString();
                                  });
                                  // Menampilkan dialog untuk memperbarui kegiatan
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                        actions: [
                                          Row(
                                            children: [
                                              TextButton(
                                                onPressed: () {
                                                  db
                                                      .updateActivity(
                                                          nameController.text,
                                                          descriptionController
                                                              .text,
                                                          int.parse(
                                                              durationController
                                                                  .text),
                                                          items[index]
                                                              .activityId!)
                                                      .whenComplete(() {
                                                    _refresh();
                                                    Navigator.pop(context);
                                                  });
                                                },
                                                child: const Text("Update"),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text("Cancel"),
                                              ),
                                            ],
                                          ),
                                        ],
                                        title: const Text("Update activity"),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            // Input nama kegiatan
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
                                            // Input deskripsi kegiatan
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
                                            // Input durasi kegiatan
                                            TextFormField(
                                              controller: durationController,
                                              keyboardType:
                                                  TextInputType.number,
                                              validator: (value) {
                                                if (value!.isEmpty) {
                                                  return "Duration is required";
                                                }
                                                if (int.tryParse(value) ==
                                                    null) {
                                                  return "Invalid duration";
                                                }
                                                return null;
                                              },
                                              decoration: const InputDecoration(
                                                labelText: "Duration (minutes)",
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                },
                              );
                            }),
                      ),
                    ],
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Kelas ActivityBarChart adalah StatelessWidget yang menampilkan grafik kegiatan
class ActivityBarChart extends StatelessWidget {
  final List<charts.Series<ActivityTrackerModel, String>> seriesList;
  final bool animate;

  ActivityBarChart(this.seriesList, {required this.animate});

  @override
  Widget build(BuildContext context) {
    return charts.BarChart(
      seriesList,
      animate: animate,
      barGroupingType: charts.BarGroupingType.grouped,
    );
  }
}
