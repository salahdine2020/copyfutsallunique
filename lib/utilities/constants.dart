//todo: import 'package:cloud_firestore/cloud_firestore.dart';
//todo: import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';


final _firestore = FirebaseFirestore.instance;
final storageRef = FirebaseStorage.instance.ref();
final usersRef = _firestore.collection('users01');
final postsRef = _firestore.collection('posts');
final followersRef = _firestore.collection('followers');
final followingRef = _firestore.collection('following');
final feedsRef = _firestore.collection('feeds');
final likesRef = _firestore.collection('likes');
final commentsRef = _firestore.collection('comments');
final activitiesRef = _firestore.collection('activities');
final archivedPostsRef = _firestore.collection('archivedPosts');
final deletedPostsRef = _firestore.collection('deletedPosts');
final chatsRef = _firestore.collection('chats');
final storiesRef = _firestore.collection('stories');
final String user = 'userFeed';
final String usersFollowers = 'userFollowers';
final String userFollowing = 'userFollowing';
final String placeHolderImageRef = 'assets/images/user_placeholder.jpg';
final DateFormat timeFormat = DateFormat('E, h:mm a');
//final String placeHolderImageRef = 'assets/images/user_placeholder.png';
final String placeHolderIconLogo = 'assets/images/logoappicon.png';
final String imagesalle1 = 'assets/images/imagesalle1.jpg';
final String imagesalle2 = 'assets/images/imagesalle02.jpg';
final String imagesalle3 = 'assets/images/imagesalle3.jpg';
final imagelogo = 'assets/images/logotanflite.PNG';

const TIME_SLOT = {
  '08:00 - 09:00',
  '09:00 - 10:00',
  '10:00 - 11:00',
  '11:00 - 12:00',
  '12:00 - 13:00',
  '13:00 - 14:00',
  '14:00 - 15:00',
  '15:00 - 16:00',
  '16:00 - 17:00',
  '17:00 - 18:00',
  '18:00 - 19:00',
  '19:00 - 20:00',
  '20:00 - 21:00',
  '21:00 - 22:00',
  '22:00 - 23:00',
  '23:00 - 00:00',
};
enum PostStatus {
  feedPost,
  deletedPost,
  archivedPost,
}

enum SearchFrom {
  messagesScreen,
  homeScreen,
  createStoryScreen,
}

enum CameraConsumer {
  post,
  story,
}
