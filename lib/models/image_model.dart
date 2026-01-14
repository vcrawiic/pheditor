import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class ImageModel extends Equatable {
  final String id;
  final String userId;
  final String url;
  final String? title;
  final DateTime createdAt;

  const ImageModel({
    required this.id,
    required this.userId,
    required this.url,
    this.title,
    required this.createdAt,
  });

  factory ImageModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ImageModel(
      id: doc.id,
      userId: data['userId'] as String,
      url: data['url'] as String,
      title: data['title'] as String?,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'url': url,
      'title': title,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  ImageModel copyWith({
    String? id,
    String? userId,
    String? url,
    String? title,
    DateTime? createdAt,
  }) {
    return ImageModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      url: url ?? this.url,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  List<Object?> get props => [id, userId, url, title, createdAt];
}
