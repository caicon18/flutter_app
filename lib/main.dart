// Copyright 2018 The Flutter team. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Startup Name Generator',
      theme: ThemeData(primaryColor: Colors.white),
      home: RandomWords(), // set home to random words widget
    );
  }
}

// stateful widget
class RandomWords extends StatefulWidget {
  const RandomWords({Key? key}) : super(key: key);

  @override
  _RandomWordsState createState() => _RandomWordsState();
}

// generic state class specialized for use with RandomWords
class _RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18.0);
  final _saved = <WordPair>{}; // set of word pairings user has favorited

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Startup Name Generator'), actions: [
        // show selected items when this list icon is pressed
        IconButton(icon: Icon(Icons.list), onPressed: _pushSaved),
      ]),
      body: _buildSuggesstions(),
    );
  }

  Widget _buildSuggesstions() {
    return ListView.builder(
        padding: const EdgeInsets.all(16.0),
        // called once per suggested word pairing
        itemBuilder: (context, i) {
          // add a one-pixel-high divider widget before each row in the ListView
          if (i.isOdd) return const Divider();

          // i incrments twice for every word pairing (for list tile and divider)
          // index is actual number of word pairings
          final index = i ~/ 2;

          // dynamically generate word pairings
          if (index >= _suggestions.length) {
            _suggestions.addAll(generateWordPairs().take(10));
          }

          return _buildRow(_suggestions[index]);
        });
  }

  Widget _buildRow(WordPair pair) {
    // set of saved pairs
    final alreadySaved = _saved.contains(pair);

    return ListTile(
        // randomly generated text
        title: Text(
          pair.asPascalCase,
          style: _biggerFont,
        ),

        // icon at end of row
        trailing: Icon(
          alreadySaved ? Icons.favorite : Icons.favorite_border,
          color: alreadySaved ? Colors.red : null,
        ),

        // changes state of icon when tapped
        onTap: () {
          setState(() {
            if (alreadySaved) {
              _saved.remove(pair);
            } else {
              _saved.add(pair);
            }
          });
        });
  }

  void _pushSaved() {
    // Pushes the route to the navigator's stack (top of stack is current view)
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (BuildContext context) {
          final tiles = _saved.map(
            (WordPair pair) {
              return ListTile(
                title: Text(
                  pair.asPascalCase,
                  style: _biggerFont,
                ),
              );
            },
          );

          final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(context: context, tiles: tiles).toList()
              : <Widget>[];

          // new scaffold to show favorites
          return Scaffold(
            appBar: AppBar(
              title: Text("Saved Suggestions"),
            ),
            body: ListView(children: divided),
          );
        },
      ),
    );
  }
}
