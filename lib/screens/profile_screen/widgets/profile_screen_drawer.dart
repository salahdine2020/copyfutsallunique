import 'package:flutter/material.dart';
import 'package:futsal_unique/models/models.dart';
import 'package:futsal_unique/models/user_data.dart';
import 'package:futsal_unique/screens/profile_screen/nested_screens/deleted_posts_screen.dart';
import 'package:futsal_unique/screens/screens.dart';
import 'package:futsal_unique/screens/settings_screen/settings_screen.dart';
import 'package:futsal_unique/utilities/constants.dart';
import 'package:futsal_unique/utilities/themes.dart';
import 'package:futsal_unique/common_widgets/user_badges.dart';
import 'package:ionicons/ionicons.dart';
import 'package:provider/provider.dart';

class ProfileScreenDrawer extends StatelessWidget {
  final UserModelClass user;
  ProfileScreenDrawer({required this.user});

  _buildDrawerOption(Widget icon, String title, Function? onTap) {
    return ListTile(
      leading: icon,
      title: Text(
        title,
        style: TextStyle(
          fontSize: 20.0,
        ),
      ),
      onTap: () => onTap,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: 250,
        child: Drawer(
          child: Column(
            children: <Widget>[
              Container(
                height: 56,
                child: ListTile(
                    title: Row(
                  children: [
                    Text(user.name!, style: kFontSize18TextStyle),
                    UserBadges(user: user, size: 20),
                  ],
                ),
                ),
              ),
              Divider(height: 3),
              _buildDrawerOption(
                Icon(Icons.history),
                'Archive',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeletedPostsScreen(
                        currentUserId: Provider.of<UserData>(context, listen: false).currentUserId,
                        postStatus: PostStatus.archivedPost,
                    ),
                  ),
                ),
              ),
              _buildDrawerOption(
                Icon(Ionicons.trash_outline),
                'Deleted Posts',
                () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => DeletedPostsScreen(
                      currentUserId: Provider.of<UserData>(context, listen: false).currentUserId,
                      postStatus: PostStatus.deletedPost,
                    ),
                  ),
                ),
              ),
              _buildDrawerOption(Icon(Icons.history_toggle_off), 'Your Activity', null),
              if (user.role == 'admin')
                _buildDrawerOption(
                    Icon(Ionicons.key_outline), 'Admins Section', null),
              _buildDrawerOption(
                  Icon(Ionicons.bookmark_outline), 'Saved', null),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: _buildDrawerOption(
                    Icon(Ionicons.settings_outline),
                    'Settings',
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SettingsScreen(),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
