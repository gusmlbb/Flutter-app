import 'package:flutter/material.dart';

void main() => runApp(VocabApp());

class VocabApp extends StatelessWidget { @override Widget build(BuildContext context) { return MaterialApp( title: 'Kelime Pratik', theme: ThemeData(primarySwatch: Colors.blue), home: HomePage(), ); } }

class Word { final String english; final String turkish; int wrongCount;

Word(this.english, this.turkish, {this.wrongCount = 0}); }

class HomePage extends StatelessWidget { final List<Word> words = [];

@override Widget build(BuildContext context) { return Scaffold( appBar: AppBar(title: Text('Kelime Pratik')), body: Center( child: Column( mainAxisAlignment: MainAxisAlignment.center, children: [ ElevatedButton( onPressed: () => Navigator.push( context, MaterialPageRoute(builder: (context) => AddWordPage(words)), ), child: Text('Kelime Ekle'), ), ElevatedButton( onPressed: () => Navigator.push( context, MaterialPageRoute(builder: (context) => QuizPage(words)), ), child: Text('Test Ol'), ), ElevatedButton( onPressed: () => Navigator.push( context, MaterialPageRoute(builder: (context) => WrongWordsPage(words)), ), child: Text('Yanlış Yapılanları Tekrarla'), ), ], ), ), ); } }

class AddWordPage extends StatefulWidget { final List<Word> words; AddWordPage(this.words);

@override _AddWordPageState createState() => _AddWordPageState(); }

class _AddWordPageState extends State<AddWordPage> { final englishController = TextEditingController(); final turkishController = TextEditingController();

void addWord() { final english = englishController.text.trim(); final turkish = turkishController.text.trim(); if (english.isNotEmpty && turkish.isNotEmpty) { setState(() { widget.words.add(Word(english, turkish)); }); englishController.clear(); turkishController.clear(); } }

void deleteWord(int index) { setState(() { widget.words.removeAt(index); }); }

@override Widget build(BuildContext context) { return Scaffold( appBar: AppBar(title: Text('Kelime Ekle')), body: Padding( padding: const EdgeInsets.all(16.0), child: Column( children: [ TextField( controller: englishController, decoration: InputDecoration(labelText: 'İngilizce'), ), TextField( controller: turkishController, decoration: InputDecoration(labelText: 'Türkçe'), ), SizedBox(height: 16), ElevatedButton( onPressed: addWord, child: Text('Ekle'), ), SizedBox(height: 16), Expanded( child: ListView.builder( itemCount: widget.words.length, itemBuilder: (context, index) { final word = widget.words[index]; return ListTile( title: Text('${word.english} - ${word.turkish}'), trailing: IconButton( icon: Icon(Icons.delete), onPressed: () => deleteWord(index), ), ); }, ), ) ], ), ), ); } }

class QuizPage extends StatefulWidget { final List<Word> words; QuizPage(this.words);

@override _QuizPageState createState() => _QuizPageState(); }

class _QuizPageState extends State<QuizPage> { int currentIndex = 0; final answerController = TextEditingController(); String feedback = ''; int score = 0; bool isFinished = false;

void checkAnswer() { final answer = answerController.text.trim().toLowerCase(); final correct = widget.words[currentIndex].turkish.toLowerCase(); setState(() { if (answer == correct) { feedback = 'Doğru!'; score++; } else { feedback = 'Yanlış! Doğru cevap: $correct'; widget.words[currentIndex].wrongCount++; } answerController.clear(); if (currentIndex < widget.words.length - 1) { currentIndex++; } else { feedback += ' Test bitti. Skor: $score'; isFinished = true; } }); }

@override Widget build(BuildContext context) { if (widget.words.isEmpty) { return Scaffold( appBar: AppBar(title: Text('Test Ol')), body: Center(child: Text('Önce kelime eklemelisin.')), ); }

return Scaffold(
  appBar: AppBar(title: Text('Test Ol')),
  body: Padding(
    padding: const EdgeInsets.all(16.0),
    child: Column(
      children: [
        if (!isFinished) Text('Kelime: ${widget.words[currentIndex].english}', style: TextStyle(fontSize: 20)),
        if (!isFinished) TextField(
          controller: answerController,
          decoration: InputDecoration(labelText: 'Türkçesini yaz'),
        ),
        SizedBox(height: 16),
        if (!isFinished) ElevatedButton(
          onPressed: checkAnswer,
          child: Text('Cevapla'),
        ),
        SizedBox(height: 16),
        Text(feedback, style: TextStyle(fontSize: 18, color: Colors.blue)),
      ],
    ),
  ),
);

} }

class WrongWordsPage extends StatelessWidget { final List<Word> words; WrongWordsPage(this.words);

@override Widget build(BuildContext context) { final wrongWords = words.where((w) => w.wrongCount > 0).toList();

return Scaffold(
  appBar: AppBar(title: Text('Yanlış Yapılanlar')), 
  body: ListView.builder(
    itemCount: wrongWords.length,
    itemBuilder: (context, index) {
      final word = wrongWords[index];
      return ListTile(
        title: Text('${word.english} - ${word.turkish}'),
        subtitle: Text('Yanlış sayısı: ${word.wrongCount}'),
      );
    },
  ),
);

} }

