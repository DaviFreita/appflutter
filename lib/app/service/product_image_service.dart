import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProductImageService {
  final SupabaseClient supabase = Supabase.instance.client;

  final ImagePicker _picker = ImagePicker();

  final List<String> allowedExtensions = [
    'png',
    'jpg',
    'jpeg',
    'webp',
    'heic',
    'heif',
  ];

  Future<File?> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image == null) return null;

    final file = File(image.path);

    _validateImage(file);

    return file;
  }

  void _validateImage(File file) {
    final extension = file.path.split('.').last.toLowerCase();

    if (!allowedExtensions.contains(extension)) {
      throw Exception(
        'Formato inválido. Use PNG, JPG, JPEG, WebP, HEIC ou HEIF.',
      );
    }

    final sizeInBytes = file.lengthSync();
    final sizeInMB = sizeInBytes / (1024 * 1024);

    if (sizeInMB > 5) {
      throw Exception('Imagem muito grande. Máximo permitido: 5MB.');
    }
  }

  Future<String> uploadImage(File imageFile) async {
    final extension = imageFile.path.split('.').last.toLowerCase();

    final fileName = '${DateTime.now().millisecondsSinceEpoch}.$extension';

    await supabase.storage.from('imageProducts').upload(fileName, imageFile);

    return supabase.storage.from('imageProducts').getPublicUrl(fileName);
  }

  Future<void> deleteImageByPath(String path) async {
    if (path.trim().isEmpty) return;

    await supabase.storage.from('imageProducts').remove([path]);
  }

  String? getPathFromPublicUrl(String imageUrl) {
    if (imageUrl.trim().isEmpty) return null;

    final uri = Uri.tryParse(imageUrl);

    if (uri == null) return null;

    final marker = '/storage/v1/object/public/imageProducts/';

    if (!imageUrl.contains(marker)) return null;

    return imageUrl.split(marker).last;
  }

  Future<void> deleteImageByUrl(String imageUrl) async {
    final path = getPathFromPublicUrl(imageUrl);

    if (path == null || path.isEmpty) return;

    await deleteImageByPath(path);
  }
}
