import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:studentfirebase/models/student.dart';

class StudentScreen extends StatefulWidget {
  final Student student;

  StudentScreen(this.student);

  @override
  _StudentScreenState createState() => _StudentScreenState();
}

final studentReference = FirebaseDatabase.instance.reference().child('student');

class _StudentScreenState extends State<StudentScreen> {
  TextEditingController _nameController;
  TextEditingController _ageController;
  TextEditingController _cityController;
  TextEditingController _departmentController;
  TextEditingController _descriptionController;

  @override
  void initState() {
    _nameController = TextEditingController(text: widget.student.name);
    _ageController = TextEditingController(text: widget.student.age);
    _cityController = TextEditingController(text: widget.student.city);
    _departmentController =
        TextEditingController(text: widget.student.department);
    _descriptionController =
        TextEditingController(text: widget.student.description);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _cityController.dispose();
    _departmentController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Student Info'),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
      ),
      body: ListView(
        children: <Widget>[
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person), labelText: 'name'),
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                  TextField(
                    controller: _ageController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person), labelText: 'age'),
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                  TextField(
                    controller: _cityController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person), labelText: 'city'),
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                  TextField(
                    controller: _departmentController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person), labelText: 'department'),
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                  TextField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.person), labelText: 'description'),
                    style: TextStyle(fontSize: 18, color: Colors.blue),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  FlatButton(
                    color: Colors.deepPurpleAccent,
                    onPressed: () {
                      if (widget.student.id != null) {
                        studentReference.child(widget.student.id).set({
                          'name': _nameController.text,
                          'age': _ageController.text,
                          'city': _cityController.text,
                          'department': _departmentController.text,
                          'description': _descriptionController.text,
                        }).then((_) {
                          Navigator.pop(context);
                        });
                      } else {
                        studentReference.push().set({
                          'name': _nameController.text,
                          'age': _ageController.text,
                          'city': _cityController.text,
                          'department': _departmentController.text,
                          'description': _descriptionController.text,
                        }).then((_) {
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: (widget.student.id != null)
                        ? Text('Update', style: TextStyle(color: Colors.white))
                        : Text('Add', style: TextStyle(color: Colors.white)),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
