class Score {
  const Score(this.pct, this.n);
  final int? pct;
  final int n;
  static const empty = Score(null, 0);
}
