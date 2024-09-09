import 'package:flutter/material.dart';
import 'createstudents.dart';
import 'services/studentsser.dart';
import 'models/student.dart';
import 'student_detail.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Student App',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final StudentService api = StudentService();
  late Future<List<Student>> futureStudents;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  void _loadStudents() {
    setState(() {
      futureStudents = api.getStudents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student List'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CreateStudentScreen()),
              ).then((_) {
                _loadStudents(); // Refresh the list after adding a new student
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<Student>>(
              future: futureStudents,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('No students found.'));
                } else {
                  List<Student> students = snapshot.data!;
                  return ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, index) {
                      Student student = students[index];
                      return Card(
                        child: ListTile(
                          title: Text('${student.firstName} ${student.lastName}'),
                          subtitle: Text('${student.course}, ${student.year}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => StudentDetailScreen(studentId: student.id),
                              ),
                            ).then((_) {
                              _loadStudents(); // Refresh the list after returning from details screen
                            });
                          },
                        ),
                      );
                    },
                  );
                }
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateStudentScreen()),
                ).then((_) {
                  _loadStudents(); // Refresh the list after adding a new student
                });
              },
              child: Text('Add New Student'),
            ),
          ),
        ],
      ),
    );
  }
}
