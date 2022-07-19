import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLController extends GetxController {
  static SQLController get to => Get.find();
  Database? database;

  @override
  void onInit() async {
    // TODO: implement onInit
    database = await opendb();

    super.onInit();
  }

  Future<Database> opendb() async {
    if (database != null) return database!;
    return openDatabase(
      // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
      // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
      join(await getDatabasesPath(), 'MY_database.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE user(id INTEGER PRIMARY KEY, name TEXT, user_id INTEGER)",
        );
        db.execute(
          "CREATE TABLE chatroom(room_id INTEGER PRIMARY KEY AUTOINCREMENT, user_name Text, image Text, message Text, date Text, not_read INTEGER, del_id INTEGER)",
        );
        db.execute(
          "CREATE TABLE chatting(msg_id INTEGER PRIMARY KEY AUTOINCREMENT,type Text,sender INTEGER, date TEXT, is_read TEXT, message TEXT, room_id INTEGER)",
        );
      },

      version: 1,
    );
  }

  // void tablecreate() async {
  //   database = openDatabase(
  //     // 데이터베이스 경로를 지정합니다.
  //     join(await getDatabasesPath(), 'MY_database.db'),
  //     // 데이터베이스가 처음 생성될 때, dog를 저장하기 위한 테이블을 생성합니다.
  //     onCreate: (db, version) {
  //       // 데이터베이스에 CREATE TABLE 수행
  //       return db.execute(
  //         "CREATE TABLE chats(id INTEGER PRIMARY KEY, name TEXT, text TEXT)",
  //       );
  //     },
  //     // 버전을 설정하세요. onCreate 함수에서 수행되며 데이터베이스 업그레이드와 다운그레이드를
  //     // 수행하기 위한 경로를 제공합니다.
  //     version: 1,
  //   );
  // }

//   Future<void> insertDog(Message chat) async {
//     // 데이터베이스 reference를 얻습니다.
//     final Database db = await database!;

//     // Dog를 올바른 테이블에 추가하세요. 또한
//     // `conflictAlgorithm`을 명시할 것입니다. 본 예제에서는
//     // 만약 동일한 dog가 여러번 추가되면, 이전 데이터를 덮어쓸 것입니다.
//     await db.insert(
//       'chats',
//       chat.toJson(),
//       conflictAlgorithm: ConflictAlgorithm.replace,
//     );
//   }
  Future<void> insertUser(User user) async {
    // 데이터베이스 reference를 얻습니다.
    final Database db = await database!;
    await db.insert(
      'user',
      {"name": user.realName, "user_id": user.userid},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertmessage(Chat chat) async {
    final Database db = await database!;
    await db.insert(
      'chatting',
      chat.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertmessageRoom(ChatRoom chatRoom) async {
    // 데이터베이스 reference를 얻습니다.
    final Database db = await database!;

    // Dog를 올바른 테이블에 추가합니다. 동일한 dog가 두번 추가되는 경우를 처리하기 위해
    // `conflictAlgorithm`을 명시할 수 있습니다.
    //
    // 본 예제에서는, 이전 데이터를 갱신하도록 하겠습니다.

    await db.insert(
      'chatroom',
      chatRoom.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('추가되었습니다/');
  }

  Future<List<Chat>> getDBMessage(int roomid, int msgid) async {
    final Database db = await database!;
    final List<Map<String, dynamic>> maps;
    if (msgid == 0) {
      maps = await db.rawQuery(
          'SELECT * FROM chatting WHERE room_id = $roomid ORDER BY msg_id DESC LIMIT 50');
    } else {
      maps = await db.rawQuery(
          'SELECT * FROM chatting WHERE room_id = $roomid and msg_id < $msgid ORDER BY msg_id DESC LIMIT 50');
    }
    if (maps.isEmpty) {
      return [];
    } else {
      List<Chat> messageList = List.generate(maps.length, (index) {
        return Chat(
            content: maps[index]['message'],
            date: DateTime.parse(maps[index]['date']),
            sender: maps[index]['sender'],
            isRead: maps[index]['is_read'] == 'true' ? true.obs : false.obs,
            messageId: maps[index]['msg_id'],
            type: maps[index]['type'],
            roomId: maps[index]['room_id']);
      });
      return messageList;
    }
  }
}
