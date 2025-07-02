class LeaderboardUser {
  final int rank;
  final String name;
  final String flag;
  final int hp;
  final int change;
  final bool highlight;

  LeaderboardUser({
    required this.rank,
    required this.name,
    required this.flag,
    required this.hp,
    required this.change,
    this.highlight = false,
  });
}