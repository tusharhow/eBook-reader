import 'package:flutter/material.dart';
import 'package:flutter_admob/Helper/ColorsRes.dart';
import 'package:flutter_admob/Helper/String.dart';
import 'package:flutter_admob/Model/bookmark.dart';
import 'package:flutter_admob/Model/detail.dart';
import 'package:flutter_admob/databaseHelper/bookmarkDbHelper.dart';
import 'package:flutter_admob/databaseHelper/dbhelper.dart';
import 'package:flutter_admob/localization/Demo_Localization.dart';
import 'chapterDetails.dart';

// ignore: must_be_immutable
class BookmarkList extends StatefulWidget {
  int id;
  BookmarkList({
    Key key,
    this.id,
  }) : super(key: key);
  BookMarkClass createState() => BookMarkClass();
}

class BookMarkClass extends State<BookmarkList> {
  static final BookmarkHelper instance = BookmarkHelper.privateConstructor();
  static final DatabaseHelper instance1 = DatabaseHelper.privateConstructor();

  TextEditingController _textController = TextEditingController();

  List<Bookmark> item = [];
  List<Bookmark> _notesForDisplay = [];
  Bookmark it;
  bool typing = false;
  String query;
  //dynamic source;

  List<TextSpan> highlightOccurrences(source, query) {
    if (query == null || query.isEmpty) {
      return [TextSpan(text: source)];
    }

    var matches = <Match>[];
    for (final token in query.trim().toLowerCase().split(' ')) {
      matches.addAll(token.allMatches(source.toLowerCase()));
    }

    if (matches.isEmpty) {
      return [TextSpan(text: source)];
    }
    matches.sort((a, b) => a.start.compareTo(b.start));

    int lastMatchEnd = 0;
    final List<TextSpan> children = [];
    for (final match in matches) {
      if (match.end <= lastMatchEnd) {
        // already matched -> ignore
      } else if (match.start <= lastMatchEnd) {
        children.add(
          TextSpan(
            text: source.substring(lastMatchEnd, match.end),
            style: TextStyle(
              backgroundColor: ColorsRes.appColor,
              color: Colors.white,
            ),
          ),
        );
      } else if (match.start > lastMatchEnd) {
        children.add(
          TextSpan(
            text: source.substring(lastMatchEnd, match.start),
          ),
        );

        children.add(
          TextSpan(
            text: source.substring(match.start, match.end),
            style: TextStyle(
              backgroundColor: ColorsRes.appColor,
              color: Colors.white,
            ),
          ),
        );
      }

      if (lastMatchEnd < match.end) {
        lastMatchEnd = match.end;
      }
    }
    if (lastMatchEnd < source.length) {
      children.add(
        TextSpan(
          text: source.substring(lastMatchEnd, source.length),
        ),
      );
    }
    return children;
  }

  @override
  void initState() {
    setState(
      () {
        instance.getBookmarks().then(
          (value) {
            item.addAll(value);
            _notesForDisplay = item;
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: dark_mode ? ColorsRes.white : ColorsRes.black,
      appBar: AppBar(
        backgroundColor: ColorsRes.appColor,
        title: typing
            ? TextField(
                style: TextStyle(color: Colors.white, fontSize: 18),
                cursorColor: Colors.white,
                autofocus: true,
                controller: _textController,
                decoration: new InputDecoration(
                  border: InputBorder.none,
                  hintText: MyAppLocalization.of(context).translate("Search"),
                  hintStyle: TextStyle(color: Colors.white60, fontSize: 18),
                ),
                onChanged: (text) {
                  text = text.toLowerCase();
                  setState(
                    () {
                      query = text;
                      _notesForDisplay = item.where(
                        (items) {
                          print("in search op");
                          var noteTitle = items.v_id.toString().toLowerCase();
                          return noteTitle.contains(text);
                        },
                      ).toList();
                    },
                  );
                },
              )
            : Text(MyAppLocalization.of(context).translate("Bookmark List"),
                style: TextStyle(color: Colors.white)),
        actions: <Widget>[
          IconButton(
            icon: Icon(typing ? Icons.clear : Icons.search),
            onPressed: () {
              setState(
                () {
                  typing = !typing;
                  _textController.clear();
                  query = "";
                  _notesForDisplay = item;
                },
              );
            },
          ),
        ],
      ),
      body: FutureBuilder(
        //Fetching all the persons from the list using the istance of the DatabaseHelper class
        future: instance.getBookmarks(),
        // initialData: [instance1.getDetail1(widget.id),],
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            return ListView.separated(
              shrinkWrap: true,
              itemCount: _notesForDisplay.length,
              separatorBuilder: (BuildContext context, int index) => Divider(
                color: dark_mode ? Colors.white : ColorsRes.black,
                height: 5,
                thickness: 8,
              ),
              itemBuilder: (context, index) {
                //Bookmark  it= snapshot.data[index] as Bookmark;
                it = _notesForDisplay[index++];
                return Dismissible(
                  background: Container(
                    color: Colors.red,
                   
                  ),
                  key:UniqueKey(),
                  onDismissed: (direction) {
                    setState(
                      () {
                        instance.deleteId(it.v_id);
                        _notesForDisplay.removeAt(index);
                      },
                    );
                  },
                  child: ListTile(
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0.0, horizontal: 16.0),
                      dense: true,
                      tileColor: dark_mode
                          ? ColorsRes.backgroundColor
                          : ColorsRes.grey,
                      leading: RichText(
                        text: TextSpan(
                          children: highlightOccurrences("$index.", query),
                          style: TextStyle(
                            fontSize: 20,
                            color: dark_mode ? Colors.black : ColorsRes.white,
                          ),
                        ),
                      ),
                      title: BookmarkTitle(v_id: it.v_id)
                      // RichText(text:TextSpan(children: highlightOccurrences(BookmarkTitle(v_id: it.v_id.toString(),),query)))
                      ),
                );
              },
            );
          } else {
            return new CircularProgressIndicator();
          }
        },
      ),
    );
  }
}

class BookmarkTitle extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final int v_id;

  // ignore: non_constant_identifier_names
  BookmarkTitle({Key key, this.v_id}) : super(key: key);
  @override
  _BookmarkTitleState createState() => _BookmarkTitleState();
}

class _BookmarkTitleState extends State<BookmarkTitle> {
  static final DatabaseHelper instance = DatabaseHelper.privateConstructor();
  static final BookmarkHelper instance1 = BookmarkHelper.privateConstructor();
  List<detail> item = [];
  List<detail> _notesForDisplay = [];
  @override
  void initState() {
    setState(
      () {
        instance.getDetail1(widget.v_id).then(
          (value) {
            item.addAll(value);
            _notesForDisplay = item;
          },
        );
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: instance.getDetail1(widget.v_id),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        //Checking if we got data or not from the DB
        if (snapshot.hasData) {
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            itemCount: _notesForDisplay.length,
            itemBuilder: (context, index) {
              var item = _notesForDisplay[index];
              debugPrint("listbookssss----" + item.Id.toString());
              return ListTile(
                tileColor:
                    dark_mode ? ColorsRes.backgroundColor : ColorsRes.grey,
                title: Text(
                  () {
                    if (Language_flag == "en") {
                      return item.Chapter;
                    } else if (Language_flag == "hi") {
                      return item.hi_Chapter;
                    } else if (Language_flag == "zh") {
                      return item.zh_Chapter;
                    } else if (Language_flag == "es") {
                      return item.es_Chapter;
                    } else if (Language_flag == "ar") {
                      return item.ar_Chapter;
                    } else if (Language_flag == "ru") {
                      return item.ru_Chapter;
                    } else if (Language_flag == "ja") {
                      return item.ja_Chapter;
                    } else if (Language_flag == "de") {
                      return item.de_Chapter;
                    } else {
                      return item.Chapter;
                    }
                  }(),
                  //  item.Chapter,
                  style: TextStyle(
                    fontSize: 20,
                    color: dark_mode ? ColorsRes.black : ColorsRes.white,
                  ),
                ),
                onTap: () {
                  //Author_name
                  Author_name = item.en_Author_name;
                  zh_Author_name = item.zh_Author_name;
                  hi_Author_name = item.hi_Author_name;
                  ru_Author_name = item.ru_Author_name;
                  ar_Author_name = item.ar_Author_name;
                  es_Author_name = item.es_Author_name;
                  de_Author_name = item.de_Author_name;
                  ja_Author_name = item.ja_Author_name;
                  //total chapter
                  chapter_total = item.Chapter_Total;
                  // Book_name
                  en_Title = item.Title;
                  zh_Title = item.zh_Title;
                  hi_Title = item.hi_Title;
                  ru_Title = item.ru_Title;
                  ar_Title = item.ar_Title;
                  es_Title = item.es_Title;
                  de_Title = item.de_Title;
                  ja_Title = item.ja_Title;

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailPage(
                        id1: item.Id,
                        title: item.Chapter,
                      ),
                    ),
                  );
                },
              );
            },
          );
        } else {
          return Center(
            child: new CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
