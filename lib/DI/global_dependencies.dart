import 'package:pheditor/services/auth_service.dart';
import 'package:pheditor/services/cloudinary_service.dart';
import 'package:pheditor/services/connectivity_service.dart';
import 'package:pheditor/repositories/image_repository.dart';

/// Service Locator - глобальный доступ к сервисам и репозиториям
class GlobalDependencies {
  static final AuthService authService = AuthService();
  static final CloudinaryService cloudinaryService = CloudinaryService();
  static final ImageRepository imageRepository = ImageRepository();
  static final ConnectivityService connectivityService = ConnectivityService();

  static Future<void> init() async {
    await connectivityService.init();
  }

  static void dispose() {
    connectivityService.dispose();
  }
}
