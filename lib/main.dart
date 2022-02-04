import 'package:english_words/english_words.dart';
import "package:flutter/material.dart";


void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget{
  const MyApp({Key? key}) : super(key:key);

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      title: "Welcome to flutter",
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
            backgroundColor: Colors.yellow,
            foregroundColor: Colors.black
        )
      ),
      home: RandomWords()
    );
  }
}
class RandomWords extends StatefulWidget{
  @override
  _RandomWordsState createState() => _RandomWordsState();
}
class _RandomWordsState extends State<RandomWords>{
  final _saved = <WordPair>{};
  final _suggestions = <WordPair>[];
  final _biggerFont = const TextStyle(fontSize: 18);

  @override
  Widget build(BuildContext context){
    //final wordPair = WordPair.random();
    //return Text(wordPair.asPascalCase);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Startup Name Generator"),
        actions: [
          IconButton(
              onPressed: _pushSaved,
              icon: const Icon(Icons.list),
            tooltip: "Saved Suggestions",
          )
        ],
      ),
      body: _buildSuggestion(),
    );
  }
  Widget _buildSuggestion(){

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, i){
        if(i.isOdd){
          return  const Divider();
        }
        // The syntax "i ~/ 2" divides i by 2 and returns an
        // integer result.
        // For example: 1, 2, 3, 4, 5 becomes 0, 1, 1, 2, 2.
        // This calculates the actual number of word pairings
        // in the ListView,minus the divider widgets.
        final index = i ~/ 2;
        // If you've reached the end of the available word
        // pairings...
        if (index >= _suggestions.length) {
          // ...then generate 10 more and add them to the
          // suggestions list.
          _suggestions.addAll(generateWordPairs().take(10));
        }
        return _buildRow(_suggestions[index]);
      },
    );
  }
  Widget _buildRow(WordPair pair){
    // check to ensure that a word pairing has not already
    // been added to favorites
    final alreadySaved = _saved.contains(pair);

    return ListTile(
      title: Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      trailing: Icon(
        alreadySaved ? Icons.favorite : Icons.favorite_border,
        color: alreadySaved ? Colors.red : null,
        semanticLabel: alreadySaved? 'Removed from saved': 'Save',
      ),
      onTap: (){
        setState(() {
          if(alreadySaved){
            _saved.remove(pair);
          }else{
            _saved.add(pair);
          }
        });
      }
    );
  }

  void _pushSaved(){
    Navigator.of(context).push(
      MaterialPageRoute<void>(
          builder: (context){
            final tiles = _saved.map(
                (pair){
                  return ListTile(
                    title: Text(
                      pair.asPascalCase,
                      style: _biggerFont
                    ),
                  );
                },
            );
            final divided = tiles.isNotEmpty
              ? ListTile.divideTiles(
                context: context,
                tiles: tiles,
              ).toList()
                : <Widget>[];

            return Scaffold(
              appBar: AppBar(
                title: const Text("Saved Suggestions"),
              ),
              body: ListView(children:divided),
            );
          },
      )
    );
  }
}



