fn parse(s: String) -> Int { @strconv.parse_int?(s.to_string()).unwrap() }
// fn parsec(s: Char) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
fn part1(input: String) -> Int64 {
  let sets = input.split("\r\n\r\n")
    .map(fn(s) {
      let lines = s.split("\r\n").collect()
      let a_moves = lines[0].trim_start("Button A: ")
        .split(", ").collect()
      let [x, y] = a_moves
      let a_x = x.split("+").collect().last().unwrap()
      let a_y = y.split("+").collect().last().unwrap()
      let a_x = parse(a_x)
      let a_y = parse(a_y)
      let b_moves = lines[1].trim_start("Button B: ")
        .split(", ").collect()
      let [x, y] = b_moves
      let b_x = x.split("+").collect().last().unwrap()
      let b_y = y.split("+").collect().last().unwrap()
      let b_x = parse(b_x)
      let b_y = parse(b_y)
      let prize_locs = lines[2].trim_start("Prize: ")
        .split(", ").collect()
      let [x, y] = prize_locs
      let prize_x = x.split("=").collect().last().unwrap()
      let prize_y = y.split("=").collect().last().unwrap()
      let prize_x = parse(prize_x)
      let prize_y = parse(prize_y)
      (a_x, a_y, b_x, b_y, prize_x, prize_y)
    }).collect()
  sets.map(fn { (ax, ay, bx, by, targetx, targety) => {
    // ax * a + bx * b = targetx
    // ay * a + by * b = targety
    // min(3 * a + b)
    let mut maxa = targetx / ax
    if targety / ay < maxa { maxa = targety / ay }
    let mut minsum = None
    for a in 0..=maxa {
      let b = (targetx - ax * a) / bx
      if ax * a + bx * b == targetx && ay * a + by * b == targety {
        if minsum == None { minsum = Some(3 * a + b) }
        let Some(score) = minsum
        if score > 3*a + b { minsum = Some(3 * a + b) }
      }
    }
    match minsum { Some(score) => score; None => 0 }
  }}).fold(init=0, fn(x, y) { x + y.to_int64() })
}

test "day13_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day13.test")
  assert_eq!(part1(input), 480)
}

test "day13_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day13.input")
  inspect!(part1(input), content="29711")
}

fn part2(input: String) -> Int64 {
  let sets = input.split("\r\n\r\n")
    .map(fn(s) {
      let lines = s.split("\r\n").collect()
      let a_moves = lines[0].trim_start("Button A: ")
        .split(", ").collect()
      let [x, y] = a_moves
      let a_x = x.split("+").collect().last().unwrap()
      let a_y = y.split("+").collect().last().unwrap()
      let a_x = parse(a_x)
      let a_y = parse(a_y)
      let b_moves = lines[1].trim_start("Button B: ")
        .split(", ").collect()
      let [x, y] = b_moves
      let b_x = x.split("+").collect().last().unwrap()
      let b_y = y.split("+").collect().last().unwrap()
      let b_x = parse(b_x)
      let b_y = parse(b_y)
      let prize_locs = lines[2].trim_start("Prize: ")
        .split(", ").collect()
      let [x, y] = prize_locs
      let prize_x = x.split("=").collect().last().unwrap()
      let prize_y = y.split("=").collect().last().unwrap()
      let prize_x = parse(prize_x)
      let prize_y = parse(prize_y)
      (a_x.to_int64(), a_y.to_int64(), b_x.to_int64(), b_y.to_int64(),
        prize_x.to_int64() + 10000000000000, prize_y.to_int64() + 10000000000000)
    }).collect()
  sets.map(fn { (ax, ay, bx, by, targetx, targety) => {
    // ax * a + bx * b = targetx
    // ay * a + by * b = targety
    // min(3 * a + b)
    let ua = (by * targetx - bx * targety)
    let ub = (ax * targety - ay * targetx)
    let d = ax * by - ay * bx
    (if d == 0 {
      if targetx * ay == targety * ax { panic() }
      else { (0).to_int64() }
    }
    else if ua % d == 0 && ub % d == 0 { println(d); (3).to_int64() * ua / d + ub / d }
    else { (0).to_int64() })
  }}).fold(init=0, fn(x, y) { x + y })
}

test "day13_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day13.test")
  assert_eq!(part2(input), 31)
}

test "day13_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day13.input")
  inspect!(part2(input), content="94955433618919")
}
