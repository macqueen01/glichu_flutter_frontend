class User {
  String userName;
  String userId;
  int followers;
  int followed;
  int scrolled;
  int likes;
  int remixed;
  bool followedByUser;

  User(
      {required this.userName,
      required this.userId,
      required this.followers,
      required this.followed,
      required this.scrolled,
      required this.likes,
      required this.remixed,
      this.followedByUser = false});

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
