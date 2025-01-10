pub fn zip(this: Array[Int], other: Array[Int]) -> Array[(Int, Int)] {
  if (this.length() != other.length()) { panic() }
  loop this[:], other[:], [] {
    [], _, acc => break acc
    _, [], acc => break acc
    [hd1, .. as tl1], [hd2, .. as tl2], acc => continue tl1, tl2, [..acc, (hd1, hd2)]
  }
}

test "zip one" {
  inspect!(zip([1, 2, 3], [2, 4, 5]), content="[(1, 2), (2, 4), (3, 5)]")
}