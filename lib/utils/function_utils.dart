import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class FunctionUtils {
  static Future<dynamic> getImageFromGallery() async{
    ImagePicker picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    return pickedFile;
  }

  //firebase ストレージアップロードメソッド
  static Future<dynamic> uploadImage(String uid, File image) async {
    final FirebaseStorage storageInstance = FirebaseStorage.instance;
    final Reference ref = storageInstance.ref();
    await ref.child(uid).putFile(image);  //　!はnullを回避
    String downloadUrl = await storageInstance.ref(uid).getDownloadURL();
    print('image_path: $downloadUrl');
    return downloadUrl;
    /**
     * firebaseのストレージ➡︎ルールを変更したらできたけどセキュリティ的には大丈夫なのか不安
     * */
  }
}
