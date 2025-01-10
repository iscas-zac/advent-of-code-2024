typealias Board[T] = @utils.Board[T]

fn part1(input: String) -> Int {
  let board: Board[Int] = input.split("\r\n")
    .map(fn { s => s.to_array().map(fn { ch => @strconv.parse_int?(ch.to_string()).unwrap() })})
    .to_array()
  let starts = board.eachi([], fn { height, acc, (x, y) => if (height == 0) { acc..push([(x, y)]) } else { acc } })
  let starts = starts.map(fn { arr => Set::from_array(arr) })
  loop starts, 0 {
    reachable, 9 => break reachable.fold(init=0, fn { a, b => a + b.size() })
    paths, num => {
      continue paths.map(fn { reached =>
        Set::from_iter(reached.iter().flat_map(fn { (x, y) =>
          [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)].filter(fn { coord => board.get2(coord) == Some(num + 1) }).iter()
        }))
      }), num + 1
    }
  }
}

test "day10_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day10.test")
  assert_eq!(part1(input), 36)
}

test "day10_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day10.input")
  inspect!(part1(input), content="501")
}

fn part2(input: String) -> Int {
  let board: Board[Int] = input.split("\r\n")
    .map(fn { s => s.to_array().map(fn { ch => @strconv.parse_int?(ch.to_string()).unwrap() })})
    .to_array()
  let starts = board.eachi([], fn { height, acc, (x, y) => if (height == 0) { acc..push([(x, y)]) } else { acc } })
  loop starts, 0 {
    reachable, 9 => break reachable.length()
    paths, num => {
      continue paths.iter().flat_map(fn { path => {
        guard let Some((x, y)) = path.last() else { _ => [[]].iter() }
        [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)].filter(fn { coord => board.get2(coord) == Some(num + 1) })
          .map(fn { item => path.copy()..push(item) }).iter()
      }}).to_array(), num + 1
    }
  }
}

test "day10_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day10.test")
  assert_eq!(part2(input), 81)
}

test "day10_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day10.input")
  inspect!(part2(input), content="1017")
}
