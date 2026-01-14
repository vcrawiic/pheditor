import 'package:pheditor/services/auth_service.dart';
import 'package:pheditor/services/cloudinary_service.dart';
import 'package:pheditor/repositories/image_repository.dart';

class GlobalDependencies {
  static final AuthService authService = AuthService();
  static final CloudinaryService cloudinaryService = CloudinaryService();
  static final ImageRepository imageRepository = ImageRepository();
}
