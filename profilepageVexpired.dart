import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:profil/Header_widget.dart';
import 'package:profil/time_buttons.dart';
import 'package:profil/biotablelist.dart';
import 'package:profil/calendar.dart';

class Profilepage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    const bcgcolor = Color.fromARGB(239, 245, 245, 245);
    const txtcolor = Colors.black;

    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).colorScheme.secondary,
            ]),
          ),
        ),
        backgroundColor: bcgcolor,
        leading: const BackButton(color: Colors.black),
        titleSpacing: -15,
        title: const Text(
          "Retour",
          style: TextStyle(color: txtcolor),
        ),
        elevation: 0,
      ),
      body: bodybio(
        h: h,
        w: w,
      ),
    );
  }
}

int itim = 100;
late DateTime iday;
int a = 5;
int b = 4;

class bodybio extends StatefulWidget {
  const bodybio({
    Key? key,
    required this.h,
    required this.w,
  }) : super(key: key);

  final double h;
  final double w;

  @override
  State<bodybio> createState() => _bodybioState();
}

class _bodybioState extends State<bodybio> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Stack(
        children: [
          Container(
            height: widget.h * 0.15,
            child: HeaderWidget(widget.h * 0.15, false, Icons.house_rounded),
          ),
          Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(25, 10, 25, 10),
            padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      border: Border.all(width: 5, color: Colors.white),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.black12,
                            blurRadius: 20,
                            offset: const Offset(5, 5)),
                      ]),
                  child: Icon(
                    Icons.person,
                    size: widget.h * 0.13,
                    color: Colors.grey.shade400,
                  ),
                ),
                SizedBox(
                  height: widget.h * 0.01,
                ),
                Text(
                  "Doctor's Name",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Calendar(),
                SizedBox(
                  height: widget.h * 0.03,
                ),
                TimeButtons(),
                SizedBox(
                  height: widget.h * 0.04,
                ),
                Container(
                  height: widget.h * 0.05,
                  width: widget.w * 0.60,
                  decoration: BoxDecoration(
                    //  color:Color.fromARGB(255, 51, 139, 255) ,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  //color: Color.fromARGB(255, 51, 139, 255),
                  child: TextButton(
                    style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith(
                            (states) => Colors.transparent.withOpacity(0.5)),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Color.fromARGB(255, 63, 146, 255)),
                        // overlayColor:MaterialStateProperty.all<Color>(Colors.grey  ),
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.white)),
                    onPressed: () async {
                      try {
                        if (itim == 77) {
                          throw Exception;
                        }
                        print(
                            'You have selected this $itim button \nYou have selected this $iday day');

                        _showMaterialDialog();
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      } catch (e) {
                        print('goddamn it select a time and a day idiot');
                        SnackBar snackBar = SnackBar(
                          backgroundColor: Colors.red.shade700,
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Please select a day and a time ',
                                style: TextStyle(fontSize: 17),
                              ),
                              Icon(
                                Icons.info_outline,
                                color: Colors.white,
                              ),
                            ],
                          ),
                          duration: Duration(seconds: 3),
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        );
                        ScaffoldMessenger.of(context).removeCurrentSnackBar();
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                    child: Text(
                      "Make An Appointement",
                      //style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  height: widget.h * 0.04,
                ),
                Container(
                  padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Know More About This Doctor",
                    style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                    textAlign: TextAlign.left,
                  ),
                ),
                BioTableList(),
                SizedBox(
                  height: widget.h * 0.06,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  makeAnAppointment() async {
    var notref = FirebaseFirestore.instance.collection('Appointments');
    var ref = FirebaseFirestore.instance.collection('doctors');

    List<int> timeSlotIndex = [];

    var resposne = await ref
        .doc('yzreO3TrzblximKsxdz2') //the doctor clicked uid
        .collection('day-month-year')
        .doc(iday.toString())
        .get();
    timeSlotIndex = resposne['timeindex'].cast<int>();

    timeSlotIndex[itim] = itim;

    await ref
        .doc('yzreO3TrzblximKsxdz2') //the doctor clicked uid
        .collection('day-month-year')
        .doc(iday.toString())
        .set({'timeindex': timeSlotIndex});

    await notref.add({
      'DoctorsName': 'dr Yassine Zelmati',
      'PatientName': 'Ahmed',
      'date': Timestamp.fromDate(dateToUpload),
      'doctorUID': 'yzreO3TrzblximKsxdz2',
      'patientUID': '43vju27PaOZptGuNQvDC',
    });
    itim = 77;
  }

  void _showMaterialDialog() {
    SnackBar snackBar = SnackBar(
      backgroundColor: Color.fromARGB(255, 88, 184, 115),
      content: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 5,
          ),
          Text(
            'Appointment succeeded ',
            style: TextStyle(fontSize: 17),
          ),
          Icon(
            Icons.check_circle_outline,
            color: Colors.white,
          ),
        ],
      ),
      duration: Duration(seconds: 3),
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    );
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text('Are You Sure ?'),
            content: Container(
              height: 248,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    horizontalTitleGap: 2,
                    leading: Icon(Icons.person_outline),
                    title: Text('Doctor'),
                    subtitle: Text('Dr Zelmati Yassine'),
                  ),
                  Divider(thickness: 2),
                  ListTile(
                    horizontalTitleGap: 2,
                    leading: Icon(Icons.category),
                    title: Text('Specialité'),
                    subtitle: Text('Cardiologue'),
                  ),
                  Divider(thickness: 2),
                  ListTile(
                    horizontalTitleGap: 2,
                    leading: Icon(Icons.calendar_month),
                    title: Text('Time'),
                    subtitle: Text(iday.toString()),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('Close')),
              TextButton(
                onPressed: () {
                  makeAnAppointment();
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                },
                child: Text('Confrim'),
              )
            ],
          );
        });
  }
}
