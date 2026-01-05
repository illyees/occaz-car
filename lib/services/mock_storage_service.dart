class MockStorageService {
  Future<String?> uploadImageFile(dynamic imageFile, String path) async {
    await Future.delayed(const Duration(seconds: 1));
    // Retourne une URL d'image placeholder
    return 'https://images.unsplash.com/photo-1568605117036-5fe5e7bab0b7?w=800';
  }

  Future<String?> uploadImage(dynamic image, String path) async {
    return uploadImageFile(image, path);
  }

  Future<List<String>> uploadMultipleImages(List<dynamic> images, String path) async {
    await Future.delayed(const Duration(seconds: 2));
    // Retourne des URLs d'images placeholder
    return List.generate(
      images.length,
      (index) => 'https://images.unsplash.com/photo-${1568605117036 + index}-5fe5e7bab0b7?w=800',
    );
  }

  Future<void> deleteImage(String imageUrl) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Image deleted: $imageUrl');
  }
}
