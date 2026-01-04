import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:http/http.dart' as http;
import '../config/mongodb_config.dart';

/// Service de stockage MongoDB GridFS pour remplacer Firebase Storage
/// 
/// Note: Pour une meilleure performance, vous pouvez utiliser un service cloud
/// comme Cloudinary, AWS S3, ou ImgBB pour le stockage d'images
class MongoDBStorageService {
  Db? _db;
  bool _isConnected = false;

  /// Se connecter à MongoDB
  Future<void> _ensureConnected() async {
    if (_isConnected && _db != null) return;

    try {
      _db = await Db.create(MongoDBConfig.connectionString);
      await _db!.open();
      _isConnected = true;
    } catch (e) {
      throw Exception('Erreur de connexion MongoDB: $e');
    }
  }

  /// Uploader une image (utilise GridFS)
  /// 
  /// Note: GridFS dans mongo_dart nécessite une configuration spéciale.
  /// Pour l'instant, on utilise une URL placeholder.
  /// Pour une solution complète, utilisez ImgBBStorageService ou un service cloud.
  Future<String?> uploadImage(File image, String path) async {
    try {
      await _ensureConnected();
      
      // TODO: Implémenter l'upload GridFS correctement
      // Pour l'instant, on retourne une URL placeholder
      // Vous pouvez utiliser ImgBBStorageService à la place
      
      // Lire le fichier pour vérifier qu'il existe
      await image.readAsBytes();
      
      // Retourner une URL placeholder avec un identifiant unique
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      return 'https://via.placeholder.com/150/0000FF/FFFFFF?text=Image_$timestamp';
    } catch (e) {
      // En cas d'erreur, retourner une URL placeholder
      return 'https://via.placeholder.com/150/0000FF/FFFFFF?text=Image';
    }
  }

  /// Uploader plusieurs images
  Future<List<String>> uploadMultipleImages(List<File> images, String path) async {
    List<String> imageUrls = [];
    for (File image in images) {
      String? url = await uploadImage(image, path);
      if (url != null) {
        imageUrls.add(url);
      }
    }
    return imageUrls;
  }

  /// Supprimer une image
  /// 
  /// Note: Pour l'instant, cette méthode ne fait rien car GridFS n'est pas
  /// complètement implémenté. Utilisez ImgBBStorageService pour une solution complète.
  Future<void> deleteImage(String imageUrl) async {
    try {
      // TODO: Implémenter la suppression GridFS correctement
      // Pour l'instant, on ignore la suppression
      if (kDebugMode) {
        print('MongoDBStorageService: Suppression d\'image non implémentée pour $imageUrl');
      }
    } catch (e) {
      // Ignorer les erreurs
    }
  }
}

/// Alternative : Service de stockage avec ImgBB (gratuit et simple)
class ImgBBStorageService {
  // Obtenez votre clé API sur https://api.imgbb.com/
  static const String apiKey = 'VOTRE_CLE_API_IMGBB';

  Future<String?> uploadImage(File image, String path) async {
    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);
      
      final response = await http.post(
        Uri.parse('https://api.imgbb.com/1/upload'),
        body: {
          'key': apiKey,
          'image': base64Image,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['data']['url'];
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> uploadMultipleImages(List<File> images, String path) async {
    List<String> imageUrls = [];
    for (File image in images) {
      String? url = await uploadImage(image, path);
      if (url != null) {
        imageUrls.add(url);
      }
    }
    return imageUrls;
  }

  Future<void> deleteImage(String imageUrl) async {
    // ImgBB ne permet pas la suppression via API gratuite
    // Les images restent sur leurs serveurs
  }
}

