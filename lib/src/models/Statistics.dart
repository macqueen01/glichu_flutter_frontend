class Statistics {
  int likes;
  int remixes;
  int recorded;

  int getLikes() {
    return this.likes;
  }

  int getRemixes() {
    return this.remixes;
  }

  int getRecorded() {
    return this.recorded;
  }

  Statistics(
      {required this.likes, required this.remixes, required this.recorded});
}
