import 'package:camera/camera.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:futsal_unique/screens/accueil/accuiel.dart';
import 'package:futsal_unique/screens/activity_screen/activity_screen.dart';
import 'package:futsal_unique/screens/boutique/list_collections.dart';
import 'package:futsal_unique/screens/camera_screen/camera_screen.dart';
import 'package:futsal_unique/screens/direct_messages/direct_messages_screen.dart';
///import 'package:futsal_unique/screens/profile_screen/profile_screen.dart';
import 'package:futsal_unique/screens/search_screen/search_screen.dart';
import 'package:futsal_unique/utilities/show_error_dialog.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';
import 'package:futsal_unique/models/models.dart';
import 'package:futsal_unique/screens/screens.dart';
import 'package:futsal_unique/services/services.dart';
import 'package:futsal_unique/utilities/constants.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;
  final int initialPage;
  final List<CameraDescription> cameras;
  HomeScreen({required this.currentUserId, this.initialPage = 1, required this.cameras});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance; //todo: FirebaseMessaging();
  int _currentTab = 0;
  int _currentPage = 0;
  int _lastTab = 0;
  PageController? _pageController;
  UserModelClass? _currentUser;
  List<CameraDescription>? _cameras;
  CameraConsumer _cameraConsumer = CameraConsumer.post;
  List<Widget>? _pages;

  @override
  void initState() {
    super.initState();
    _getCurrentUser();
    _getCameras();
    _initPageView();
    //todo: _listenToNotifications();
    AuthService.updateToken();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
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

  void _initPageView() async {
    _pageController = PageController(initialPage: widget.initialPage);
    setState(() => _currentPage = widget.initialPage);
  }

  // void _listenToNotifications() {
  //   _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
  //     print('On message: $message');
  //   }, onResume: (Map<String, dynamic> message) {
  //     print('On resume: $message');
  //   }, onLaunch: (Map<String, dynamic> message) {
  //     print('On launch: $message');
  //   });
  //
  //   _firebaseMessaging.requestNotificationPermissions(
  //     const IosNotificationSettings(
  //       sound: true,
  //       badge: true,
  //       alert: true,
  //     ),
  //   );
  //   _firebaseMessaging.onIosSettingsRegistered.listen((settings) {
  //     print('settings registered:  $settings');
  //   });
  // }

  void _selectTab(int index) {
    if (index == 2) {
      // go to CameraScreen
      _pageController!.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
      _selectPage(2);
    }
    setState(() {
      _lastTab = _currentTab;
      _currentTab = index;
    });
  }

  void _selectPage(int index) {
    print("index when swip Page is : $index");
    if (index == 1 && _currentTab == 2) {
      // Come back from CameraScreen to FeedScreen
      _selectTab(_lastTab);
      if (_cameraConsumer != CameraConsumer.post) {
        setState(() => _cameraConsumer = CameraConsumer.post);
      }
    }

    setState(() {
      _currentPage = index;
    });
  }

  void _goToDirect() {
    _selectPage(2);
    _pageController!.animateToPage(2, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  void _backToHomeScreenFromDirect() {
    _selectPage(1);
    _pageController!.animateToPage(1,
        duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  void _goToCameraScreen() {
    setState(() => _cameraConsumer = CameraConsumer.story);
    _selectPage(0);
    _pageController!.animateToPage(0, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  void _backToHomeScreenFromCameraScreen() {
    _selectPage(1);
    _pageController!.animateToPage(1, duration: Duration(milliseconds: 200), curve: Curves.easeIn);
  }

  void _getCurrentUser() async {
    UserModelClass currentUser = await DatabaseService.getUserWithId(widget.currentUserId);

    Provider.of<UserData>(context, listen: false).currentUser = currentUser;

    print('i have the current user now');
    setState(() => _currentUser = currentUser);
    AuthService.updateTokenWithUser(currentUser);
  }

  // _passPages(){
  //   _pages = [
  //     AccuileApp(),
  //     FeedScreen( //0
  //       currentUserId: widget.currentUserId,
  //       goToDirectMessages: _goToDirect,
  //       goToCameraScreen: _goToCameraScreen,
  //     ),
  //     ListCollection(),
  //     //todo: SearchScreen(earchFrom: SearchFrom.homeScreen),
  //     //todo: SizedBox.shrink(), //2
  //     //todo: CameraScreen(_cameras!, _backToHomeScreenFromCameraScreen, _cameraConsumer),
  //     ActivityScreen( //3
  //       currentUser: _currentUser!,
  //     ),
  //     ProfileScreen( //4
  //       goToCameraScreen: _goToCameraScreen,
  //       isCameFromBottomNavigation: true,
  //       onProfileEdited: _getCurrentUser,
  //       userId: widget.currentUserId,
  //       currentUserId: widget.currentUserId,
  //     ),
  //   ];
  // }

  @override
  Widget build(BuildContext context) {

    List<Widget> _pages = [
      AccuileApp(),
      FeedScreen( //0
        currentUserId: widget.currentUserId,
        goToDirectMessages: _goToDirect,
        goToCameraScreen: _goToCameraScreen,
      ),
      ListCollection(),
      ActivityScreen( //3
        currentUser: _currentUser!,
      ),
      ProfileScreen( //4
        goToCameraScreen: _goToCameraScreen,
        isCameFromBottomNavigation: true,
        onProfileEdited: _getCurrentUser,
        userId: widget.currentUserId,
        currentUserId: widget.currentUserId,
        cameras: _cameras,
      ),
    ];

    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: <Widget>[
          ///CameraScreen(_cameras!, _backToHomeScreenFromCameraScreen, _cameraConsumer),
          _pages[_currentTab],
          //todo: DirectMessagesScreen(_backToHomeScreenFromDirect),
        ],
        onPageChanged: (int index) => _selectPage(index),
      ),
      bottomNavigationBar: CupertinoTabBar(
        currentIndex: _currentTab,
        backgroundColor:
        Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        activeColor: Theme.of(context)
            .bottomNavigationBarTheme
            .selectedIconTheme!
            .color!,
        //todo: inactiveColor: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme.color,
        onTap: _selectTab,
        items: [
          /// salle
          BottomNavigationBarItem(
            icon: Icon(
              Ionicons.football_outline,
              size: 32.0,
            ),
          ),
          /// feeds
          BottomNavigationBarItem(
            icon: Icon(
              Ionicons.home_outline,
              size: 32.0,
            ),
          ),
          /// shoping
          BottomNavigationBarItem(
            icon: Icon(
              Ionicons.bag_add_outline,
              size: 32.0,
            ),
          ),
          /// activity
          BottomNavigationBarItem(
            icon: Icon(
              Ionicons.notifications_outline,
              size: 32.0,
            ),
          ),
          /// profile
          if (_currentUser == null)
            BottomNavigationBarItem(
              icon: SizedBox.shrink(),
            ),
          if (_currentUser != null)
            BottomNavigationBarItem(
              activeIcon: Container(
                padding: const EdgeInsets.all(1.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 2.0,
                    color: Theme.of(context)!
                        .bottomNavigationBarTheme!
                        .selectedIconTheme!
                        .color!,
                  ),
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.grey,
                  radius: 15.0,
                  backgroundImage: CachedNetworkImageProvider(_currentUser!.profileImageUrl!),
                  // _currentUser.profileImageUrl.isEmpty
                  //     ? AssetImage(placeHolderImageRef)
                  //     : CachedNetworkImageProvider(_currentUser.profileImageUrl),
                ),
              ),
              icon: CircleAvatar(
                backgroundColor: Colors.grey,
                radius: 15.0,
                backgroundImage: CachedNetworkImageProvider(_currentUser!.profileImageUrl!),
                // _currentUser.profileImageUrl.isEmpty
                //     ? AssetImage(placeHolderImageRef)
                //     : CachedNetworkImageProvider(
                //         _currentUser.profileImageUrl),
              ),
            ),
        ],
      ),
      /*
      _currentPage == 1 ? CupertinoTabBar(
              currentIndex: _currentTab,
              backgroundColor:
                  Theme.of(context).bottomNavigationBarTheme.backgroundColor,
              activeColor: Theme.of(context)
                  .bottomNavigationBarTheme
                  .selectedIconTheme!
                  .color!,
              //todo: inactiveColor: Theme.of(context).bottomNavigationBarTheme.unselectedIconTheme.color,
              onTap: _selectTab,
              items: [
                /// salle
                BottomNavigationBarItem(
                  icon: Icon(
                    Ionicons.football_outline,
                    size: 32.0,
                  ),
                ),
                /// feeds
                BottomNavigationBarItem(
                  icon: Icon(
                    Ionicons.home_outline,
                    size: 32.0,
                  ),
                ),
                /// shoping
                BottomNavigationBarItem(
                  icon: Icon(
                    Ionicons.bag_add_outline,
                    size: 32.0,
                  ),
                ),
                /// activity
                BottomNavigationBarItem(
                  icon: Icon(
                    Ionicons.notifications_outline,
                    size: 32.0,
                  ),
                ),
                /// profile
                if (_currentUser == null)
                  BottomNavigationBarItem(
                    icon: SizedBox.shrink(),
                  ),
                if (_currentUser != null)
                  BottomNavigationBarItem(
                    activeIcon: Container(
                      padding: const EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          width: 2.0,
                          color: Theme.of(context)!
                              .bottomNavigationBarTheme!
                              .selectedIconTheme!
                              .color!,
                        ),
                      ),
                      child: CircleAvatar(
                        backgroundColor: Colors.grey,
                        radius: 15.0,
                        backgroundImage: CachedNetworkImageProvider(_currentUser!.profileImageUrl!),
                        // _currentUser.profileImageUrl.isEmpty
                        //     ? AssetImage(placeHolderImageRef)
                        //     : CachedNetworkImageProvider(_currentUser.profileImageUrl),
                      ),
                    ),
                    icon: CircleAvatar(
                      backgroundColor: Colors.grey,
                      radius: 15.0,
                      backgroundImage: CachedNetworkImageProvider(_currentUser!.profileImageUrl!),
                      // _currentUser.profileImageUrl.isEmpty
                      //     ? AssetImage(placeHolderImageRef)
                      //     : CachedNetworkImageProvider(
                      //         _currentUser.profileImageUrl),
                    ),
                  ),
              ],
            ) : SizedBox.shrink(),

       */
    );
  }
}
