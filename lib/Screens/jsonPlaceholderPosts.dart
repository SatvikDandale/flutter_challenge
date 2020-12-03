import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class JSONComments extends StatelessWidget {
  final String postId;
  JSONComments({Key key, @required this.postId}) : super(key: key);
  final String url = "https://jsonplaceholder.typicode.com/comments?postId=";

  Future<List<dynamic>> fetchComments() async {
    var result = await http.get(url + this.postId);
    return json.decode(result.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments for postID: " + this.postId),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchComments(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  padding: EdgeInsets.all(8),
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Card(
                      child: InkWell(
                        splashColor: Colors.blue.withAlpha(30),
                        onTap: () {},
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(8),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: Text("Comment ID: " +
                                        snapshot.data[index]['id'].toString()),
                                  ),
                                  Text("Post ID: " + this.postId)
                                ],
                              ),
                            ),
                            Container(
                              child: Column(
                                children: [
                                  ListTile(
                                    contentPadding: EdgeInsets.only(
                                        left: 8, right: 8, bottom: 2),
                                    title: RichText(
                                      text: TextSpan(
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.black),
                                          children: <TextSpan>[
                                            TextSpan(text: "Name: "),
                                            TextSpan(
                                                text: snapshot.data[index]
                                                    ['name'],
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold))
                                          ]),
                                    ),
                                    subtitle: Container(
                                      alignment: Alignment.centerLeft,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                                top: 4, bottom: 4),
                                            child: Text(
                                              "Email: " +
                                                  snapshot.data[index]['email'],
                                              style: TextStyle(
                                                  fontStyle: FontStyle.italic,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                          Text(snapshot.data[index]['body']
                                              .trim())
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  });
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ),
      ),
    );
  }
}

class JSONPosts extends StatelessWidget {
  final String baseURL;
  JSONPosts({Key key, @required this.baseURL}) : super(key: key);

  Future<List<dynamic>> fetchPosts() async {
    var result = await http.get(this.baseURL + "/posts");
    return json.decode(result.body);
  }

  Future<int> getCommentsCount(String postId) async {
    var result = await http.get(this.baseURL + "/comments?postId=" + postId);
    return json.decode(result.body).length;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Posts from JSON Placeholder"),
      ),
      body: Container(
        child: FutureBuilder<List<dynamic>>(
          future: fetchPosts(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                padding: EdgeInsets.all(8),
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return Card(
                    child: InkWell(
                      onTap: () {
                        // print(snapshot.data[index][])
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => JSONComments(
                                  postId:
                                      snapshot.data[index]['id'].toString()),
                            ));
                      },
                      splashColor: Colors.blue.withAlpha(30),
                      child: Column(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  child: Text("Post ID: " +
                                      snapshot.data[index]['id'].toString()),
                                ),
                                Text("User ID: " +
                                    snapshot.data[index]['userId'].toString()),
                              ],
                            ),
                          ),
                          Container(
                              child: Column(
                            children: [
                              // Container(
                              //     padding:
                              //         EdgeInsets.only(left: 8, top: 4, right: 8),
                              //     alignment: Alignment.centerLeft,
                              //     child: Text("Title")),
                              ListTile(
                                contentPadding: EdgeInsets.only(
                                    left: 8, right: 8, bottom: 2),
                                title: Padding(
                                  padding: EdgeInsets.only(bottom: 3),
                                  child: Text(
                                    snapshot.data[index]['title'],
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                                subtitle: Text(snapshot.data[index]['body']),
                              ),
                              Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.all(8),
                                  child: FutureBuilder<int>(
                                    future: getCommentsCount(
                                        snapshot.data[index]['id'].toString()),
                                    builder: (BuildContext context,
                                        AsyncSnapshot snap) {
                                      if (snap.hasData) {
                                        return Text("Comments: " +
                                            snap.data.toString());
                                      } else
                                        return Text("Comments: 0");
                                    },
                                  ))
                            ],
                          ))
                        ],
                      ),
                    ),
                  );
                },
              );
            } else
              return Center(
                child: CircularProgressIndicator(),
              );
          },
        ),
      ),
    );
  }
}
