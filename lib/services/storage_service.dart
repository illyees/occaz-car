import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:image_picker/image_picker.dart';

class StorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Upload pour Web et Mobile
  Future<String?> uploadImageFile(dynamic imageFile, String path) async {
    try {
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = _storage.ref().child(path).child(fileName);
      
      if (kIsWeb && imageFile is XFile) {
        // Upload pour Web
        final bytes = await imageFile.readAsBytes();
        UploadTask uploadTask = ref.putData(
          bytes,
          SettableMetadata(contentType: 'image/jpeg'),
        );
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      } else if (imageFile is File) {
        // Upload pour Mobile
        UploadTask uploadTask = ref.putFile(imageFile);
        TaskSnapshot snapshot = await uploadTask;
        String downloadUrl = await snapshot.ref.getDownloadURL();
        return downloadUrl;
      }
      return null;
    } catch (e) {
      if (kDebugMode) {
        print('Error uploading image: $e');
      }
      return null;
    }
  }

  // Version legacy pour compatibilité
  Future<String?> uploadImage(File image, String path) async {
    return uploadImageFile(image, path);
  }

  Future<List<String>> uploadMultipleImages(
      List<dynamic> images, String path) async {
    List<String> imageUrls = [];
    for (var image in images) {
      String? url = await uploadImageFile(image, path);
      if (url != null) {
        imageUrls.add(url);
      }
    }
    return imageUrls;
  }

  Future<void> deleteImage(String imageUrl) async {
    try {
      Reference ref = _storage.refFromURL(imageUrl);
      await ref.delete();
    } catch (e) {
      if (kDebugMode) {
        print('Error deleting image: $e');
      }
    }
  }
}

