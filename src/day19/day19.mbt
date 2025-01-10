fn parse(s: String) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
fn parsec(s: Char) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
fn part1(input: String) -> Int64 {
  let lines = input.split("\r\n\r\n").collect()
  let availables = lines[0].split(", ").collect()
  let targets = lines[1].split("\r\n")
  let cache = {}
  fn reachable(pattern: String) {
    if pattern == "" { return true }
    guard let None = cache[pattern] else { Some(ans) => ans }
    let ans = availables.iter().any(fn(gradient) {
      pattern.starts_with(gradient) && reachable(pattern.replace(old=gradient, new=""))
    })
    cache[pattern] = ans
    ans
  }
  targets.filter(fn(x) { reachable(x) }).count().to_int64()
}

test "day19_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day19.test")
  assert_eq!(part1(input), 6)
}

test "day19_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day19.input")
  inspect!(part1(input), content="272")
}

fn part2(input: String) -> Int64 {
  let lines = input.split("\r\n\r\n").collect()
  let availables = lines[0].split(", ").collect()
  let targets = lines[1].split("\r\n")
  let cache = {}
  fn reachable(pattern: String) -> Int64 {
    if pattern == "" { return 1 }
    guard let None = cache[pattern] else { Some(ans) => ans }
    let ans: Int64 = availables.iter().map(fn(gradient) {
      if pattern.starts_with(gradient) {
        reachable(pattern.replace(old=gradient, new=""))
      } else { (0).to_int64() }
    }).fold(init=0, fn(a, b) { a + b })
    cache[pattern] = ans
    ans
  }
  targets.map(fn(x) { reachable(x) }).fold(init=0, fn(a, b) { a + b })
}

test "day19_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day19.test")
  assert_eq!(part2(input), 16)
}

test "day19_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day19.input")
  inspect!(part2(input), content="1041529704688380")
}
