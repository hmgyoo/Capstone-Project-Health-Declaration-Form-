import 'package:capstone_proj/src/const/const.dart';
import 'package:capstone_proj/src/content/models/formModel.dart';
import 'package:capstone_proj/src/healthCheckUp/models/questionModel.dart';
import 'package:capstone_proj/src/healthCheckUp/widgets/nextButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../widgets/optionsWidget.dart';
import '../widgets/questionWidget.dart';
import '../widgets/resultBox.dart';

class HeaderForm extends StatefulWidget {
  const HeaderForm({super.key});

  @override
  State<HeaderForm> createState() => _HeaderFormState();
}

class _HeaderFormState extends State<HeaderForm> {
  // list of questions
  List<Question> _questions = [
    Question(
      id: '1',
      title:
          'I declare that the information I have given is true, correct, and complete. I understand that failure to answer any question or giving a false answer can be penalized according to the law.\nI also voluntarily and freely consent to the collection and sharing of the above information only in relation to PLM’s compliance to health and safety protocols under the guidelines and standards of the Inter-Agency Task Force for the Management of Emerging Infectious Diseases (IATF) and Republic Act 11332.',
      options: {'Yes': true, 'No': false},
    ),
    Question(
      id: '2',
      title: 'Have you been sick in the past 14 days?',
      options: {'Yes': false, 'No': true},
    ),
    Question(
      id: '3',
      title:
          'In the last 14 days, did you have any of the following : fever, coughs, colds, sore throat, loss of smell and taste, muscle pain, headache, or difficulty in breathing?',
      options: {'Yes': false, 'No': true},
    ),
    Question(
      id: '4',
      title:
          'In the last 14 days, have you been in close contact or exposed to any person suspected of or confirmed with Covid-19?',
      options: {'Yes': false, 'No': true},
    ),
  ];

  // index variable to cycle through the questions
  int index = 0;

  // check if the user has clicked the button before changing colors
  bool isPressed = false;

  // create list of responses
  List<String> responses = [];

  // create a new firebaseAuth user to compare to firestore data for storing form information
  final authUser = FirebaseAuth.instance.currentUser!;

  // change value of string depending on user answer
  String agreeToPrivacy = '';
  String beenSick = '';
  String hasContact = '';
  String haveSymptoms = '';

  // get bool based on selected option to determine answer
  bool answer = false;

  // get current date for forms
  static final DateTime now = DateTime.now();
  static final DateFormat formatter = DateFormat('yyyy-MM-dd');
  final String dateNow = formatter.format(now);

  // insert info from selected options into db
  Future insertAnswers() async {
    // get initial data from user
    String email = authUser.email!;

    final docUser = FirebaseFirestore.instance.collection('check_in').doc();

    FormModel form = FormModel(
      agreeToPrivacy: agreeToPrivacy,
      beenSick: beenSick,
      date: dateNow,
      firstName: '',
      hasContact: hasContact,
      haveSymptoms: haveSymptoms,
      lastName: '',
      email: email,
      studentId: '',
    );

    // convert into json
    final json = form.toJson();

    //insert into firebase
    await docUser.set(json);
  }

  // read data from db
  // yeah mahaba i know
  Stream<List<FormModel>> readForms() => FirebaseFirestore.instance
      .collection('check_in')
      .snapshots()
      .map((snapshot) =>
          snapshot.docs.map((doc) => FormModel.fromJson(doc.data())).toList());

  // function to display the next question
  void nextQuestion() {
    if (index == _questions.length - 1) {
      insertAnswers();
      showDialog(
          context: context, builder: (ctx) => ResultBox(onPressed: startOver));
    } else {
      if (isPressed) {
        for (int i = 0; i < _questions[index].options.length; i++) {
          _questions[index].options.values.toList()[i] ==
                  true // change the value of answer depending if the answer is true or false
              ? answer = true
              : answer = false;
        }

        // set state outside of index to not loop twice
        setState(() {
          index++; // rebuilds the app upon changing the index number for the question

          // for agree to privacy
          index == 0 && answer == true
              ? agreeToPrivacy = 'yes'
              : agreeToPrivacy = 'no';
          // for having been sick
          index == 1 && answer == true ? beenSick = 'no' : beenSick = 'yes';
          // for having symptoms
          index == 2 && answer == true
              ? haveSymptoms = 'no'
              : haveSymptoms = 'yes';
          // for having contact
          index == 3 && answer == true ? hasContact = 'no' : hasContact = 'yes';

          isPressed = false; // reset the selected options
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select an option first'),
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.symmetric(vertical: 20),
          ),
        );
      }
    }
  }

  // change the color when the user only taps the option
  void changeColor() {
    setState(() {
      isPressed = true;
    });
  }

  // start over and reset the quiz
  void startOver() {
    setState(() {
      index = 0;
      isPressed = false;
    });

    // pop the current widget
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            // insert the questions for the forms
            QuestionWidget(
              indexAction: index,
              question: _questions[index].title,
              totalQuestions: _questions.length,
            ),

            // divider
            Divider(color: Colors.grey.shade200, thickness: 2),

            // space options with questions with sizedbox
            const SizedBox(height: 25),

            // loop through the questions
            for (int i = 0; i < _questions[index].options.length; i++)
              OptionWidget(
                option: _questions[index].options.keys.toList()[i],
                color: isPressed
                    ? _questions[index].options.values.toList()[i] == true
                        ? kRecoveredColor
                        : kConfirmedColor
                    : kDeathColor,
                onTap: changeColor,
              ),
          ],
        ),
      ),

      // next question / see result button
      floatingActionButton: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: NextButton(
            nextQuestion:
                nextQuestion), // when tapping the button, this triggers the function above
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}
