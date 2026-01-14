import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class CloudinaryService {
  static String get _cloudName => dotenv.env['CLOUDINARY_CLOUD_NAME'] ?? '';
  static String get _uploadPreset => dotenv.env['CLOUDINARY_UPLOAD_PRESET'] ?? '';

  static String get _uploadUrl =>
      'https://api.cloudinary.com/v1_1/$_cloudName/image/upload';

  Future<String?> uploadImage(Uint8List imageBytes, String fileName) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));

      request.fields['upload_preset'] = _uploadPreset;
      request.fields['public_id'] = fileName;

      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          imageBytes,
          filename: '$fileName.png',
        ),
      );

      final response = await request.send();
      final responseData = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(responseData);
        return jsonResponse['secure_url'] as String;
      } else {
        print('Cloudinary upload error: $responseData');
        return null;
      }
    } catch (e) {
      print('Cloudinary upload exception: $e');
      return null;
    }
  }

  static String getThumbnailUrl(String originalUrl, {int width = 300}) {
    return originalUrl.replaceFirst(
      '/upload/',
      '/upload/w_$width,c_scale/',
    );
  }
}
