import 'package:pheditor/services/auth_service.dart';
import 'package:pheditor/services/cloudinary_service.dart';
import 'package:pheditor/services/connectivity_service.dart';
import 'package:pheditor/repositories/image_repository.dart';

/// Service Locator
class GlobalDependencies {
  static final authService = AuthService();
  static final cloudinaryService = CloudinaryService();
  static final imageRepository = ImageRepository();
  static final connectivityService = ConnectivityService();
}
