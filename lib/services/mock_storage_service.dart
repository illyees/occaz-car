class MockStorageService {
  // Liste d'images de voitures variées pour les uploads mock
  final List<String> _carImageUrls = [
    'https://images.unsplash.com/photo-1494976388531-d1058494cdd8?w=800&q=80',
    'https://images.unsplash.com/photo-1549317661-bd32c8ce0db2?w=800&q=80',
    'https://images.unsplash.com/photo-1603584173870-7f23fdae1b7a?w=800&q=80',
    'https://images.unsplash.com/photo-1583121274602-3e2820c69888?w=800&q=80',
    'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?w=800&q=80',
    'https://images.unsplash.com/photo-1555215695-3004980ad54e?w=800&q=80',
  ];

  Future<String?> uploadImageFile(dynamic imageFile, String path) async {
    await Future.delayed(const Duration(seconds: 1));
    // Retourne une URL d'image aléatoire de voiture
    final randomIndex = DateTime.now().millisecond % _carImageUrls.length;
    return _carImageUrls[randomIndex];
  }

  Future<String?> uploadImage(dynamic image, String path) async {
    return uploadImageFile(image, path);
  }

  Future<List<String>> uploadMultipleImages(List<dynamic> images, String path) async {
    await Future.delayed(const Duration(seconds: 2));
    // Retourne des URLs d'images variées de voitures
    return List.generate(
      images.length,
      (index) => _carImageUrls[index % _carImageUrls.length],
    );
  }

  Future<void> deleteImage(String imageUrl) async {
    await Future.delayed(const Duration(milliseconds: 300));
    print('Image deleted: $imageUrl');
  }
}
