fn part1(input: String) -> Int {
  let lines = input.split("\r\n")
  let rules = lines.filter(fn { s => s.contains_char('|') })
    .map(fn { s => {
        let pair = s.split("|").collect()
        (@strconv.parse_int?(pair[0]).unwrap(), @strconv.parse_int?(pair[1]).unwrap())
      } })
  fn check_seq(nums: Array[Int]) -> Bool {
    for rule in rules {
      guard let Some(prev) = nums.search(rule.0) else { _ => continue }
      guard let Some(next) = nums.search(rule.1) else { _ => continue }
      if prev > next {
        // println(123)
        break false
      }
    } else { true }
  }
  let orders = lines.filter(fn { s => s.contains_char(',') })
    .map(fn { s => s.split(",").map(fn { s => @strconv.parse_int?(s).unwrap() }).collect() })
    .collect()
  orders.filter(check_seq).map(fn { seq => {
    let mid = seq.length() / 2
    seq[mid]
  } }).fold(init=0, fn { a, b => a + b })
}

test "day5_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day5.test")
  assert_eq!(part1(input), 143)
}

test "day5_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day5.input")
  inspect!(part1(input), content="5747")
}

fn part2(input: String) -> Int {
  let lines = input.split("\r\n")
  let rules = lines.filter(fn { s => s.contains_char('|') })
    .map(fn { s => {
        let pair = s.split("|").collect()
        (@strconv.parse_int?(pair[0]).unwrap(), @strconv.parse_int?(pair[1]).unwrap())
      } })
  fn sorted(a: Int, b: Int) -> Int {
    for rule in rules {
      if a == rule.0 && b == rule.1 {
        break -1
      } else if a == rule.1 && b == rule.0 {
        break 1
      }
    } else { 0 }
  }
  
  let orders = lines.filter(fn { s => s.contains_char(',') })
    .map(fn { s => s.split(",").map(fn { s => @strconv.parse_int?(s).unwrap() }).collect() })
    .collect()
  
  orders.map(fn { o => (o,
      o.copy()..sort_by(sorted)
    )})
    .filter( fn { (orig, sorted) => orig != sorted })
    .map(fn { (_, sorted) => sorted })
    .map(fn { seq => {
    let mid = seq.length() / 2
    seq[mid]
  } }).fold(init=0, fn { a, b => a + b })
}

test "day5_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day5.test")
  assert_eq!(part2(input), 123)
}

test "day5_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day5.input")
  inspect!(part2(input), content="5502")
}
