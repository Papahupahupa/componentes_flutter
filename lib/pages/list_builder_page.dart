import 'dart:async';

import 'package:flutter/material.dart';

class ListPage extends StatefulWidget {
  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {

  ScrollController _scrollController = new ScrollController();
  List<int> _listaNumeros = new List();
  int _ultimoItem = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _agregar10();

    _scrollController.addListener((){
      //We are at the end of the page
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
//        _agregar10();
        fetchData();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listas'),
      ),
      body: Stack(children: <Widget>[
        _createList(),
        _createLoading()
      ]),
    );
  }

  Widget _createList() {
    return RefreshIndicator(
      onRefresh: _getPage1,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _listaNumeros.length,
        itemBuilder: (BuildContext context, int index) {
          final imagen = _listaNumeros[index];

          return FadeInImage(
            placeholder: AssetImage('lib/assets/loading.gif'),
            image: NetworkImage('https://picsum.photos/400/500/?image=${imagen}')
          );
        }
      ),
    );
  }

  void _agregar10() {
    for (int i = 1; i < 10; i++){
      _ultimoItem++;
      _listaNumeros.add(_ultimoItem);
    }

    setState(() {

    });
  }

  Future fetchData() async {
    _isLoading = true;
    setState(() {

    });

    final _duration = new Duration(seconds: 2);
    return new Timer(_duration, respuestaHTTP);
  }

  void respuestaHTTP() {
    _isLoading = false;

    _scrollController.animateTo(
      _scrollController.position.pixels + 100,
      duration: Duration(milliseconds: 250),
      curve: Curves.fastOutSlowIn
    );

    _agregar10();
  }

  Widget _createLoading() {
    if (_isLoading){
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircularProgressIndicator(),
            ],
          ),
          SizedBox(height: 30.0)
        ],
      );
    } else {
      return Container();
    }
  }

  Future<void> _getPage1() async {
    final duration = new Duration(seconds: 2);
    new Timer(duration, () {

      _listaNumeros.clear();
      _ultimoItem++;
      _agregar10();

    });

    return Future.delayed(duration);
  }
}
