import 'package:flutter/material.dart';
import 'package:kp/models/FAQ.dart';
import 'package:kp/services/faq_handler.dart';
import 'package:provider/provider.dart';
import 'package:kp/services/database_notifier.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpScreen extends StatefulWidget {
  @override
  _HelpScreenState createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  late Future<List<FAQ>> _faqsFuture;


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
        actions: [
          IconButton(
            onPressed: () => _launchUrl('+375256615859'),
            icon: Icon(Icons.phone),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFAQsList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFAQsList() {
    return Expanded(
      child: FutureBuilder(
        future: _faqsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final data = snapshot.data![index];
                return ExpansionTile(
                  title: Text('question: ${data.question}'),
                  children: [
                    Text('answer: ${data.answer}'),
                  ],
                );
              },
            );
          }
        },
      ),
    );
  }

  Future<void> _launchUrl(String phoneNum) async {
    Uri _url = Uri.parse('tel:${phoneNum}');
    if (!await launchUrl(_url)) {
      throw Exception('Could not launch $_url');
    }
  }

}
