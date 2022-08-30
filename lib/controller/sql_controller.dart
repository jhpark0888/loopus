import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:loopus/constant.dart';
import 'package:loopus/model/message_model.dart';
import 'package:loopus/model/socket_message_model.dart';
import 'package:loopus/model/user_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SQLController extends GetxController {
  static SQLController get to => Get.find();
  Database? database;
  String? myId;
  @override
  void onInit() async {
    // TODO: implement onInit
    myId = await const FlutterSecureStorage().read(key: "id");
    database = await opendb(myId!);

    super.onInit();
  }

  Future<Database> opendb(String myId) async {
    if (database != null) return database!;
    return openDatabase(
      // 데이터베이스 경로를 지정합니다. 참고: `path` 패키지의 `join` 함수를 사용하는 것이
      // 각 플랫폼 별로 경로가 제대로 생성됐는지 보장할 수 있는 가장 좋은 방법입니다.
      join(await getDatabasesPath(), 'MY_database$myId.db'),
      onCreate: (db, version) {
        db.execute(
          "CREATE TABLE user(user_id INTEGER PRIMARY KEY, real_name TEXT, profile_image TEXT)",
        );
        db.execute(
          "CREATE TABLE chatroom(room_id INTEGER PRIMARY KEY AUTOINCREMENT, user_id INTEGER, message Text, date Text, not_read INTEGER , alarm_active INTEGER)",
        );
        db.execute(
          "CREATE TABLE chatting(id INTEGER PRIMARY KEY AUTOINCREMENT,msg_id INTEGER,sender INTEGER, date TEXT, is_read TEXT, message TEXT, room_id INTEGER, send_success Text)",
        );
      },

      version: 1,
    );
  }

  Future<void> insertUser(User user) async {
    final Database db = await database!;
    await db.insert(
      'user',
      {
        "real_name": user.realName,
        "user_id": user.userid,
        "profile_image": user.profileImage
      },
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

  Future<void> updateLastMessage(
      String content, String date, int roomId) async {
    final Database db = await database!;
    db.rawUpdate('UPDATE chatroom SET message = ?,date = ? WHERE room_id = ?',
        [content, date.toString(), roomId]).then((value) {
      print(value);
    });
  }

  Future<void> updateNotReadCount(int roomId, int read) async {
    final Database db = await database!;
    if (read == 0) {
      db.rawUpdate('UPDATE chatroom SET not_read = ? WHERE room_id = ?',
          [read, roomId]).then((value) {
        print(value);
      });
    } else {
      db.rawUpdate('UPDATE chatroom SET not_read = ? WHERE room_id = ?',
          [read, roomId]).then((value) {
        print(value);
      });
    }
  }

  Future<void> insertMessageRoom(ChatRoom chatRoom) async {
    final Database db = await database!;
    await db.insert(
      'chatroom',
      chatRoom.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    print('추가되었습니다/');
  }

  Future<void> deleteMessageRoom(int roomId) async {
    final Database db = await database!;
    await db.rawDelete('DELETE FROM chatroom WHERE room_id = ?', [roomId]).then(
        (value) {
      if (value == 0) {
        print('존재하지 않는 roomId입니다.');
      } else {
        print('삭제되었습니다.');
      }
    });
  }

  Future<void> deleteMessage(int roomId) async {
    final Database db = await database!;

    await db.rawDelete('DELETE FROM chatting WHERE room_id = ?', [roomId]).then(
        (value) {
      if (value == 0) {
        print('존재하지 않는 roomId입니다.');
      } else {
        print('삭제되었습니다.');
      }
    });
  }

  Future<void> deleteUser(int userId) async {
    final Database db = await database!;
    await db.rawDelete('DELETE FROM user WHERE user_id = ?', [userId]).then(
        (value) {
      if (value == 0) {
        print('존재하지 않는 userId입니다.');
      } else {
        print('삭제되었습니다.');
      }
    });
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
            id: maps[index]['id'],
            content: maps[index]['message'],
            date: DateTime.parse(maps[index]['date']),
            sender: maps[index]['sender'].toString(),
            isRead: maps[index]['is_read'] == 'true' ? true.obs : false.obs,
            messageId: maps[index]['msg_id'].toString(),
            roomId: maps[index]['room_id'],
            sendsuccess: RxString(maps[index]['send_success']));
      });
      return messageList;
    }
  }

  Future<int> getLastmessageId(int roomid) async {
    final Database db = await database!;
    final List<Map<String, dynamic>> maps;
    maps = await db.rawQuery(
        'SELECT * FROM chatting WHERE room_id = $roomid ORDER BY msg_id DESC LIMIT 1');
    if (maps.isEmpty) {
      return 0;
    } else {
      int? id = maps.first['msg_id'];
      return id!;
    }
  }

  Future<List<ChatRoom>> getDBMessageRoom({ChatRoom? chatRoom}) async {
    final Database db = await database!;
    final List<Map<String, dynamic>> maps;

    maps = await db.rawQuery('SELECT * FROM chatroom');

    if (maps.isEmpty) {
      if (chatRoom != null) {
        await insertMessageRoom(chatRoom);
      }
      return [];
    } else {
      List<ChatRoom> messageList = List.generate(maps.length, (index) {
        return ChatRoom(
            message: Chat.fromJson({
              "content": maps[index]['message'],
              "date": maps[index]['date']
            }).obs,
            user: maps[index]['user_id'],
            notread: RxInt(maps[index]['not_read']),
            type: RxInt(maps[index]['alarm_active']),
            roomId: maps[index]['room_id']);
      });
      messageList
          .sort((a, b) => b.message.value.date.compareTo(a.message.value.date));
      for (var i in messageList) {
        print(i.message.value.content);
      }
      return messageList;
    }
  }

  Future<bool> findMessageRoom(
      {required int roomid, required Map<String, dynamic> chatRoom}) async {
    final Database db = await database!;
    final List<Map<String, dynamic>> maps;
    maps =
        await db.rawQuery('SELECT * FROM chatroom WHERE room_id = ?', [roomid]);

    if (maps.isEmpty) {
      await db.insert('chatroom', chatRoom);
      print('새로 만들었습니다.');
      return false;
    } else {
      print('존재합니다');
      return true;
    }
  }

  Future<int> updateRoomAlarmActive(int type, int roomId) async {
    final Database db = await database!;
    int alarm_active = type == 0 ? 1 : 0;
    await db.rawUpdate('UPDATE chatroom SET alarm_active = ? WHERE room_id = ?',
        [alarm_active, roomId]).then((value) {
      print(alarm_active);   
    });
    return alarm_active;
  }

  Future<bool> findUser({required int userId, required User user}) async {
    final Database db = await database!;
    final List<Map<String, dynamic>> maps;
    maps = await db.rawQuery('SELECT * FROM user WHERE user_id = ?', [userId]);

    if (maps.isEmpty) {
      insertUser(user);
      print('새로 만들었습니다.');
      return false;
    } else {
      print('존재합니다');
      print(maps);
      return true;
    }
  }

  Future<bool> findNotReadMessage({required int roomid}) async {
    final Database db = await database!;
    final List<Map<String, dynamic>> maps;
    maps = await db.rawQuery('SELECT * FROM chatroom WHERE not_read > ?', [0]);

    if (maps.isEmpty) {
      print('안읽은 메세지가 없습니다.');
      return false;
    } else {
      print('안읽은 메세지가 존재합니다.');
      return true;
    }
  }

  Future<User> getDBUser(int sender) async {
    final Database db = await database!;
    late List<Map<String, dynamic>> maps;

    await db
        .rawQuery('SELECT * FROM user WHERE user_id = $sender')
        .then((value) {
      if (value.isNotEmpty) {
        maps = value;
      } else {
        maps = [];
      }
    });

    if (maps.isEmpty) {
      return User.defaultuser();
    } else {
      print(maps);
      User user = User.fromJson(maps.first);

      return user;
    }
  }

  Future<void> updateUser(String image, int userId) async {
    final Database db = await database!;
    await db.rawUpdate(
        'UPDATE user SET profile_image = ? WHERE user_id = ?', [image, userId]);
  }

  Future<void> updateMessage(String sendSuccess, int newMsgId, String isRead,
      String date, int userId, int roomId, int oldMsgId) async {
    final Database db = await database!;
    print('$oldMsgId에서 $newMsgId로 바뀜');
    await db.rawQuery(
        'UPDATE chatting SET send_success = ?, msg_id = ?, is_read = ?, date = ? WHERE sender = ? and room_id = ? and msg_id = ?',
        [sendSuccess, newMsgId, isRead, date, userId, roomId, oldMsgId]);
  }
}
