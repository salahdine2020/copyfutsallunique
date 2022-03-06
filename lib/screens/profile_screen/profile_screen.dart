import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:futsal_unique/screens/direct_messages/nested_screens/chat_screen.dart';
import 'package:futsal_unique/screens/feed_screen/widgets/blank_story_circle.dart';
import 'package:futsal_unique/screens/feed_screen/widgets/story_circle.dart';
// import 'package:futsal_unique/screens/feed_screen_test//widgets/blank_story_circle.dart';
// import 'package:futsal_unique/screens/feed_screen_test/widgets/story_circle.dart';
import 'package:futsal_unique/screens/profile_screen/nested_screens/edit_profile_screen.dart';
import 'package:futsal_unique/screens/profile_screen/nested_screens/followers_screen.dart';
import 'package:futsal_unique/screens/profile_screen/widgets/profile_screen_drawer.dart';
import 'package:futsal_unique/utilities/show_error_dialog.dart';
import 'package:futsal_unique/common_widgets/user_badges.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:futsal_unique/models/models.dart';
import 'package:futsal_unique/screens/screens.dart';
import 'package:futsal_unique/services/services.dart';
import 'package:futsal_unique/utilities/constants.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:futsal_unique/common_widgets/post_view.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileScreen extends StatefulWidget {
  final String? userId;
  final String? currentUserId;
  final Function? onProfileEdited;
  final bool isCameFromBottomNavigation;
  final Function goToCameraScreen;
  final List<CameraDescription>? cameras;

  ProfileScreen({
    this.userId,
    this.currentUserId,
    this.onProfileEdited,
    this.cameras,
    required this.goToCameraScreen,
    required this.isCameFromBottomNavigation,
  });

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _isFollowing = false;
  int _followersCount = 0;
  int _followingCount = 0;
  List<Post> _posts = [];
  int _displayPosts = 0; // 0 - grid, 1 - column
  UserModelClass? _profileUser;
  List<Story>? _userStories;
  List<CameraDescription>? _cameras;
  CameraConsumer _cameraConsumer = CameraConsumer.post;

  @override
  initState() {
    super.initState();
    _setupUserStories();
    _setupIsFollowing();
    _setupFollowers();
    _setupFollowing();
    _setupPosts();
    _setupProfileUser();
    _getCameras();
  }

  Future<Null> _getCameras() async {
    if (widget.cameras != null) {
      setState(() {
        _cameras = widget.cameras;
      });
    } else {
      try {
        _cameras = await availableCameras();
      } on CameraException catch (_) {
        ShowErrorDialog.showAlertDialog(errorMessage: 'Cant get cameras!', context: context);
      }
    }
  }

  _setupIsFollowing() async {
    bool isFollowingUser = await DatabaseService.isFollowingUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
    );
    if (!mounted) return;
    setState(() {
      _isFollowing = isFollowingUser;
    });
  }

  _setupFollowers() async {
    int userFollowersCount = await DatabaseService.numFollowers(widget.userId!);
    if (!mounted) return;
    setState(() {
      _followersCount = userFollowersCount;
    });
  }

  _setupFollowing() async {
    int userFollowingCount = await DatabaseService.numFollowing(widget.userId!);
    if (!mounted) return;
    setState(() {
      _followingCount = userFollowingCount;
    });
  }

  _setupPosts() async {
    List<Post> posts = await DatabaseService.getUserPosts(widget.userId!);
    if (!mounted) return;
    setState(() {
      _posts = posts;
    });
  }

  _setupProfileUser() async {
    UserModelClass profileUser = await DatabaseService.getUserWithId(widget.userId!);
    if (!mounted) return;
    setState(() => _profileUser = profileUser);
    if (profileUser.id ==
        Provider.of<UserData>(context, listen: false).currentUserId) {
      AuthService.updateTokenWithUser(profileUser);
      Provider.of<UserData>(context, listen: false).currentUser = profileUser;
    }
  }

  _setupUserStories() async {
    List<Story>? userStories = await StoriesService.getStoriesByUserId(widget.userId!, true);
    if (!mounted) return;

    if (userStories != null) {
      setState(() {
        _userStories = userStories;
      });
    }
  }

  _followOrUnfollow() {
    if (_isFollowing) {
      _unfollowUser();
    } else {
      _followUser();
    }
  }

  _unfollowUser() {
    DatabaseService.unfollowUser(
        currentUserId: widget.currentUserId, userId: widget.userId);
    setState(() {
      _isFollowing = false;
      _followersCount--;
    });
  }

  void _followUser() {
    DatabaseService.followUser(
      currentUserId: widget.currentUserId,
      userId: widget.userId,
      receiverToken: _profileUser!.token!,
    );
    if (!mounted) return;
    setState(() {
      _isFollowing = true;
      _followersCount++;
    });
  }

  Widget _displayButton(UserModelClass user) {
    return user.id == widget.currentUserId
        ? Container(
            width: double.infinity,
            child: FlatButton(
                onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProfileScreen(
                            user: user,
                            updateUser: (UserModelClass updateUser) {
                              UserModelClass updatedUser = UserModelClass(
                                id: updateUser.id,
                                name: updateUser.name,
                                email: user.email,
                                profileImageUrl: updateUser.profileImageUrl,
                                bio: updateUser.bio,
                                isVerified: updateUser.isVerified,
                                role: updateUser.role,
                                website: updateUser.website,
                                token: '',
                                isBanned: false,
                              );

                              setState(() {
                                Provider.of<UserData>(context, listen: false)
                                    .currentUser = updatedUser;
                                _profileUser = updatedUser;
                              });
                              AuthService.updateTokenWithUser(updatedUser);
                              widget.onProfileEdited!();
                            }),
                      ),
                    ),
                color: Colors.green,
                textColor: Colors.white,
                child: Text(
                  'Edit Profile',
                  style: kFontSize18TextStyle,
                ),
            ),
          )
        : Row(
            children: <Widget>[
              Expanded(
                child: FlatButton(
                  onPressed: _followOrUnfollow,
                  color: _isFollowing ? Colors.grey[200] : Colors.blue,
                  textColor: _isFollowing ? Colors.black : Colors.white,
                  child: Text(
                    _isFollowing ? 'Unfollow' : 'Follow',
                    style: kFontSize18TextStyle,
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                child: FlatButton(
                  onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ChatScreen(
                                receiverUser: _profileUser!,
                              ),),),
                  color: Colors.blue,
                  textColor: Colors.white,
                  child: Text(
                    'Message',
                    style: kFontSize18TextStyle,
                  ),
                ),
              ),
            ],
          );
  }

  Column _buildProfileInfo(UserModelClass user) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0),
          child: Row(
            children: <Widget>[
              // CircleAvatar(
              //   radius: 40.0,
              //   backgroundColor: Colors.grey,
              //   backgroundImage: user.profileImageUrl.isEmpty
              //       ? AssetImage(placeHolderImageRef)
              //       : CachedNetworkImageProvider(user.profileImageUrl),
              // ),
              Container(
                width: 110,
                height: 110,
                child: _userStories == null
                    ? BlankStoryCircle(
                        user: user,
                        goToCameraScreen: widget.goToCameraScreen,
                        size: 90,
                        showUserName: false,
                      )
                    : StoryCircle(
                        userStories: _userStories!,
                        user: _profileUser!,
                        currentUserId: widget.currentUserId!,
                        showUserName: false,
                        size: 90,
                      ),
              ),
              Expanded(
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Column(
                          children: <Widget>[
                            Text(
                              NumberFormat.compact().format(_posts.length),
                              style: kFontSize18FontWeight600TextStyle,
                            ),
                            Text(
                              'posts',
                              style: kHintColorStyle(context),
                            )
                          ],
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FollowersScreen(
                                currenUserId: widget.currentUserId!,
                                user: user,
                                followersCount: _followersCount,
                                followingCount: _followingCount,
                                selectedTab: 0,
                                updateFollowersCount: (count) {
                                  setState(() => _followersCount = count);
                                },
                                updateFollowingCount: (count) {
                                  setState(() => _followingCount = count);
                                },
                              ),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                NumberFormat.compact().format(_followersCount),
                                style: kFontSize18FontWeight600TextStyle,
                              ),
                              Text(
                                'followers',
                                style: kHintColorStyle(context),
                              )
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => FollowersScreen(
                                currenUserId: widget.currentUserId!,
                                user: user,
                                followersCount: _followersCount,
                                followingCount: _followingCount,
                                selectedTab: 1,
                                updateFollowersCount: (count) {
                                  setState(() => _followersCount = count);
                                },
                                updateFollowingCount: (count) {
                                  setState(() => _followingCount = count);
                                },
                              ),
                            ),
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                NumberFormat.compact().format(_followingCount),
                                style: kFontSize18FontWeight600TextStyle,
                              ),
                              Text(
                                'following',
                                style: kHintColorStyle(context),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                user.name!,
                style: kFontSize18FontWeight600TextStyle.copyWith(
                    fontWeight: FontWeight.bold,
                ),
              ),
              if (user.website != '') SizedBox(height: 5.0),
              if (user.website != '')
                GestureDetector(
                  onTap: () => _goToUrl(user.website!),
                  child: Container(
                    height: 18,
                    width: double.infinity,
                    child: Text(
                      user.website!
                          .replaceAll('https://', '')
                          .replaceAll('http://', '')
                          .replaceAll('www.', ''),
                      style: kBlueColorTextStyle,
                    ),
                  ),
                ),
              SizedBox(height: 5.0),
              Container(
                child: Text(
                  user.bio!,
                  style: TextStyle(fontSize: 15.0),
                ),
              ),
              SizedBox(height: 5.0),
              _displayButton(user),
              Divider(
                color: Theme.of(context).dividerColor,
                height: 1,
              ),
            ],
          ),
        )
      ],
    );
  }

  void _goToUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: true,
        forceWebView: true,
        enableJavaScript: true,
      );
    } else {
      ShowErrorDialog.showAlertDialog(
          errorMessage: 'Could not launch $url', context: context);
    }
  }

  Row _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        IconButton(
          icon: Icon(Icons.grid_on),
          iconSize: 30.0,
          color: _displayPosts == 0
              ? Theme.of(context).accentColor
              : Theme.of(context).hintColor,
          onPressed: () => setState(() {
            _displayPosts = 0;
          }),
        ),
        IconButton(
          icon: Icon(Icons.list),
          iconSize: 30.0,
          color: _displayPosts == 1
              ? Theme.of(context).accentColor
              : Theme.of(context).hintColor,
          onPressed: () => setState(() {
            _displayPosts = 1;
          }),
        )
      ],
    );
  }

  GridTile _buildTilePost(Post post) {
    return GridTile(
        child: GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute<bool>(
          builder: (BuildContext context) {
            return Center(
              child: Scaffold(
                  appBar: AppBar(
                    title: Text(
                      'Photo',
                    ),
                  ),
                  body: ListView(
                    children: <Widget>[
                      Container(
                        child: PostView(
                          postStatus: PostStatus.feedPost,
                          currentUserId: widget.currentUserId,
                          post: post,
                          author: _profileUser,
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

  Widget _buildDisplayPosts() {
    if (_displayPosts == 0) {
      // Grid
      List<GridTile> tiles = [];
      _posts.forEach((post) => tiles.add(_buildTilePost(post)));
      return GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        mainAxisSpacing: 2.0,
        crossAxisSpacing: 2.0,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: tiles,
      );
    } else {
      // Column
      List<PostView> postViews = [];
      _posts.forEach((post) {
        postViews.add(PostView(
          postStatus: PostStatus.feedPost,
          currentUserId: widget.currentUserId,
          post: post,
          author: _profileUser,
        ));
      });
      return Column(
        children: postViews,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,//todo: Theme.of(context).appBarTheme.color,
        // automaticallyImplyLeading: widget.userId == widget.currentUserId ? false : true,
        automaticallyImplyLeading: widget.isCameFromBottomNavigation ? false : true,
        title: _profileUser != null
            ? Container(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      child: Text(
                        _profileUser!.name!,
                        overflow: TextOverflow.clip,
                      ),
                    ),
                    UserBadges(user: _profileUser, size: 20),
                  ],
                ),
              )
            : SizedBox.shrink(),
      ),
      endDrawer: _profileUser != null && widget.userId == widget.currentUserId ? ProfileScreenDrawer(
              user: _profileUser!,
            ) : null,
      body: FutureBuilder(
        future: usersRef.doc(widget.userId).get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          UserModelClass user = UserModelClass.fromDoc(snapshot.data);
          return ListView(
            physics: AlwaysScrollableScrollPhysics(),
            children: <Widget>[
              _buildProfileInfo(user),
              _buildToggleButtons(),
              Divider(color: Theme.of(context).dividerColor),
              _buildDisplayPosts(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
        onPressed: () {
          //todo: call CameraScreen() function : _backToHomeScreenFromCameraScreen
          Navigator.push(context, MaterialPageRoute(builder: (context) => CameraScreen(_cameras!, null, _cameraConsumer)));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
