import 'dart:io';

/// Service de stockage mock pour tester sans Firebase Storage
class MockStorageService {
  Future<String?> uploadImage(File image, String path) async {
    // Simuler un délai d'upload
    await Future.delayed(const Duration(seconds: 2));
    
    // Retourner une URL mockée (utilise une image placeholder)
    return 'https://images.unsplash.com/photo-1605559424843-9e4c228bf1c2?w=800';
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
    // Simuler la suppression
    await Future.delayed(const Duration(milliseconds: 500));
  }
}









