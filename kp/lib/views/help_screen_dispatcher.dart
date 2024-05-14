import 'package:flutter/material.dart';
import 'package:kp/models/FAQ.dart';
import 'package:kp/services/faq_handler.dart';
import 'package:provider/provider.dart';
import 'package:kp/services/database_notifier.dart';

class HelpScreenDispathcer extends StatefulWidget {
  @override
  _HelpScreenDispathcerState createState() => _HelpScreenDispathcerState();
}

class _HelpScreenDispathcerState extends State<HelpScreenDispathcer> {
  late Future<List<FAQ>> _faqsFuture;
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  late FAQ _selectedFAQ;

  @override
  void initState() {
    super.initState();
    _faqsFuture = _getAllFAQs();
  }

  Future<List<FAQ>> _getAllFAQs() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    FAQHandler faqHandler = FAQHandler(dbHelper.db);

    return faqHandler.getAllFAQs();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.amberAccent,
        title: const Text(
          'FAQs',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAddFAQForm(),
            SizedBox(height: 20),
            _buildFAQsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildAddFAQForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Add FAQ',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _questionController,
          decoration: InputDecoration(
            labelText: 'Question',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _answerController,
          decoration: InputDecoration(
            labelText: 'Answer',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _addFAQ,
          child: Text('Add FAQ'),
        ),
      ],
    );
  }

  void _addFAQ() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    FAQHandler faqHandler = FAQHandler(dbHelper.db);

    String question = _questionController.text;
    String answer = _answerController.text;

    if (question.isNotEmpty && answer.isNotEmpty) {
      FAQ newFAQ = FAQ(question, answer);
      await faqHandler.insert(newFAQ);
      setState(() {
        _faqsFuture = _getAllFAQs();
        _questionController.clear();
        _answerController.clear();
      });
    }
  }

  Widget _buildFAQsList() {
    return Expanded(
      child: FutureBuilder(
        future: _faqsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<FAQ> faqs = snapshot.data as List<FAQ>;
            return ListView.builder(
              itemCount: faqs.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('${faqs[index].question}'),
                  subtitle: Text('${faqs[index].answer}'),
                  onTap: () {
                    _editFAQ(context, faqs[index]);
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () {
                      _deleteFAQ(context, faqs[index]);
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  void _editFAQ(BuildContext context, FAQ faq) {
    setState(() {
      _selectedFAQ = faq;
      _questionController.text = faq.question;
      _answerController.text = faq.answer;
    });
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit FAQ'),
          content: _buildEditFAQForm(),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                _saveEditedFAQ();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildEditFAQForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: _questionController,
          decoration: InputDecoration(
            labelText: 'Question',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _answerController,
          decoration: InputDecoration(
            labelText: 'Answer',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }

  void _saveEditedFAQ() async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    FAQHandler faqHandler = FAQHandler(dbHelper.db);

    String question = _questionController.text;
    String answer = _answerController.text;

    if (question.isNotEmpty && answer.isNotEmpty) {
      FAQ updatedFAQ = FAQ(question, answer);
      updatedFAQ.id = _selectedFAQ.id;
      await faqHandler.update(updatedFAQ);
      setState(() {
        _faqsFuture = _getAllFAQs();
        _questionController.clear();
        _answerController.clear();
      });
    }
  }

  void _deleteFAQ(BuildContext context, FAQ faq) async {
    final dbHelper = Provider.of<DatabaseNotifier>(context, listen: false).databaseHelper;
    await dbHelper.init();
    FAQHandler faqHandler = FAQHandler(dbHelper.db);

    await faqHandler.delete(faq.id);
    setState(() {
      _faqsFuture = _getAllFAQs();
    });
  }
}
