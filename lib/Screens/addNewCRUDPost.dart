import 'package:flutter/material.dart';
import 'package:validators/validators.dart' as validator;
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomFormField extends StatelessWidget {
  final String hintText;
  final Function validator;
  final Function onSaved;
  final bool isPassword;
  final bool isEmail;

  CustomFormField({
    this.hintText,
    this.validator,
    this.onSaved,
    this.isPassword = false,
    this.isEmail = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          hintText: hintText,
          contentPadding: EdgeInsets.all(15.0),
          border: InputBorder.none,
          filled: true,
          fillColor: Colors.grey[200],
        ),
        obscureText: isPassword ? true : false,
        validator: validator,
        onSaved: onSaved,
        keyboardType: isEmail ? TextInputType.emailAddress : TextInputType.text,
      ),
    );
  }
}

class AddNewPost extends StatefulWidget {
  final String url;
  AddNewPost(this.url);

  @override
  _AddNewPostState createState() => _AddNewPostState();
}

class _AddNewPostState extends State<AddNewPost> {
  final _formKey = GlobalKey<FormState>();
  var id;
  var userId;
  var title;
  var body;

  void createPost() async {
    print(widget.url);
    var response = await http.post(
      widget.url + "/post",
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        "id": id,
        "userId": userId,
        'title': title,
        "body": body
      }),
    );
    if (response.statusCode == 201) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final halfMediaWidth = MediaQuery.of(context).size.width / 2.0;
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: [
            Container(
              alignment: Alignment.topCenter,
              child: Row(
                children: [
                  Container(
                    alignment: Alignment.topCenter,
                    width: halfMediaWidth,
                    child: CustomFormField(
                      hintText: 'Post ID',
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Enter Post ID';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        id = value;
                      },
                    ),
                  ),
                  Container(
                    alignment: Alignment.topCenter,
                    width: halfMediaWidth,
                    child: CustomFormField(
                      hintText: 'User Id',
                      validator: (String value) {
                        if (value.isEmpty) {
                          return 'Enter User ID';
                        }
                        return null;
                      },
                      onSaved: (String value) {
                        userId = value;
                      },
                    ),
                  )
                ],
              ),
            ),
            CustomFormField(
              hintText: 'Title',
              validator: (String value) {
                if (value.isEmpty) {
                  return 'Enter Title';
                }
                return null;
              },
              onSaved: (String value) {
                title = value;
              },
            ),
            CustomFormField(
              hintText: 'Post Content',
              validator: (String value) {
                if (value.length < 3) {
                  return 'Enter Post Content';
                }
                _formKey.currentState.save();
                return null;
              },
              onSaved: (String value) {
                body = value;
              },
            ),
            RaisedButton(
              color: Colors.blueAccent,
              onPressed: () {
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  createPost();
                }
              },
              child: Text(
                'Create',
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
