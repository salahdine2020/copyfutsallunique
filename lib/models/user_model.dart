import 'package:cloud_firestore/cloud_firestore.dart';

// final List<String> favoritePosts;
// final List<String> blockedUsers;
// final List<String> hideStoryFromUsers;
// final List<String> closeFriends;
// final bool allowStoryMessageReplies;



class UserModelClass {
  final String? id;
  final String? name;
  final String? profileImageUrl;
  final String? email;
  final String? bio;
  final String? token;
  final bool? isBanned; //
  final String? role;
  final bool? isVerified; //
  final String? website;
  final Timestamp? timeCreated; //

  UserModelClass({
    required this.id,
    required this.name,
    required this.profileImageUrl,
    required this.email,
    required this.bio,
    required this.token,
    required this.isBanned,
    required this.isVerified,
    required this.website,
    required this.role,
    this.timeCreated,
  });

  factory UserModelClass.fromDoc(DocumentSnapshot doc) {
    return UserModelClass(
      id: doc.id,
      name: doc['name'] ?? "",
      profileImageUrl: doc['profileImageUrl']?? "",
      email: doc['email'] ?? "",
      bio: doc['bio'] ?? '',
      token: doc['token'] ?? '',
      isVerified: doc['isVerified'] ?? false,
      isBanned: doc['isBanned'] ?? "",
      website: doc['website'] ?? '',
      role: doc['role'] ?? 'user',
      timeCreated: doc['timeCreated'],
    );
  }
}
