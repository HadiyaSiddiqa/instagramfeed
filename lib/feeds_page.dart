
import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instagramfeeds/sample.dart';





class Album {
  final String id;
  final String channelname;
  final String title;
  final String high_thumbnail;
  final String low_thumbnail;
  final String medium_thumbnail;


  Album({
     @required this.id,
  @required this.channelname,
    @required  this.title,
    @required  this.high_thumbnail,
    @required  this.low_thumbnail,
    @required  this.medium_thumbnail,

  });

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      channelname: json['channelname'],
      title: json['title'],
      high_thumbnail: json['high thumbnail'],
      low_thumbnail: json['low thumbnail'],
      medium_thumbnail: json['medium thumbnail'],

    );
  }
}
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
class HomeScreen extends StatefulWidget {

  @override
  _HomeScreenState createState() => new _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {

  var _currentTab = 0;
  bool _isHidden = true;
  List<Widget> page;
  var _currentPage;
  List<Album> _album = List<Album>();


  Future<List<Album>> fetchdata() async{

    final response =
    await http.get(Uri.parse('https://hiit.ria.rocks/videos_api/cdn/com.rstream.crafts?versionCode=40&lurl=Canvas%20painting%20ideas'));
    var albums = List<Album>();

    if (response.statusCode == 200) {
      var albumJson = json.decode(response.body);
      for(var albumJson in albumJson){
        albums.add(Album.fromJson(albumJson));
      }
    }
    return albums;
    }




  void _togglebookmark() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }
  @override
  void initState() {
    super.initState();
      fetchdata();


  }

  @override
  Widget build(BuildContext context) {
    fetchdata().then((value) {
      setState(() {
        _album.addAll(value);
      });
    });




    var _textStyle = new TextStyle(fontSize: 0.0);


    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: PageView(
    children: <Widget>[
    FutureBuilder(
    future: fetchdata(),

    builder: (BuildContext context, AsyncSnapshot snapshot) {
    if (snapshot.data == null) {
    return Container(
    child: Center(
    child: Text("Loading..."),
    ));
    } else {   return PageView.builder(

    scrollDirection: Axis.vertical,
    itemCount: _album.length,
    itemBuilder: (BuildContext context, int index) {


return  Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          height: 40.0,
                          width: 40.0,

                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                     _album[index].medium_thumbnail)
                              )),
                        ),
                        SizedBox(width: 10.0),
                        Text(_album[index].channelname,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )
                      ],
                    ),
                    IconButton(
                      icon: Icon(Icons.more_vert),
                      onPressed: () {},
                    )
                  ]),
            ),
            Container(
              height: MediaQuery.of(context).size.height*0.50,
              width: MediaQuery.of(context).size.width,

              child: Image.network(
               _album[index].high_thumbnail,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.favorite_border),
                      ),
                      SizedBox(width: 5.0),
                     IconButton(icon:  Icon(Icons.comment), onPressed: (){
                       Navigator.push(
                         context,
                         MaterialPageRoute(
                             builder: (context) => new Comments()),
                       );
                     }),
                      SizedBox(width: 10.0),
                      Icon(Icons.person)
                    ],
                  ),
                  IconButton(
                    //  onPressed: () => _controller.clear(),
                    onPressed: _togglebookmark,
                    icon: Icon(_isHidden
                        ? Icons.bookmark_border
                        : Icons.bookmark,
                        color: Colors.black),
                  ),
                ],
              ),

            ),

Row(

  children: [



       Container(
         width: 50,
         child: Stack(
           children: [
             new Stack(children: <Widget>[
               Row(
                 children: [
                   Container(
                     height: 25.0,
                     width: 25.0,

                     decoration: BoxDecoration(
                         shape: BoxShape.circle,
                         image: DecorationImage(
                             fit: BoxFit.fill,
                             image: new NetworkImage(
                                 _album[index].medium_thumbnail)
                         )),
                   ),
                 ],
               ),
               Positioned(
                 left: 15,
                 child:  Container(
                   height: 25.0,
                   width: 25.0,
                   decoration: BoxDecoration(
                       border: Border.all(
                         color: Colors.white,
                       ),
                       shape: BoxShape.circle,
                       image: DecorationImage(
                           fit: BoxFit.fill,
                           image: new NetworkImage(
                               _album[index].medium_thumbnail)
                       )),
                 ), )

             ],
             ),
             Positioned(
               left: 25,
               child:  Container(
               height: 25.0,
               width: 25.0,

                 decoration: BoxDecoration(
                     border: Border.all(
                       color: Colors.white,
                     ),
                     shape: BoxShape.circle,
                     image: DecorationImage(
                         fit: BoxFit.fill,
                         image: new NetworkImage(
                             _album[index].medium_thumbnail)
                     )),
               ), )
           ],
         ),
       ),

  Row(
    children: [Text("Liked by "),
      Text("neeharika_boda ",style: TextStyle(fontWeight: FontWeight.bold),),
      Text("and "),
      Text("62,707 others ",style: TextStyle(fontWeight: FontWeight.bold),),
    ],
  )

  ],
),

           Row(children: [
             Text(_album[index].channelname,
               style: TextStyle(fontWeight: FontWeight.bold),

             )  ,
             SizedBox(width: 5,),
            Container(width: 100,child:  Text( _album[index].title, overflow: TextOverflow.ellipsis,),)

           ],),
            ExpandableText(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque scelerisque efficitur posuere. Curabitur tincidunt placerat diam ac efficitur. Cras rutrum egestas nisl vitae pulvinar. '

              ,
              trimLines: 2,
            ),
          Align(
            alignment:Alignment.centerLeft,
            child:   Text("View all 931 comments",style: TextStyle(color: Colors.grey),),

          )

          ],
      );

    });}}





    )])),



        bottomNavigationBar:  new BottomNavigationBar(
          currentIndex: _currentTab,
          onTap: (int index) {
            setState(() {
              _currentTab = index;
              _currentPage = page[index];
            });
          },
          type: BottomNavigationBarType.fixed,
          iconSize: 30.0,
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              title: new Text("", style: _textStyle),
              activeIcon: Icon(
                Icons.home,
                color: Colors.black,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.search,
                color: Colors.grey,
              ),
              title: new Text("", style: _textStyle),
              activeIcon: Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.add_box,
                color: Colors.grey,
              ),
              title: new Text("", style: _textStyle),
              activeIcon: Icon(
                Icons.add_box,
                color: Colors.black,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.favorite,
                color: Colors.grey,
              ),
              title: new Text("", style: _textStyle),
              activeIcon: Icon(
                Icons.favorite,
                color: Colors.black,
              ),
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.account_circle,
                color: Colors.grey,
              ),
              title: new Text("", style: _textStyle),
              activeIcon: Icon(
                Icons.account_circle,
                color: Colors.black,
              ),
            ),
          ],
        )
    );
  }
}

class ExpandableText extends StatefulWidget {
  const ExpandableText(
      this.text, {
        Key key,
        this.trimLines = 2,
      })  : assert(text != null),
        super(key: key);

  final String text;
  final int trimLines;

  @override
  ExpandableTextState createState() => ExpandableTextState();
}

class ExpandableTextState extends State<ExpandableText> {
  bool _readMore = true;
  void _onTapLink() {
    setState(() => _readMore = !_readMore);
  }

  @override
  Widget build(BuildContext context) {
    final DefaultTextStyle defaultTextStyle = DefaultTextStyle.of(context);
    final colorClickableText = Colors.blue;
    final widgetColor = Colors.black;
    TextSpan link = TextSpan(
        text: _readMore ? "... read more" : " read less",
        style: TextStyle(
          color: colorClickableText,
        ),
        recognizer: TapGestureRecognizer()..onTap = _onTapLink
    );
    Widget result = LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        assert(constraints.hasBoundedWidth);
        final double maxWidth = constraints.maxWidth;
        // Create a TextSpan with data
        final text = TextSpan(
          text: widget.text,
        );
        // Layout and measure link
        TextPainter textPainter = TextPainter(
          text: link,
          textDirection: TextDirection.rtl,//better to pass this from master widget if ltr and rtl both supported
          maxLines: widget.trimLines,
          ellipsis: '...',
        );
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final linkSize = textPainter.size;
        // Layout and measure text
        textPainter.text = text;
        textPainter.layout(minWidth: constraints.minWidth, maxWidth: maxWidth);
        final textSize = textPainter.size;
        // Get the endIndex of data
        int endIndex;
        final pos = textPainter.getPositionForOffset(Offset(
          textSize.width - linkSize.width,
          textSize.height,
        ));
        endIndex = textPainter.getOffsetBefore(pos.offset);
        var textSpan;
        if (textPainter.didExceedMaxLines) {
          textSpan = TextSpan(
            text: _readMore
                ? widget.text.substring(0, endIndex)
                : widget.text,
            style: TextStyle(
              color: widgetColor,
            ),
            children: <TextSpan>[link],
          );
        } else {
          textSpan = TextSpan(
            text: widget.text,
          );
        }
        return RichText(
          softWrap: true,
          overflow: TextOverflow.clip,
          text: textSpan,
        );
      },
    );
    return result;
  }
}