import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Welcome to My app',
      home: new RandomWords(),
      theme: new ThemeData(
        // primaryColor: Colors.white,
        platform: TargetPlatform.iOS
      ),
    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _saved = new Set<WordPair>();
  final _suggessions = <WordPair>[];
  final TextStyle _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Startup name generator'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.list),
            onPressed: _pushedSaved,
          )
        ],
      ),
      body: _buildSuggesstions(),
    );
  }

  void _pushedSaved() {
    Navigator.of(context).push(
      new MaterialPageRoute(
        builder: (context) {
        final tiles = _saved.map((pair) {
          return new ListTile(
              title: new Text(
            pair.asPascalCase,
            style: _biggerFont,
          ));
        });
        final divided = ListTile.divideTiles(context: context, tiles: tiles).toList();

        return new Scaffold(
          appBar: new AppBar(
            title: new Text('Saved Suggessions'),
          ),
          body: new ListView(children: divided,),
        );
      }),
    );
  }

  Widget _buildSuggesstions() {
    return new ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemBuilder: (context, i) {
        if (i.isOdd) return new Divider();

        final index = i ~/ 2;
        if (index >= _suggessions.length) {
          _suggessions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggessions[index]);
      },
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);
    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: new Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          print(alreadySaved);
          print(_saved);
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },
    );
  }
}
