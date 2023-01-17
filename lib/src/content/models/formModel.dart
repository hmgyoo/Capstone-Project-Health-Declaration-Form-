class FormModel {
  // form fields to fill
  final String agreeToPrivacy;
  final String beenSick;
  final String date;
  final String hasContact;
  final String haveSymptoms;
  final String email;

  FormModel({
    required this.agreeToPrivacy,
    required this.beenSick,
    required this.date,
    required this.hasContact,
    required this.haveSymptoms,
    required this.email,
  });

  // to convert into json format
  Map<String, dynamic> toJson() => {
        'agree_to_privacy': agreeToPrivacy,
        'been_sick': beenSick,
        'date': date,
        'has_contact': hasContact,
        'have_symptoms': haveSymptoms,
        'email': email,
      };

  // to read from json format
  static FormModel fromJson(Map<String, dynamic> json) => FormModel(
        agreeToPrivacy: json['agree_to_privacy'],
        beenSick: json['been_sick'],
        date: json['date'],
        hasContact: json['has_contact'],
        haveSymptoms: json['have_symptoms'],
        email: json['email'],
      );
}
