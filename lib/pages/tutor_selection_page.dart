import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:course_correct/main.dart';
import 'package:course_correct/models/courses_models.dart';
import 'package:course_correct/models/user_model.dart';
import 'package:course_correct/pages/tutors_homepage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:multi_select_flutter/util/multi_select_item.dart';

class TutorAvailabilityPage extends StatefulWidget {
  @override
  _TutorAvailabilityPageState createState() => _TutorAvailabilityPageState();
}

class _TutorAvailabilityPageState extends State<TutorAvailabilityPage> {
  final Map<String, bool> selectedSubjects = {};
  final Map<String, bool> selectedDays = {
    'Monday': false,
    'Tuesday': false,
    'Wednesday': false,
    'Thursday': false,
    'Friday': false,
    'Saturday': false,
    'Sunday': false,
  };

  TimeOfDay? startTime;
  TimeOfDay? endTime;

  Future<void> _selectTime(BuildContext context, bool isStartTime) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStartTime) {
          startTime = picked;
        } else {
          endTime = picked;
        }
      });
    }
  }

  Future<void> submitTutorInfo() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        // Fetch the current data
        DocumentSnapshot doc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();
        Map<String, dynamic> existingData = doc.data() as Map<String, dynamic>;

        // Prepare the new data to be merged
        Map<String, dynamic> newData = {
          'role': 'tutor',
          'subjects': selectedSubjects.keys
              .where((key) => selectedSubjects[key] == true)
              .toList(),
          'days': selectedDays.keys
              .where((key) => selectedDays[key] == true)
              .toList(),
          'startTime': startTime != null ? startTime!.format(context) : '',
          'endTime': endTime != null ? endTime!.format(context) : '',
        };

        // Merge existing data with new data
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          ...existingData,
          ...newData,
        }, SetOptions(merge: true));
        appState.setUserProfile(UserModel(
          name: existingData['name'],
          role: 'tutor',
        ));
      } catch (e) {
        appState.snackBarMessage(e.toString(), context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Tutor Availability'),
      ),
      body: const Topics(),
      //Padding(
      //     padding: const EdgeInsets.all(16.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: <Widget>[
      //         const Text(
      //           'Select Subjects You Want to Teach',
      //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //         ),
      //         Expanded(
      //           child: FutureBuilder<List<CoursesModel>>(
      //             future: fetchCourses(
      //                 FirebaseFirestore.instance.collection("Courses ")),
      //             builder: (context, snapshot) {
      //               if (snapshot.connectionState == ConnectionState.waiting) {
      //                 return const Center(
      //                   child: CircularProgressIndicator(),
      //                 );
      //               } else if (snapshot.hasError) {
      //                 return Center(
      //                   child: Text('Error: ${snapshot.error}'),
      //                 );
      //               } else if (snapshot.hasData) {
      //                 final courses = snapshot.data!;
      //                 return ListView(
      //                   children: courses.map((course) {
      //                     return CheckboxListTile(
      //                       title: Text(course.name),
      //                       value: selectedSubjects[course.name] ?? false,
      //                       onChanged: (bool? value) {
      //                         setState(() {
      //                           selectedSubjects[course.name] = value ?? false;
      //                         });
      //                       },
      //                     );
      //                   }).toList(),
      //                 );
      //               } else {
      //                 return const Center(
      //                   child: Text('No subjects available'),
      //                 );
      //               }
      //             },
      //           ),
      //         ),
      //         const SizedBox(height: 20),
      //         const Text(
      //           'Select Your Available Days',
      //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //         ),
      //         Expanded(
      //           child: ListView(
      //             children: selectedDays.keys.map((day) {
      //               return Card(
      //                 shape: RoundedRectangleBorder(
      //                   borderRadius: BorderRadius.circular(15),
      //                 ),
      //                 elevation: 5,
      //                 margin: const EdgeInsets.symmetric(vertical: 8),
      //                 child: CheckboxListTile(
      //                   title: Text(day),
      //                   value: selectedDays[day],
      //                   onChanged: (bool? value) {
      //                     setState(() {
      //                       selectedDays[day] = value ?? false;
      //                     });
      //                   },
      //                 ),
      //               );
      //             }).toList(),
      //           ),
      //         ),
      //         const SizedBox(height: 20),
      //         const Text(
      //           'Select Your Available Hours',
      //           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      //         ),
      //         Card(
      //           shape: RoundedRectangleBorder(
      //             borderRadius: BorderRadius.circular(15),
      //           ),
      //           elevation: 5,
      //           child: Padding(
      //             padding: const EdgeInsets.all(16.0),
      //             child: Row(
      //               children: <Widget>[
      //                 TextButton(
      //                   onPressed: () => _selectTime(context, true),
      //                   child: Text(startTime == null
      //                       ? 'Start Time'
      //                       : startTime!.format(context)),
      //                 ),
      //                 const Text(' to '),
      //                 TextButton(
      //                   onPressed: () => _selectTime(context, false),
      //                   child: Text(endTime == null
      //                       ? 'End Time'
      //                       : endTime!.format(context)),
      //                 ),
      //               ],
      //             ),
      //           ),
      //         ),
      //         const SizedBox(height: 20),
      //         Center(
      //           child: ElevatedButton(
      //             onPressed: () async {
      //               await submitTutorInfo();
      //               Navigator.pushAndRemoveUntil(
      //                 context,
      //                 MaterialPageRoute(
      //                   builder: (context) => const TutorHomepage(),
      //                 ),
      //                 (route) => false,
      //               );
      //             },
      //             child: const Text('Submit'),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
    );
  }
}

//new page widgets
class Topics extends StatelessWidget {
  const Topics({super.key});

  @override
  Widget build(BuildContext context) {
    final courseName = appState.courseName;
    return CoursesBuilder(
      future: getCourses(),
      next: SubTopics(name:courseName),
      isSub: false,
      name: courseName,
    );
  }
}

class SubTopics extends StatelessWidget {
  final String? name;
  const SubTopics({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return CoursesBuilder(
      future: fetchSubs(name),
      next: const DaysOfTheWeek(),
      isSub: true,
    );
  }
}

Future<List<CoursesModel>> fetchCourses(dbRef) async {
  try {
    var snap = await dbRef.get();
    return CoursesModel.listFromFirestore(snap);
  } catch (e) {
    //print("Error fetching courses: $e");
    return [];
  }
}

Future<List<CoursesModel>> getCourses() async {
  return await fetchCourses(FirebaseFirestore.instance.collection("Courses "));
}

Future<List<CoursesModel>> fetchSubs(String? name) {
  return fetchCourses(FirebaseFirestore.instance
      .collection("Courses ")
      .doc(name)
      .collection("subs"));
}

class CoursesBuilder extends StatelessWidget {
  final Future<Object?>? future;
  final Widget? next;
  final bool? isSub;
  final String? name;
  const CoursesBuilder({super.key, this.future, this.next, this.isSub, this.name});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final data = snapshot.data as List<CoursesModel>;
          //change data to checklist items
          final listItems = data
              .map((e) => CheckListCard(title: Text(e.name), value: e.name))
              .toList();
          return Center(
            child: Card(
              elevation: 3,
              child: SizedBox(
                height: 400,
                child: MultiSelectCheckList(
                    maxSelectableCount: 1,
                    items: listItems,
                    onChange: (allSelected, selectedItem) {
                      //do something with the selected item
                      //appState.setCourseName(selectedItem);
                      if (next != null) {
                        if (isSub == true) {
                          //appState.setCourseName(selectedItem);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => next!),
                          );
                        } else {
                          //appState.setCourseName(selectedItem);
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SubTopics(name: name)),
                          );
                        }
                      }
                    }),
              ),
            ),
          );
        });
  }
}

class DaysOfTheWeek extends StatelessWidget {
  const DaysOfTheWeek({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          elevation: 3,
          child: SizedBox(
            height: 600,
            child: Column(
              children: [
                MultiSelectCheckList(
                  maxSelectableCount: 6,
                  items: [
                    CheckListCard(title: const Text('Monday'), value: 'Monday'),
                    CheckListCard(
                        title: const Text('Tuesday'), value: 'Tuesday'),
                    CheckListCard(
                        title: const Text('Wednesday'), value: 'Wednesday'),
                    CheckListCard(
                        title: const Text('Thursday'), value: 'Thursday'),
                    CheckListCard(title: const Text('Friday'), value: 'Friday'),
                    CheckListCard(
                        title: const Text('Saturday'), value: 'Saturday'),
                  ],
                  onChange: (allSelected, selectedItem) {
                    //do something with the selected item
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to next page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const TimeSelection()),
                    );
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          )),
    );
  }
}

class TimeSelection extends StatelessWidget {
  const TimeSelection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
          elevation: 3,
          child: SizedBox(
            height: 200,
            width: 200,
            child: Column(
              children: [
                TextButton(
                  onPressed: () {
                    // Select start time
                  },
                  child: const Text('Start Time'),
                ),
                const Text(' to '),
                TextButton(
                  onPressed: () {
                    // Select end time
                  },
                  child: const Text('End Time'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to next page
                  },
                  child: const Text('Next'),
                ),
              ],
            ),
          )),
    );
  }
}
