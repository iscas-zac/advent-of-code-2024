typealias Board[T] = @utils.Board[T]

fn part1(input: String) -> Int {
  let board: Board[Char] = input.split("\r\n").map(fn { s => s.to_array() }).collect()
  let freqs = board.each(Set::of([]), fn { ch, acc => acc..add(ch) })
  freqs.remove('.')
  freqs.to_array().map(fn { ch => {
    let group = board.eachi([], fn { this, acc, (i, j) => if this == ch { acc..push((i, j)) } else { acc }})
    let verts = Set::of([])
    for tup1 in group {
      for tup2 in group {
        if tup1 == tup2 { continue }
        let (a0, a1) = tup1
        let (b0, b1) = tup2
        let far_a = (a0 * 2 - b0, a1 * 2 - b1)
        if not(board.out_of_bound(far_a)) { verts.add(far_a) }
        let far_b = (b0 * 2 - a0, b1 * 2 - a1)
        if not(board.out_of_bound(far_b)) { verts.add(far_b) }
      }
    }
    verts
  }}).fold(init=Set::of([]), fn { s1, s2 => s1.union(s2) })
  .size()
}

test "day8_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day8.test")
  assert_eq!(part1(input), 14)
}

test "day8_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day8.input")
  inspect!(part1(input), content="336")
}

fn part2(input: String) -> Int {
  let board: Board[Char] = input.split("\r\n").map(fn { s => s.to_array() }).collect()
  let freqs = board.each(Set::of([]), fn { ch, acc => acc..add(ch) })
  freqs.remove('.')
  freqs.to_array().map(fn { ch => {
    let group = board.eachi([], fn { this, acc, (i, j) => if this == ch { acc..push((i, j)) } else { acc }})
    let verts = Set::of([])
    for tup1 in group {
      for tup2 in group {
        if tup1 == tup2 { continue }
        let (a0, a1) = tup1
        let (b0, b1) = tup2
        let step = (b0 - a0, b1 - a1)
        let gcd = loop step.0.abs(), step.1.abs() {
          0, a => break a
          b, 0 => break b
          a, b => if (a < b) { continue a, b - a } else { continue b, a - b }
        }
        let min_step = (step.0 / gcd, step.1 / gcd)
        let mut begin = tup1
        if min_step == (0, 0) { println("step 0, 0"); panic(); }
        while (not(board.out_of_bound(begin))) {
          verts.add(begin)
          begin = Board::add(begin, min_step)
        }
        begin = tup1
        let rev_step = (-min_step.0, -min_step.1)
        while (not(board.out_of_bound(begin))) {
          verts.add(begin)
          begin = Board::add(begin, rev_step)
        }
      }
    }
    verts
  }}).fold(init=Set::of([]), fn { s1, s2 => s1.union(s2) })
  .size()
}

test "day8_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day8.test")
  assert_eq!(part2(input), 34)
}

test "day8_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day8.input")
  inspect!(part2(input), content="1131")
}
