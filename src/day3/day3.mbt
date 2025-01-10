fn part1(input: String) -> Int {
  let mut cur = 0
  let len = input.length()
  fn read_int() -> Option[Int] {
    if cur >= len { return None }
    let s = input[cur]
    let _1 = try @strconv.parse_int!(s.to_string()) catch { _ => return None }
    if cur + 1 >= len { return None }
    let s = input[cur + 1]
    if s == ',' || s == ')' { cur += 1; return Some(_1) }
    let _2 = try @strconv.parse_int!(s.to_string()) catch { _ => return None }
    if cur + 2 >= len { return None }
    let s = input[cur + 2]
    if s == ',' || s == ')' { cur += 2; return Some(_1 * 10 + _2) }
    let _3 = try @strconv.parse_int!(s.to_string()) catch { _ => return None }
    cur += 3
    Some(_1 * 100 + _2 * 10 + _3)
  }
  let mut sum = 0
  while (cur < len) {
    let mem = cur
    if cur + 4 > len { cur = mem + 1; continue }
    if input.substring(start=cur, end=cur+4) == "mul(" {
      cur += 4
      // println(input[cur])
      guard let Some(left) = read_int() else { _ => cur = mem + 1; }
      if cur >= len { cur = mem + 1; continue }
      // println(input[cur])
      if input[cur] != ',' { continue; }
      cur += 1
      // println(input[cur])
      guard let Some(right) = read_int() else { _ => cur = mem + 1; }
      if cur >= len { cur = mem + 1; continue }
      if input[cur] != ')' { continue; }
      cur += 1
      sum += left * right
    } else { cur += 1 }
  }
  sum
}

test "day3_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day3.test")
  assert_eq!(part1(input), 161)
}

test "day3_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day3.input")
  inspect!(part1(input), content="173529487")
}

fn part2(input: String) -> Int {
    let mut cur = 0
  let len = input.length()
  fn read_int() -> Option[Int] {
    if cur >= len { return None }
    let s = input[cur]
    let _1 = try @strconv.parse_int!(s.to_string()) catch { _ => return None }
    if cur + 1 >= len { return None }
    let s = input[cur + 1]
    if s == ',' || s == ')' { cur += 1; return Some(_1) }
    let _2 = try @strconv.parse_int!(s.to_string()) catch { _ => return None }
    if cur + 2 >= len { return None }
    let s = input[cur + 2]
    if s == ',' || s == ')' { cur += 2; return Some(_1 * 10 + _2) }
    let _3 = try @strconv.parse_int!(s.to_string()) catch { _ => return None }
    cur += 3
    Some(_1 * 100 + _2 * 10 + _3)
  }
  let mut sum = 0
  let mut do_op = true
  while (cur < len) {
    let mem = cur
    match input[cur] {
      'm' => {
        if cur + 4 > len { cur = mem + 1; continue }
        if input.substring(start=cur, end=cur+4) == "mul(" {
          cur += 4
          guard let Some(left) = read_int() else { _ => cur = mem + 1; }
          if cur >= len { cur = mem + 1; continue }
          if input[cur] != ',' { continue; }
          cur += 1
          guard let Some(right) = read_int() else { _ => cur = mem + 1; }
          if cur >= len { cur = mem + 1; continue }
          if input[cur] != ')' { continue; }
          cur += 1
          if do_op == true { sum += left * right }
        } else { cur += 1 }
      }
      'd' => {
        if (cur + 1 < len && input[cur + 1] == 'o') {
          if (cur + 4 < len && input.substring(start=cur, end=cur+5) == "don't") {
            do_op = false
            cur = cur + 5
          } else { do_op = true; cur = cur + 2 }
        } else { cur = cur + 1 }
      }
      _ => cur += 1
    }
    
  }
  sum
}

test "day3_part2_test" {
  let input = #|xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
  assert_eq!(part2(input), 48)
}

test "day3_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day3.input")
  inspect!(part2(input), content="99532691")
}
