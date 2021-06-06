import 'dart:convert';

import 'dart:ui';
import 'dart:ffi';

import 'package:http/http.dart' as http;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Comment {
  final String username;
  final String comment;


  Comment({
    @required this.username,
    @required this.comment,


  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      username: json['username'],
      comment: json['comments'],


    );
  }
}
class Comments extends StatefulWidget {



  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return new CommentsScreen();
  }
}

class CommentsScreen extends State<Comments>
//  implements LoginScreenContract, AuthStateListener
    {

  List<Comment> _comment = List<Comment>();
  Future<List<Comment>> fetchcomment() async{

    final response =
    await http.get(Uri.parse('http://cookbookrecipes.in/test.php'));
    var comments = List<Comment>();

    if (response.statusCode == 200) {
      var commentJson = json.decode(response.body);
      print(json.decode(response.body));
      for(var commentJson in commentJson){
        comments.add(Comment.fromJson(commentJson));
      }
    }

    return comments;
  }

  @override
  void initState() {
    super.initState();

    fetchcomment();

  }


  @override
  Widget build(BuildContext context) {
    fetchcomment().then((value) {
      setState(() {
        _comment.addAll(value);
      });
    });
  return Scaffold(
  appBar: AppBar(
  title:Text("Comments")
  ),
  body:Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.height,
 child:   FutureBuilder(
    future: fetchcomment(),

    builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.data == null) {
    return Container(
    child: Center(
    child: Text("Loading..."),
    ));
    } else { return ListView.builder(
        itemCount: _comment.length,
        itemBuilder: (BuildContext context,int index){
          return ListTile(
subtitle: Text(_comment[index].comment),
              title:Text(_comment[index].username)
          );
        }
    );
    }
    }
    )

   )
    /* ListView.builder(
  itemCount: 5,
  itemBuilder: (BuildContext context,int index){
  return ListTile(

  title:Text("gsdhhhhhhhhhdhsshdf")
  );
  }
  ),*/
  );

  }}