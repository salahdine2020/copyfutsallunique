import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:futsal_unique/models/models.dart';
import 'package:futsal_unique/services/services.dart';
import 'package:futsal_unique/utilities/constants.dart';
import 'package:futsal_unique/common_widgets/post_view.dart';

class DeletedPostsScreen extends StatefulWidget {
  final String currentUserId;
  final PostStatus postStatus;
  DeletedPostsScreen({required this.currentUserId, required this.postStatus});
  @override
  _DeletedPostsScreenState createState() => _DeletedPostsScreenState();
}

class _DeletedPostsScreenState extends State<DeletedPostsScreen> {
  List<Post>? _posts;

  @override
  void initState() {
    super.initState();
    _setupPosts();
  }

  _setupPosts() async {
    List<Post> posts = await DatabaseService.getDeletedPosts(
        widget.currentUserId, widget.postStatus);
    setState(() {
      _posts = posts;
    });
  }

  @override
  Widget build(BuildContext context) {
    _buildTilePost(Post post, UserModelClass currentUser) {
      return GridTile(
          child: GestureDetector(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute<bool>(
            builder: (BuildContext context) {
              return Center(
                child: Scaffold(
                    appBar: AppBar(
                      title: Text(widget.postStatus == PostStatus.archivedPost
                          ? 'Archived Post'
                          : 'Deleted Post'),
                    ),
                    body: ListView(
                      children: <Widget>[
                        Container(
                          child: PostView(
                            currentUserId: widget.currentUserId,
                            post: post,
                            author: currentUser,
                            postStatus: widget.postStatus,
                          ),
                        ),
                      ],
                    )),
              );
            },
          ),
        ),
        child: Image(
          image: CachedNetworkImageProvider(post.imageUrl!),
          fit: BoxFit.cover,
        ),
      ));
    }

    _buildPosts(posts, UserModelClass currentUser) {
      List<GridTile> tiles = [];
      posts.forEach((post) => tiles.add(_buildTilePost(post, currentUser)));
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.postStatus == PostStatus.deletedPost
            ? 'Deleted Posts'
            : 'Archived Posts'),
      ),
      body: FutureBuilder(
        future: usersRef.doc(widget.currentUserId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData || _posts == null) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          UserModelClass _currentUser = UserModelClass.fromDoc(snapshot.data);
          return ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[_buildPosts(_posts, _currentUser)],
          );
        },
      ),
    );
  }
}
