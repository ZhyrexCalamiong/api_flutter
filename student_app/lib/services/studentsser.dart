import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/student.dart';

class StudentService {
  final String baseUrl = 'http://localhost:3000';

  // Fetch all students
  Future<List<Student>> getStudents() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/students'));

      if (response.statusCode == 200) {
        List<dynamic> body = jsonDecode(response.body);
        return body.map((dynamic item) => Student.fromJson(item)).toList();
      } else {
        throw Exception('Failed to load students. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load students: $e');
    }
  }

  // Fetch a single student by ID
  Future<Student> getStudentById(int id) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/students/$id'));

      if (response.statusCode == 200) {
        return Student.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to load student with ID $id. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to load student: $e');
    }
  }

  // Create a new student
  Future<void> createStudent(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/students'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to create student. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to create student: $e');
    }
  }

  // Update an existing student
  Future<void> updateStudent(int id, Map<String, dynamic> data) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/students/$id'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to update student with ID $id. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to update student: $e');
    }
  }

  // Delete a student
  Future<void> deleteStudent(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/api/students/$id'));

      if (response.statusCode != 204) {
        throw Exception('Failed to delete student with ID $id. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Failed to delete student: $e');
    }
  }
}
