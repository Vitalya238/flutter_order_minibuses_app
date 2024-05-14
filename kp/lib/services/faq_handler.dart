import 'package:sqflite/sqflite.dart';
import 'package:kp/models/FAQ.dart';

const String faqTableName = 'FAQ';
const String columnID = 'FAQID';
const String columnQuestion = 'QUESTION';
const String columnAnswer = 'ANSWER';

class FAQHandler {
  late Database db;

  FAQHandler(this.db);

  Future createTable() async {
    await db.execute('''
        create table IF NOT EXISTS $faqTableName (
          $columnID INTEGER PRIMARY KEY autoincrement,
          $columnQuestion TEXT not null,
          $columnAnswer TEXT not null)
      ''');
  }

  Future<int> insert(FAQ faq) async {
    return await db.insert(faqTableName, faq.toMap());
  }

  Future<FAQ?> getFAQ(int id) async {
    List<Map> maps = await db.query(
      faqTableName,
      columns: [columnID, columnQuestion, columnAnswer],
      where: '$columnID = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return FAQ.fromMap(maps.first);
    }
    return null;
  }

  Future<int> delete(int id) async {
    return await db.delete(faqTableName, where: '$columnID = ?', whereArgs: [id]);
  }

  Future<int> update(FAQ faq) async {
    return await db.update(faqTableName, faq.toMap(), where: '$columnID = ?', whereArgs: [faq.id]);
  }

  Future<List<FAQ>> getAllFAQs() async {
    List<Map<String, dynamic>> maps = await db.query(faqTableName);
    List<FAQ> faqs = [];
    for (var map in maps) {
      faqs.add(FAQ.fromMap(map));
    }
    return faqs;
  }

  Future close() async => db.close();
}
