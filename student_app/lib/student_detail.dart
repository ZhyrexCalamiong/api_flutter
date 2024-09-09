import 'package:flutter/material.dart';
import 'models/student.dart';
import 'services/studentsser.dart';

class StudentDetailScreen extends StatefulWidget {
  final int studentId;

  StudentDetailScreen({required this.studentId});

  @override
  _StudentDetailScreenState createState() => _StudentDetailScreenState();
}

class _StudentDetailScreenState extends State<StudentDetailScreen> {
  final StudentService api = StudentService();
  late Future<Student> futureStudent;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;
  String selectedCourse = 'BSIT';
  String selectedYear = 'First Year';
  bool enrolled = false;

  @override
  void initState() {
    super.initState();
    futureStudent = api.getStudentById(widget.studentId);
    futureStudent.then((student) {
      firstNameController = TextEditingController(text: student.firstName);
      lastNameController = TextEditingController(text: student.lastName);
      selectedCourse = student.course;
      selectedYear = student.year;
      enrolled = student.enrolled;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Student Details'),
      ),
      body: FutureBuilder<Student>(
        future: futureStudent,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    TextFormField(
                      controller: firstNameController,
                      decoration: InputDecoration(labelText: 'First Name'),
                      validator: (value) => value!.isEmpty ? 'Please enter a first name' : null,
                    ),
                    TextFormField(
                      controller: lastNameController,
                      decoration: InputDecoration(labelText: 'Last Name'),
                      validator: (value) => value!.isEmpty ? 'Please enter a last name' : null,
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedCourse,
                      items: [
                        'BSIT',
                        'EDUC',
                        'ACCOUNTANCY',
                        'CRIM',
                        'ENGR',
                      ].map((course) => DropdownMenuItem(value: course, child: Text(course))).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCourse = value!;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Course'),
                    ),
                    DropdownButtonFormField<String>(
                      value: selectedYear,
                      items: [
                        '1st Year',
                        '2nd Year',
                        '3rd Year',
                        '4th Year',
                      ].map((year) => DropdownMenuItem(value: year, child: Text(year))).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedYear = value!;
                        });
                      },
                      decoration: InputDecoration(labelText: 'Year'),
                    ),
                    SwitchListTile(
                      title: Text('Enrolled'),
                      value: enrolled,
                      onChanged: (bool value) {
                        setState(() {
                          enrolled = value;
                        });
                      },
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              api.updateStudent(widget.studentId, {
                                'firstName': firstNameController.text,
                                'lastName': lastNameController.text,
                                'course': selectedCourse,
                                'year': selectedYear,
                                'enrolled': enrolled,
                              }).then((response) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Student updated')));
                                Navigator.pop(context);
                              }).catchError((error) {
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to update student')));
                              });
                            }
                          },
                          child: Text('Update'),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            api.deleteStudent(widget.studentId).then((response) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Student deleted')));
                              Navigator.pop(context);
                            }).catchError((error) {
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to delete student')));
                            });
                          },
                          child: Text('Delete'),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          }
          return Center(child: Text('No student data found'));
        },
      ),
    );
  }
}
