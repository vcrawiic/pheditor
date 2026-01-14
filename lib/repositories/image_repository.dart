import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pheditor/models/image_model.dart';

class ImageRepository {
  final FirebaseFirestore _firestore;

  ImageRepository({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> get _imagesCollection =>
      _firestore.collection('images');

  Future<List<ImageModel>> getUserImages(String userId) async {
    final snapshot = await _imagesCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();

    return snapshot.docs.map((doc) => ImageModel.fromFirestore(doc)).toList();
  }

  Future<ImageModel?> getImageById(String imageId) async {
    final doc = await _imagesCollection.doc(imageId).get();
    if (!doc.exists) return null;
    return ImageModel.fromFirestore(doc);
  }

  Future<ImageModel> saveImage({
    required String userId,
    required String url,
    String? title,
  }) async {
    final now = DateTime.now();
    final docRef = await _imagesCollection.add({
      'userId': userId,
      'url': url,
      'title': title,
      'createdAt': Timestamp.fromDate(now),
    });

    return ImageModel(
      id: docRef.id,
      userId: userId,
      url: url,
      title: title,
      createdAt: now,
    );
  }

  Future<void> updateImage(ImageModel image) async {
    await _imagesCollection.doc(image.id).update(image.toFirestore());
  }

  Future<void> deleteImage(String imageId) async {
    await _imagesCollection.doc(imageId).delete();
  }
}
