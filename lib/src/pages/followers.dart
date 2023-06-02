import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mockingjae2_mobile/src/StateMixins/frameworks.dart';
import 'package:mockingjae2_mobile/src/api/profile.dart';
import 'package:mockingjae2_mobile/src/bodyWidget/ScrollsWidget/ScrollsHeader.dart';
import 'package:mockingjae2_mobile/src/components/navbars/topBars.dart';
import 'package:mockingjae2_mobile/src/models/User.dart';
import 'package:mockingjae2_mobile/utils/colors.dart';
import 'package:mockingjae2_mobile/utils/ui.dart';
import 'package:provider/provider.dart';

import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';

class RelationsPageArguments {
  late final UserMin user;

  RelationsPageArguments({required this.user});
}

class RelationsListManager extends ChangeNotifier {
  RelationsListManager({required this.user});

  RelationsFetcher _relationsFetcher = RelationsFetcher();

  List<UserMin> followers = [];
  List<UserMin> followings = [];

  UserMin user;

  int currentFollowersPage = 1;
  int currentFollowingsPage = 1;

  // 0: followers, 1: followings
  int tab = 0;

  bool _isFollowersLoading = false;
  bool _isFollowingsLoading = false;

  Future<void> fetchNextPage() async {
    if (tab == 0) {
      return await fetchNextFollowersPage();
    } else {
      return await fetchNextFollowingsPage();
    }
  }

  Future<void> fetchInitialPage() async {
    if (currentFollowersPage >= 2) {
      return;
    }
    print(getCurrentPage());
    fetchNextPage();
  }

  int getCurrentPage() {
    if (tab == 0) {
      return currentFollowersPage;
    } else {
      return currentFollowingsPage;
    }
  }

  Future<void> fetchNextFollowersPage() async {
    if (_isFollowersLoading) {
      return;
    }

    _isFollowersLoading = true;

    List<UserMin> loadedUsers = await _relationsFetcher
        .fetchFollowersOfUser(user.userId, currentFollowersPage, () {
      currentFollowersPage++;
    });

    followers.addAll(loadedUsers);

    _isFollowersLoading = false;

    notifyListeners();
  }

  Future<void> fetchNextFollowingsPage() async {
    if (_isFollowingsLoading) {
      return;
    }

    _isFollowingsLoading = true;

    List<UserMin> loadedUsers = await _relationsFetcher
        .fetchFollowingsOfUser(user.userId, currentFollowingsPage, () {
      currentFollowingsPage++;
    });

    followings.addAll(loadedUsers);

    _isFollowingsLoading = false;

    notifyListeners();
  }

  void changeTab() {
    if (tab == 0) {
      tab = 1;
    } else {
      tab = 0;
    }
    refresh();
    notifyListeners();
  }

  Future<void> refresh() async {
    followers = [];
    followings = [];
    currentFollowersPage = 1;
    currentFollowingsPage = 1;
    return await fetchInitialPage();
  }
}

class RelationsPage extends StatelessWidget {
  const RelationsPage({super.key});

  static const routeName = '/relations';

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as RelationsPageArguments;

    return Scaffold(
        backgroundColor: scrollsBackgroundColor,
        appBar: centeredTitleAppBar(
          // title should be a text base aligned richtext of user name and 's likes
          title: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                text: "${args.user.userName}'s relations",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w400,
                    color: mainBackgroundColor,
                    textBaseline: TextBaseline.ideographic),
              )),
        ),
        body: MultiProvider(providers: [
          ChangeNotifierProvider(
              create: (_) => RelationsListManager(user: args.user))
        ], child: RelationsTabView()));
  }
}

class RelationsTabView extends StatelessWidget {
  const RelationsTabView({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<RelationsListManager>(builder: (context, provider, _) {
      return GlichuTabBarView(
        tabBarProperties: TabBarProperties(
            labelColor: mainBackgroundColor,
            unselectedLabelColor: mainBackgroundColor,
            indicator: ContainerTabIndicator(
              radius: BorderRadius.circular(16.0),
              color: scrollsBackgroundColor,
              borderWidth: 0,
              borderColor: Colors.black,
            ),
            labelStyle: GoogleFonts.quicksand(
                fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white),
            unselectedLabelStyle: GoogleFonts.quicksand(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white)),
        tabs: [Text('Follower'), Text('Following')],
        views: [
          UserListBody(listBuilder: followersListView),
          UserListBody(listBuilder: followingsListView),
        ],
        onChange: (index) {
          provider.changeTab();
        },
      );
    });
  }
}

// custom list tile with profile image and name

class FollowerTile extends StatefulWidget {
  final UserMin user;

  FollowerTile({super.key, required this.user});

  @override
  State<FollowerTile> createState() => _FollowerTileState();
}

class _FollowerTileState extends State<FollowerTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Profile(
          user: widget.user,
        ),
        title: Text(
          widget.user.userName,
          style: TextStyle(color: mainBackgroundColor),
        ),
        subtitle: Text(
          widget.user.tagger!,
          style: TextStyle(color: Colors.white60),
        ),
        trailing: (widget.user.isFollowedByUser == null ||
                !widget.user.isFollowedByUser!)
            ? CupertinoButton(
                onPressed: () {
                  // follow
                  setState(() {
                    widget.user.isFollowedByUser = true;
                  });
                },
                padding: EdgeInsets.zero,
                child: BoxContainer(
                    context: context,
                    width: 65,
                    height: 30,
                    backgroundColor: Colors.white30,
                    radius: 8,
                    child: Text(
                      "Follow",
                      style: TextStyle(
                          fontSize: 13,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70),
                      textAlign: TextAlign.center,
                    )),
              )
            : CupertinoButton(
                onPressed: () {
                  // unfollow
                  setState(() {
                    widget.user.isFollowedByUser = false;
                  });
                },
                padding: EdgeInsets.zero,
                child: BoxContainer(
                    context: context,
                    width: 80,
                    height: 30,
                    backgroundColor: Colors.white30,
                    radius: 8,
                    child: Text(
                      "Unfollow",
                      style: TextStyle(
                          fontSize: 13,
                          letterSpacing: 0.4,
                          fontWeight: FontWeight.w600,
                          color: Colors.white70),
                      textAlign: TextAlign.center,
                    )),
              ));
  }
}

class UserListBody extends StatefulWidget {
  final ListView Function(RelationsListManager provider, Widget animationLoader)
      listBuilder;

  UserListBody({super.key, required this.listBuilder});

  @override
  State<UserListBody> createState() => _UserListBodyState();
}

class _UserListBodyState extends State<UserListBody>
    with DragUpdatable<UserListBody> {
  @override
  bool _load = false;

  @override
  int _duration = 2;

  @override
  void reload() {
    // this should recieve all data from the server,
    // then refreshed all contents of the page
    if (_load) {
      return;
    }
    setState(() {
      setLoadingTrue();
      context.read<RelationsListManager>().refresh().then((value) {
        updateCallback();
      });
    });
  }

  @override
  void initState() {
    context.read<RelationsListManager>().fetchInitialPage();
    super.initState();
    //_reload();
  }

  @override
  Widget child(BuildContext context) {
    return widget.listBuilder(
        context.read<RelationsListManager>(), AnimatedLoader(context));
  }
}

ListView followersListView(
    RelationsListManager provider, Widget animationLoader) {
  return ListView.separated(
    itemCount: provider.followers.length,
    itemBuilder: (context, index) {
      if (index == 0) {
        return Column(
          children: [
            animationLoader,
            FollowerTile(user: provider.followers[index]),
          ],
        );
      } else {
        return FollowerTile(user: provider.followers[index]);
      }
    },
    separatorBuilder: (BuildContext context, int index) {
      return const Divider(
        color: Colors.white10,
        thickness: 1.4,
        indent: 38,
        endIndent: 38,
        height: 18,
      );
    },
  );
}

ListView followingsListView(
  RelationsListManager provider,
  Widget animationLoader,
) {
  return ListView.separated(
    itemCount: provider.followings.length,
    itemBuilder: (context, index) {
      if (index == 0) {
        return Column(
          children: [
            animationLoader,
            FollowerTile(user: provider.followings[index]),
          ],
        );
      } else {
        return FollowerTile(user: provider.followings[index]);
      }
    },
    separatorBuilder: (BuildContext context, int index) {
      return const Divider(
        color: Colors.white10,
        thickness: 1.4,
        indent: 38,
        endIndent: 38,
        height: 18,
      );
    },
  );
}
