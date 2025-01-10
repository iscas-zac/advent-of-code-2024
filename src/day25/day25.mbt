fn parse(s: String) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
fn parsec(s: Char) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
fn part1(input: String) -> Int64 {
  enum Pattern { Key(Array[Int]); Lock(Array[Int]) } derive (Show)
  let patterns = input.split("\r\n\r\n")
  .map(fn(x) {
    let [row0, .. as mid, rowlast] = x.split("\r\n").to_array()
    if row0.iter().all(fn(ch) { ch == '.' }) {
      let height = mid.length()
      let p = [height, height, height, height, height]
      for idx, line in mid {
        for idy, ch in line {
          if ch == '.' { p[idy] = height - idx - 1 }
        }
      }
      Key(p)
    } else {
      let p = [0, 0, 0, 0, 0]
      for idx, line in mid {
        for idy, ch in line {
          if ch == '#' { p[idy] = idx + 1 }
        }
      }
      Lock(p)
    }
  })
  // println(patterns)
  let keys = patterns.filter(fn {
    Key(_) => true
    Lock(_) => false
  }).map(fn { Key(p) => p })
  let locks = patterns.filter(fn {
    Key(_) => false
    Lock(_) => true
  }).map(fn { Lock(p) => p })
  let mut count = 0
  for k in keys {
    for l in locks {
      for idx in 0..<k.length() {
        if k[idx] + l[idx] > 5 { break }
      } else { count += 1; }
    }
  }
  count.to_int64()
}

test "day25_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day25.test")
  assert_eq!(part1(input), 3)
}

test "day25_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day25.input")
  inspect!(part1(input), content="3264")
}

fn part2(input: String) -> Int64 {
  let lines = input.split("\r\n")
  1
}

test "day25_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day25.test")
  assert_eq!(part2(input), 31)
}

test "day25_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day25.input")
  inspect!(part2(input))
}
