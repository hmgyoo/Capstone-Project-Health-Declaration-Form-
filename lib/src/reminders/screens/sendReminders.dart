import 'dart:convert';

import 'package:capstone_proj/src/const/const.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_sms/flutter_sms.dart';
import 'package:http/http.dart' as http;

class SendRemindersPage extends StatefulWidget {
  const SendRemindersPage({super.key});

  @override
  State<SendRemindersPage> createState() => _SendRemindersPageState();
}

class _SendRemindersPageState extends State<SendRemindersPage> {
  // defined the variables to be used
  // defined flutter local push notifications
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // defined firebase messaging
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;

  // define formkey to be used in the text form fields
  final _formKey = GlobalKey<FormState>();

  //defined other variables
  late DateTime _scheduledDateTime;
  late TimeOfDay _scheduledTime;
  late TextEditingController _descriptionController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;

  // get email
  final user = FirebaseAuth.instance.currentUser;

  // reminder info
  String header = 'Health Declaration Application - PLM';
  String message =
      'Remember to fill up the health declaration form before attending classes to ensure safety and health.';
  List<String> recipients = ['+639487934901'];

  // init state function
  void initState() {
    super.initState();
    initializeNotifications();
    _scheduledDateTime = DateTime.now();
    _scheduledTime = TimeOfDay.now();
    _descriptionController = TextEditingController();
    _emailController = TextEditingController();
    _phoneController = TextEditingController();
  }

  // intialize the notifcation that will be sent as push notifications
  void initializeNotifications() {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // to show the notification in the notification shade
  Future<void> _showNotification() async {
    var scheduledNotificationDateTime = _scheduledDateTime
        .add(Duration(hours: _scheduledTime.hour))
        .add(Duration(minutes: _scheduledTime.minute));
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    // wait for the scheduled notification to launch
    await flutterLocalNotificationsPlugin.schedule(
      0,
      header,
      message,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );

    firebaseMessaging.subscribeToTopic('reminders');
    await firebaseMessaging.getToken().then((token) {
      print('Push notification token: $token');
    });

    // send an sms message
    var smsApiKey = 'aa598aee';
    var smsApiSecret = '4bFplYDujPGxHKzl';
    var phoneNumber = '639487934901';

    var response = await http.post(
      Uri.parse('https://rest.nexmo.com/sms/json"'),
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Authorization': '$smsApiKey:$smsApiSecret',
      },
      body: {
        'to': _phoneController.text,
        'text': message,
        'from': 'Health Declaration Form PLM'
      },
    );

    // print the message in the console to ensure it is send successfully
    print(response.body);

    // send an email
    String emailApiKey =
        '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';
    String? sendToEmail = user!.email;

    await http.post(
      Uri.parse('https://api.sendinblue.com/v3.0/email'),
      headers: {
        'api-key': emailApiKey,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'to': [
          {'email': _emailController.text}
        ],
        'subject': header,
        'htmlContent': message,
        'sender': {
          'name': 'Gary Daniel Erno',
          'email': 'ernogarydaniel@gmail.com',
        },
      }),
    );

    // print the message in the console to ensure it is send successfully
    print(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter an email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(labelText: 'Phone number'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(
                height: 40,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2020),
                      lastDate: DateTime(2050),
                    ).then((date) {
                      if (date != null) {
                        setState(() {
                          _scheduledDateTime = date;
                        });
                      }
                    });
                  }
                },
                child: const Text('Choose date'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                    ).then((time) {
                      if (time != null) {
                        setState(() {
                          _scheduledTime = time;
                        });
                      }
                    });
                  }
                },
                child: const Text('Choose time'),
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    _showNotification();
                  }
                },
                child: const Text('Set Reminder'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
