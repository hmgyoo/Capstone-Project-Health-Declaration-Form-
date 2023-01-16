// import 'package:flutter/material.dart';
// import 'package:mailer/mailer.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'dart:async';

// class SendEmailSchedPage extends StatefulWidget {
//   @override
//   _SendEmailSchedPageState createState() => _SendEmailSchedPageState();
// }

// class _SendEmailSchedPageState extends State<SendEmailSchedPage> {
//   // define variables
//   final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
//   late String _email;
//   late String _subject;
//   late String _body;
//   late String _notificationTitle;
//   late String _notificationBody;
//   DateTime _selectedDate = DateTime.now();
//   TimeOfDay _selectedTime = TimeOfDay.now();
//   FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();
//   late AndroidInitializationSettings androidInitializationSettings;
//   late InitializationSettings initializationSettings;

//   // select date function
//   Future<Null> _selectDate(BuildContext context) async {
//     final DateTime? picked = await showDatePicker(
//         context: context,
//         initialDate: _selectedDate,
//         firstDate: DateTime(2015, 8),
//         lastDate: DateTime(2101));
//     if (picked != null && picked != _selectedDate) {
//       setState(() {
//         _selectedDate = picked;
//       });
//     }
//   }

//   // select time function
//   Future<Null> _selectTime(BuildContext context) async {
//     final TimeOfDay? picked =
//         await showTimePicker(context: context, initialTime: _selectedTime);
//     if (picked != null && picked != _selectedTime) {
//       setState(() {
//         _selectedTime = picked;
//       });
//     }
//   }

//   // schedule email notification function
//   void _scheduleEmailNotification() {
//     final scheduledEmailDateTime = DateTime(
//         _selectedDate.year,
//         _selectedDate.month,
//         _selectedDate.day,
//         _selectedTime.hour,
//         _selectedTime.minute);

//     final difference = scheduledEmailDateTime.difference(DateTime.now());

//     Timer(difference, _sendEmailAndNotification);
//   }

//   void _sendEmailAndNotification() {
//     _sendEmail();
//     _showNotification();
//   }

//   void _sendEmail() {
//     final MailOptions mailOptions = MailOptions(
//       body: _body,
//       subject: _subject,
//       recipients: [_email],
//     );
//   }

//   FlutterMailer.send(mailOptions);

//     void _showNotification() async {
//       await _initializeNotificationPlugin();

//       var platformChannelSpecifics = const NotificationDetails();
//       await flutterLocalNotificationsPlugin.show(
//         0,
//         _notificationTitle,
//         _notificationBody,
//         platformChannelSpecifics,
//       );
//     }
// }
