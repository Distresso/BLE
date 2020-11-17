import 'dart:io';
import 'dart:async';
import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';

class FileHelper {
  static const MIN_WIDTH = 900;
  static const MIN_HEIGHT = 900;
  static const QUALITY = 95;

  static FileHelper _instance;

  factory FileHelper() => _instance ??= new FileHelper._();

  FileHelper._();

  // Future<String> uploadSingleImage({@required String filePath, @required String fileName, @required StorageReference storageRef, @required bool forProfile}) async {
  //   File exportFile = File(filePath);
  //   Uint8List list = await exportFile.readAsBytes();
  //   await exportFile.writeAsBytes(await compressList(list));
  //   StorageUploadTask uploadTask = storageRef.child('$fileName').putFile(exportFile);
  //
  //   if (forProfile) {
  //     return await (await uploadTask.onComplete).ref.getDownloadURL();
  //   } else {
  //     return await (await uploadTask.onComplete).ref.getPath();
  //   }
  // }

  Future<List<int>> compressList(List<int> list) async {
    var result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: MIN_HEIGHT,
      minWidth: MIN_WIDTH,
      quality: QUALITY,
      format: CompressFormat.jpeg,
      keepExif: true,
    );
    return result;
  }

  String fileNameFromDownloadUrl(String url) {
    Uri uri = Uri.parse(url);
    String path = uri.pathSegments.last;
    List<String> components = path.split("/");
    return components.last;
  }

  // Future<String> refreshDownloadURL(String url) async {
  //   Uri uri = Uri.parse(url);
  //   String path = uri.pathSegments.last;
  //   StorageReference storageRef = FirebaseStorage.instance.ref().child(path);
  //   String downloadUrl = await storageRef.getDownloadURL();
  //   print(uri);
  //   return downloadUrl;
  // }

  Future<File> imageFromGallery() async {
    //TODO update name to single image
    PickedFile pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);
    return File(pickedFile.path);
  }

  Future<File> imageFromCamera() async {
    PickedFile pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    return File(pickedFile.path);
  }
}
