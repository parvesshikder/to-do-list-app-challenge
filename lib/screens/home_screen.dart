// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_animated_dialog/flutter_animated_dialog.dart';
import 'package:to_do_list/widgets/task.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //List to store tasks
  List<Tasks> todolist = [];

  //title and subtitle input controller
  final TextEditingController _textFieldControllerTitle =
      TextEditingController();
  final TextEditingController _textFieldControllerSubtitle =
      TextEditingController();

  //global key for form validation
  final _formKey = GlobalKey<FormState>();

  //pop-up dialog to add new task
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 5,
            title: const Text('New Task'),
            content: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    controller: _textFieldControllerTitle,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Title',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter some text';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    // The validator receives the text that the user has entered.
                    controller: _textFieldControllerSubtitle,
                    decoration: InputDecoration(
                      fillColor: Colors.grey.shade100,
                      filled: true,
                      hintText: 'Subtitle',
                    ),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.redAccent,
                textColor: Colors.white,
                child: const Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.green,
                textColor: Colors.white,
                child: const Text('SUBMIT'),
                onPressed: () {
                  //title input validation
                  if (_formKey.currentState!.validate()) {
                    setState(() {
                      todolist.add(Tasks(
                          title: _textFieldControllerTitle.text.toString(),
                          subtitle:
                              _textFieldControllerSubtitle.text.toString()));

                      Navigator.pop(context);
                    });
                  }

                  //clear textfield after adding new task
                  _textFieldControllerTitle.clear();
                  _textFieldControllerSubtitle.clear();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('To-Do LIst')),
        centerTitle: true,
        actions: [
          //delete all task
          GestureDetector(
            onTap: () {
              //if list is empty show (List is Empty)
              todolist.isEmpty
                  ? ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text('List is Emptly'),
                      backgroundColor: Colors.redAccent,
                    ))
                  //if list has data show popup to confirm delete task
                  : showAnimatedDialog(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return ClassicGeneralDialogWidget(
                          positiveText: 'YES',
                          positiveTextStyle: TextStyle(
                            color: Colors.red[600],
                          ),
                          negativeText: 'NO',
                          titleText: 'Clear the list',
                          contentText: 'Do you want to delete all tasks',
                          onPositiveClick: () {
                            setState(() {
                              todolist.clear();
                            });
                            Navigator.of(context).pop();
                          },
                          onNegativeClick: () {
                            Navigator.of(context).pop();
                          },
                        );
                      },
                      animationType: DialogTransitionType.slideFromBottomFade,
                      curve: Curves.fastOutSlowIn,
                      duration: const Duration(seconds: 1),
                    );
            },
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.delete_forever,
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),

      //display all item from list if list is not empty
      body: todolist.isNotEmpty
          ? Container(
              margin:
                  const EdgeInsets.symmetric(vertical: 30.0, horizontal: 30.0),
              child: ListView.builder(
                itemCount: todolist.length,
                itemBuilder: ((context, index) {
                  return ListTile(
                    leading: GestureDetector(
                      child: todolist[index].check
                          ? const Icon(
                              Icons.check_box,
                              color: Colors.blue,
                            )
                          : const Icon(Icons.check_box_outline_blank),
                      onTap: () {
                        setState(() {
                          //check & uncheck task
                          if (todolist[index].check == false) {
                            todolist[index].check = true;
                            todolist[index].strick = true;
                          } else if (todolist[index].check == true) {
                            todolist[index].check = false;
                            todolist[index].strick = false;
                          }
                        });
                      },
                    ),
                    title: todolist[index].strick
                        ? Text(
                            todolist[index].title,
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                            ),
                          )
                        : Text(todolist[index].title),
                    subtitle: todolist[index].strick
                        ? Text(
                            todolist[index].subtitle,
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                            ),
                          )
                        : Text(todolist[index].subtitle),
                  );
                }),
              ),
            )
          // if list is empty display (list is empty add new task)
          : const Padding(
              padding: EdgeInsets.all(50.0),
              child: Text(
                  'You do not have any task available, press the + button to add one',
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(221, 80, 76, 76)),
                  textAlign: TextAlign.center),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _displayTextInputDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
