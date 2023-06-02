import 'package:flutter_launcher_icons/constants.dart';

class User {
  String userName;
  String userId;
  int followers;
  int followed;
  int scrolled;
  int likes;
  int remixed;
  bool followedByUser;
  String? profileImagePath;

  User(
      {required this.userName,
      required this.userId,
      required this.followers,
      required this.followed,
      required this.scrolled,
      required this.likes,
      required this.remixed,
      this.followedByUser = false,
      this.profileImagePath});

  void updateFollowedByUser(bool followedByUser) {
    this.followedByUser = followedByUser;
  }

  void updateFollowers(int followers) {
    this.followers = followers;
  }

  void updateFollowed(int followed) {
    this.followed = followed;
  }

  static fromJson(json) {
    return User(
        userName: json['userName'],
        userId: json['userId'],
        followers: json['followers'],
        followed: json['followed'],
        scrolled: json['scrolled'],
        likes: json['liked'],
        remixed: json['remixed'],
        followedByUser: json['followedByUser']);
  }
}

class UserMin {
  String userName;
  String userId;
  String? profileImagePath;
  bool? isFollowedByUser;
  bool? isFollowingUser;
  String? tagger;

  UserMin(
      {required this.userName,
      required this.userId,
      this.tagger,
      this.profileImagePath,
      this.isFollowedByUser,
      this.isFollowingUser});

  static fromJson(json) {
    print(json);
    return UserMin(
      userName: json['username'],
      userId: '${json['id']}',
      profileImagePath: json['profile_image'] != null
          ? json['profile_image'].split('?')[0]
          : 'https://mockingjae-test-bucket.s3.amazonaws.com/profile_image/default.png',
      isFollowedByUser: json['is_followed_by_user'] == null
          ? null
          : json['is_followed_by_user'],
      isFollowingUser:
          json['is_following_user'] == null ? null : json['is_following_user'],
      tagger: json['tagged_by'],
    );
  }
}

class UserSelfMin extends UserMin {
  // static final UserSelfMin instance = UserSelfMin(userName: userName, userId: userId)

  UserSelfMin({required super.userName, required super.userId});
}
