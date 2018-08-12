import 'dart:async';
import 'package:flutter/material.dart';

void main() => runApp(new SearchBarApp());

class SearchBarApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'SearchBar example',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SearchBarPage(title: 'SearchBar example'),
    );
  }
}

class SearchBarPage extends StatefulWidget {
  SearchBarPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _SearchBarPageState createState() => new _SearchBarPageState();
}

class _SearchBarPageState extends State<SearchBarPage> {
  bool _isSearch = false;
  String _searchFilter = '';
  TextEditingController txt = new TextEditingController();

  List _someData = [
    'one',
    'Germany',
    'Mercedes',
    'Ivan',
    'Coffee',
    'car',
    'traver',
    'Damn tired',
    'I want couple of beers',
    'Flutter',
    'Example list'
  ];

  @override
  void initState() {
    super.initState();
  }

  Future<List> _filterList() async{
    //replace return data with the result of the call to the backend or whatever you want
    return _someData.where((listItem) => listItem.toUpperCase().contains(_searchFilter.toUpperCase())).toList();
  }

  // two click action, on the first X the search string will be emptied, on the second will return from the search mode
  Widget _buildAction(BuildContext context){

    if(_isSearch){
      return new IconButton(
          icon: new Icon(Icons.close),
          onPressed: (){ setState((){
            if(_searchFilter.length > 0){
              _searchFilter = "";
              txt.value = TextEditingValue(text: "");
            }else{
              _isSearch = false;
            }
          });}
      );
    }

    return new IconButton(
      icon: new Icon(Icons.search),
      onPressed: () {setState(() {
        _isSearch = true;
      });
      },
    );
  }

  Widget _buildTitle(BuildContext context){
    if(_isSearch){
      return TextField(
        decoration: new InputDecoration.collapsed(
          hintText: 'Search',
          hintStyle: Theme.of(context).primaryTextTheme.title.copyWith(color: Theme.of(context).primaryTextTheme.title.color.withOpacity(0.5)),
        ),
        style: Theme.of(context).primaryTextTheme.title,
        onChanged: (filter){setState((){_searchFilter = filter;});},
        controller: txt,
        autofocus: true,
      );
    }
    return Text(widget.title);
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: _buildTitle(context),
        actions: <Widget>[
          _buildAction(context)
        ],
      ),

      body: new FutureBuilder(
          future: _filterList(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return new ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Text(snapshot.data[index]);
                  });
            } else {
              return new CircularProgressIndicator();
            }
          })
    );
  }
}