import 'package:capstone_proj/src/const/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  // define variables first
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  // global key
  final _formKey = GlobalKey<FormState>();

  // other variables
  late DateTime _scheduledDateTime;
  late TimeOfDay _scheduledTime;
  late TextEditingController _descriptionController;

  // init state
  @override
  void initState() {
    super.initState();
    initializeNotifications();
    _descriptionController = TextEditingController();
    _scheduledDateTime = DateTime.now();
    _scheduledTime = TimeOfDay.now();
  }

  void initializeNotifications() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  // notify based on scheduled time
  Future<void> _showNotifications() async {
    // create the time which the notification will show based on user input
    var scheduledNotificationDateTime = _scheduledDateTime
        .add(Duration(hours: _scheduledTime.hour))
        .add(Duration(minutes: _scheduledTime.minute));
    // android platform specifics
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    // Schedule the notification
    flutterLocalNotificationsPlugin.schedule(
      0,
      'Health Declaration Form',
      _descriptionController.text,
      scheduledNotificationDateTime,
      platformChannelSpecifics,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // text form field that determines the body of the notification
            TextFormField(
              controller: _descriptionController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a description';
                }
                return null;
              },
              decoration: const InputDecoration(
                labelText: 'Description',
                focusColor: Colors.white,
                fillColor: Colors.grey,
              ),
              style: const TextStyle(color: Colors.white),
            ),

            // used sized box to space out elements
            const SizedBox(height: 20),

            // date picker to set date
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
              ),
              onPressed: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      _scheduledDateTime = value;
                    });
                  }
                });
              },
              child: Text(
                _scheduledTime == null
                    ? 'Set Time'
                    : DateFormat.yMd().format(_scheduledDateTime),
              ),
            ),

            const SizedBox(height: 20),

            // set the reminder to show on specified date
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: accentColor,
              ),
              onPressed: () {
                _showNotifications();
              },
              child: const Text('Set reminder'),
            ),
          ],
        ),
      ),
    );
  }
}
