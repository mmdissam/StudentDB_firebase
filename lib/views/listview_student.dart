import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:studentfirebase/models/student.dart';
import 'package:studentfirebase/views/student_info.dart';
import 'package:studentfirebase/views/student_screen.dart';

class ListViewStudent extends StatefulWidget {
  @override
  _ListViewStudentState createState() => _ListViewStudentState();
}

final studentReference = FirebaseDatabase.instance.reference().child('student');

class _ListViewStudentState extends State<ListViewStudent> {
  List<Student> items;
  StreamSubscription<Event> _onStudentAddSubscription;
  StreamSubscription<Event> _onStudentChangeSubscription;

  @override
  void initState() {
    items = List<Student>();
    setState(() {
      _onStudentAddSubscription =
          studentReference.onChildAdded.listen(_onStudentAdd);
      _onStudentChangeSubscription =
          studentReference.onChildChanged.listen(_onStudentUpdated);
    });

    super.initState();
  }

  @override
  void dispose() {
    _onStudentAddSubscription.cancel();
    _onStudentChangeSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Students List'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Center(
        child: ListView.builder(
            padding: EdgeInsets.only(top: 12),
            itemCount: items.length,
            itemBuilder: (context, position) {
              return Column(
                children: <Widget>[
                  Divider(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: ListTile(
                          title: Text(
                            '${items[position].name}',
                            style: TextStyle(fontSize: 18, color: Colors.blue),
                          ),
                          subtitle: Text(
                            '${items[position].description}',
                            style:
                                TextStyle(fontSize: 14, color: Colors.blueGrey),
                          ),
                          leading: CircleAvatar(
                            backgroundColor: Colors.greenAccent,
                            radius: 14,
                            child: Text(
                              '${position + 1}',
                              style:
                                  TextStyle(fontSize: 14, color: Colors.black),
                            ),
                          ),
                          trailing: IconButton(
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => _deleteStudent(
                                context, items[position], position),
                          ),
                          onTap: () =>
                              _navigateToStudentInfo(context, items[position]),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        onPressed: () =>
                            _navigateToStudent(context, items[position]),
                      ),
                    ],
                  ),
                ],
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
          backgroundColor: Colors.purple,
          onPressed: () => _createNewStudent(context)),
    );
  }

  void _onStudentAdd(Event event) {
    setState(() {
      items.add(Student.fromSnapShot(event.snapshot));
    });
  }

  void _onStudentUpdated(Event event) {
    //To compare between two value
    var oldStudent =
        items.singleWhere((student) => student.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldStudent)] = Student.fromSnapShot(event.snapshot);
    });
  }

  _deleteStudent(BuildContext context, Student student, int position) async {
    await studentReference.child(student.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  _navigateToStudent(BuildContext context, Student student) async {
    await Navigator.push(context,
        MaterialPageRoute(builder: (context) => StudentScreen(student)));
  }

  _navigateToStudentInfo(BuildContext context, Student student) async {
    await Navigator.push(
        context, MaterialPageRoute(builder: (context) => StudentInfo(student)));
  }

  _createNewStudent(BuildContext context) async {
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                StudentScreen(Student(null, '', '', '', '', ''))));
  }
}
