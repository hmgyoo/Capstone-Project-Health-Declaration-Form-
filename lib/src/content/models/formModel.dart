class FormModel {
  // form fields to fill
  final String agreeToPrivacy;
  final String beenSick;
  final String date;
  final String firstName;
  final String hasContact;
  final String haveSymptoms;
  final String lastName;
  final String email;
  final String studentId;

  FormModel({
    required this.agreeToPrivacy,
    required this.beenSick,
    required this.date,
    required this.firstName,
    required this.hasContact,
    required this.haveSymptoms,
    required this.lastName,
    required this.email,
    required this.studentId,
  });

  // to convert into json format
  Map<String, dynamic> toJson() => {
        'agree_to_privacy': agreeToPrivacy,
        'been_sick': beenSick,
        'date': date,
        'first_name': firstName,
        'has_contact': hasContact,
        'have_symptoms': haveSymptoms,
        'last_name': lastName,
        'email': email,
        'student_id': studentId,
      };

  // to read from json format
  static FormModel fromJson(Map<String, dynamic> json) => FormModel(
        agreeToPrivacy: json['agree_to_privacy'],
        beenSick: json['been_sick'],
        date: json['date'],
        firstName: json['first_name'],
        hasContact: json['has_contact'],
        haveSymptoms: json['have_symptoms'],
        lastName: json['last_name'],
        email: json['email'],
        studentId: json['student_id'],
      );
}
