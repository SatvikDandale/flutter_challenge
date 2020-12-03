import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import './Screens/jsonPlaceholderPosts.dart';
import './Screens/personalJSONPosts.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter A',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String jsonPlaceholderURl = "https://jsonplaceholder.typicode.com";

  final String crudApiURL = "https://json-flutter.herokuapp.com";

  @override
  void initState() {
    super.initState();
  }

  bool _isCrudLoaded = false;
  bool _crudError = false;

  void checkCrudApi() async {
    // setState(() {
    //   _isCrudLoaded = false;
    // });
    try {
      var response = await http
          .get(this.crudApiURL + "/posts")
          .timeout(const Duration(seconds: 10), onTimeout: () {
        throw TimeoutException("Server isn't responding");
      });
      if (response.statusCode == 200) {
        print("DONE");
        setState(() {
          _isCrudLoaded = true;
          _crudError = false;
        });
      } else {
        this.setState(() {
          _crudError = true;
        });
      }
    } catch (error) {
      this.setState(() {
        _crudError = true;
      });
      print("Error");
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isCrudLoaded && !_crudError) {
      checkCrudApi();
    }
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Home Screen"),
      ),
      body: Container(
        color: Colors.blue[50],
        child: Column(
          children: [
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 20, bottom: 20),
                padding: EdgeInsets.all(10),
                alignment: Alignment.centerLeft,
                child: Text(
                  "Welcome to the app!",
                  style: TextStyle(fontSize: 35),
                ),
              ),
            ),
            Center(
              child: Column(
                children: [
                  Container(
                    constraints:
                        BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                    margin: EdgeInsets.all(10),
                    child: RaisedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  JSONPosts(baseURL: jsonPlaceholderURl),
                            ));
                      },
                      color: Theme.of(context).accentColor,
                      child: Padding(
                        padding: EdgeInsets.all(0),
                        child: Container(
                          alignment: Alignment.center,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Text(
                                'Posts from JSONPlaceholder',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.white,
                                ),
                              ),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  _isCrudLoaded
                      ? Container(
                          constraints:
                              BoxConstraints(maxWidth: 250.0, minHeight: 50.0),
                          margin: EdgeInsets.all(10),
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => CrudApiPosts(
                                      baseURL: this.crudApiURL,
                                    ),
                                  ));
                            },
                            color: Theme.of(context).accentColor,
                            child: Padding(
                              padding: EdgeInsets.all(0),
                              child: Container(
                                alignment: Alignment.center,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Text(
                                      'Posts from CRUD API',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Icon(
                                      Icons.arrow_forward,
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        )
                      : !_crudError
                          ? Container(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Loading personal CRUD server",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  CircularProgressIndicator()
                                ],
                              ),
                            )
                          : Container(
                              constraints: BoxConstraints(
                                  maxWidth: 250.0, minHeight: 50.0),
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  Text(
                                    "CRUD Server not responding",
                                    style: TextStyle(fontSize: 18),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  RaisedButton(
                                    onPressed: () {
                                      print("HELLO");
                                      this.setState(() {
                                        _isCrudLoaded = false;
                                        _crudError = false;
                                        checkCrudApi();
                                      });
                                      // checkCrudApi();
                                    },
                                    color: Theme.of(context).accentColor,
                                    child: Padding(
                                      padding: EdgeInsets.all(0),
                                      child: Container(
                                        constraints: BoxConstraints(
                                            maxWidth: 250.0, minHeight: 50.0),
                                        alignment: Alignment.center,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            Text(
                                              'Retry',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Icon(
                                              Icons.cloud_download,
                                              color: Colors.white,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
