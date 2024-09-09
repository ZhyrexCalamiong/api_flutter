class Student {
  final int id;
  final String firstName;
  final String lastName;
  final String course;
  final String year;
  final bool enrolled;

  Student({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.course,
    required this.year,
    required this.enrolled,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      course: json['course'],
      year: json['year'],
      enrolled: json['enrolled'] == 1 ? true : false, // Convert to boolean if needed
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'course': course,
      'year': year,
      'enrolled': enrolled ? 1 : 0, // Convert boolean to integer if needed
    };
  }
}
