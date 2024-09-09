import 'package:flutter/material.dart';
import 'services/studentsser.dart';

class CreateStudentScreen extends StatefulWidget {
  @override
  _CreateStudentScreenState createState() => _CreateStudentScreenState();
}

class _CreateStudentScreenState extends State<CreateStudentScreen> {
  final StudentService api = StudentService();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  String selectedCourse = 'BSIT';
  String selectedYear = '1st Year';
  bool enrolled = false;

  @override
  void dispose() {
    // Dispose of the controllers when the widget is removed from the widget tree
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(  // Added SingleChildScrollView for better handling of smaller screens
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
                    'ENGR'
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
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _submitForm();
                    }
                  },
                  child: Text('Create'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    api.createStudent({
      'firstName': firstNameController.text,
      'lastName': lastNameController.text,
      'course': selectedCourse,
      'year': selectedYear,
      'enrolled': enrolled,
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Student created')));
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to create student')));
    });
  }
}
