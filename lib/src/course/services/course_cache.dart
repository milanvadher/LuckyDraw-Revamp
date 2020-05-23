import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:youth_app/src/utils/cachedata.dart';

class CourseCache {
  DatabaseFactory dbFactory = databaseFactoryIo;
  var store = StoreRef.main();

  String _getPhoneNumber() {
    return CacheData.userInfo.contactNumber;
    // return "1234";
  }
  setQuizOver(int sessionId) async {
  
    String dbPath =  _getPhoneNumber() + "_" +"session_" + sessionId.toString();
    Database db = await _getDB(dbPath);
    await store.record("quiz_over").put(db, true);
  }

  setVideoOver(int sessionId) async {
    print("setting video true");
    String dbPath =  _getPhoneNumber() + "_" +"session_" + sessionId.toString();
    Database db = await _getDB(dbPath);
    await store.record("video_over").put(db, true);
  }

  Future<bool> getVideoStatus(int sessionId) async {
    String dbPath = _getPhoneNumber() + "_" +"session_" + sessionId.toString();
    Database db = await _getDB(dbPath);
    return await store.record("video_over").get(db) as bool;
  }

  Future<bool> getQuizStatus(int sessionId) async {
    String dbPath = _getPhoneNumber() + "_" +"session_" + sessionId.toString();
    Database db = await _getDB(dbPath);
    return await store.record("quiz_over").get(db) as bool;
  }

  Future<Database> _getDB(dbPath) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    Database db = await databaseFactoryIo
        .openDatabase(join(appDocDir.path, dbPath), version: 1);
    return db;
  }
}
