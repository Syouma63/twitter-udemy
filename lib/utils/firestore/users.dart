
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:twitter/model/account.dart';
import 'package:twitter/utils/authentication.dart';
import 'package:twitter/utils/firestore/posts.dart';
import 'package:twitter/view/time_line/time_line_page.dart';

class UserFirestore {
  static final _firestoreInstance = FirebaseFirestore.instance;
  static final CollectionReference users = _firestoreInstance.collection('users');

  //firebaseにユーザ情報を保存
  static Future<dynamic> setUser(Account newAccount) async {
    try {
      await users.doc(newAccount.id).set({
        'name': newAccount.name,
        'user_id': newAccount.userId,
        'self_introduction': newAccount.selfIntroduction,
        'image_path': newAccount.imagePath,
        'created_time': Timestamp.now(),
        'updated_time': Timestamp.now(),
        // firebase セキュリティールールを学ぶ必要がある
      });
      print('ユーザ作成完了');
      return true;
    } on FirebaseException catch(e){
      print('ユーザ作成エラー');
      return false;
    }
  }

  static Future<dynamic> getUser(String uid) async{
    try {
      DocumentSnapshot documentSnapshot = await users.doc(uid).get();
      Map<String, dynamic> data = documentSnapshot.data() as Map<String, dynamic>;
      Account myAccount = Account(
        id: uid,
        name:data['name'],
        userId: data['user_id'],
        selfIntroduction: data['self_introduction'],
        imagePath: data['image_path'],
        createdTime: data['created_time'],
        updatedTime: data['updated_time']
      );
      Authentication.myAccount = myAccount;
      print('ユーザ取得完了');
      return true;
    } on FirebaseException catch(e) {
      print('ユーザー取得エラー: $e');
      return false;
    }
  }

  // プロフィール編集処理
  static Future<dynamic> updateUser (Account updateAccount) async{
    try{
      users.doc(updateAccount.id).update({
        'name': updateAccount.name,
        'image_path': updateAccount.imagePath,
        'user_id': updateAccount.userId,
        'self_introduction': updateAccount.selfIntroduction,
        'update_time': Timestamp.now()
      });
      print('ユーザ情報の更新完了');
      return true;
    } on FirebaseException catch(e) {
      print('ユーザ情報の更新エラー');
      return false;
    }
  }

  //タイムライン表示処理
  static Future<Map<String, Account>?> getPostUserMap(List<String> accountIds) async {
    Map<String, Account> map = {};
    try {
      await Future.forEach(accountIds, (String accountId) async{
        var doc = await users.doc(accountId).get();
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        Account postAccount = Account(
          id: accountId,
          name: data['name'],
          userId: data['user_id'],
          imagePath: data['image_path'],
          selfIntroduction: data['self_introduction'],
          createdTime: data['created_time'],
          updatedTime: data['uodated_time']
        );
        map[accountId] = postAccount;
      });
      print('投稿ユーザの情報取得完了');
      return map;
    } on FirebaseException catch(e) {
      print('投稿ユーザの情報取得エラー: $e');
      return null;
    }
  }

  //アカウント削除時にfirebaseのUsersの中身を削除する処理
  static Future<dynamic> deleteUset(String accountId) async{
    await users.doc(accountId).delete();
    PostFirestore.deletePosts(accountId);
  }
}
