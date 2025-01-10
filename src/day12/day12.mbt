typealias Board[T] = @utils.Board[T]
// fn parse(s: String) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
// fn parsec(s: Char) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
fn part1(input: String) -> Int64 {
  let board: Board[_] = input.split("\r\n").map(fn(s) { s.to_array() }).collect()
  let chars = board.each(Set::from_array([]), fn { ch, acc => {
    acc..add(ch)
  }})
  let regions = chars.iter().map(fn(c) {
    board.eachi([], fn { ch, acc, (x, y) => { if ch == c { acc..push((x, y)) } else { acc }}})
  })
  fn find_neighbors(tup: (Int, Int)) -> Array[(Int, Int)] {
    let (x, y) = tup
    [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
  }
  let discretes = regions.map(fn(locs) {
    let mut remains = locs.copy()
    let res = []
    loop remains.pop() {
      Some(loc) => {
        let this = [loc]
        let mut neighbors = this.map(find_neighbors).flatten()
        let mut inters = Set::from_array(neighbors).intersection(Set::from_array(remains))
        while (not(inters.is_empty())) {
          this.append(inters.to_array())
          neighbors = this.map(find_neighbors).flatten()
          remains = Set::from_array(remains).difference(inters).to_array()
          inters = Set::from_array(neighbors).intersection(Set::from_array(remains))
        }
        res.append([this])
        continue remains.pop()
      }
      None => break
    }
    res
  }).to_array().flatten()

  // println(discretes)

  discretes.map(fn(region) {
    let area = region.length()
    let perimeter = region.map(fn (loc) {
      4 - find_neighbors(loc).filter(fn(nei) { region.contains(nei) }).length()
    }).fold(init=0, fn(a, b) { a + b })
    area * perimeter
  }).fold(init=0, fn(a, b) { a + b }).to_int64()
}

test "day12_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day12.test")
  assert_eq!(part1(input), 140)
}

test "day12_part1_examine" {
  println(@int.max_value)
  let input = @fs.read_file_to_string!(path="data/day12.input")
  inspect!(part1(input), content="1450816")
}

fn part2(input: String) -> Int64 {
    let board: Board[_] = input.split("\r\n").map(fn(s) { s.to_array() }).collect()
  let chars = board.each(Set::from_array([]), fn { ch, acc => {
    acc..add(ch)
  }})
  let regions = chars.iter().map(fn(c) {
    board.eachi([], fn { ch, acc, (x, y) => { if ch == c { acc..push((x, y)) } else { acc }}})
  })
  fn find_neighbors(tup: (Int, Int)) -> Array[(Int, Int)] {
    let (x, y) = tup
    [(x + 1, y), (x - 1, y), (x, y + 1), (x, y - 1)]
  }
  let discretes = regions.map(fn(locs) {
    let mut remains = locs.copy()
    let res = []
    loop remains.pop() {
      Some(loc) => {
        let this = [loc]
        let mut neighbors = this.map(find_neighbors).flatten()
        let mut inters = Set::from_array(neighbors).intersection(Set::from_array(remains))
        while (not(inters.is_empty())) {
          this.append(inters.to_array())
          neighbors = this.map(find_neighbors).flatten()
          remains = Set::from_array(remains).difference(inters).to_array()
          inters = Set::from_array(neighbors).intersection(Set::from_array(remains))
        }
        res.append([this])
        continue remains.pop()
      }
      None => break
    }
    res
  }).to_array().flatten()

  // println(discretes)

  discretes.map(fn(region) {
    let area = region.length()
    let sides = region.map(fn {(x, y) => {
      let d = region.contains((x, y - 1))
      let u = region.contains((x, y + 1))
      let l = region.contains((x - 1, y))
      let r = region.contains((x + 1, y))
      let ul = region.contains((x - 1, y + 1))
      let ur = region.contains((x + 1, y + 1))
      let dl = region.contains((x - 1, y - 1))
      let dr = region.contains((x + 1, y - 1))
      (if (d && l && not(dl)) || (not(d) && not(l)) { 1 } else { 0 }) +
      (if (d && r && not(dr)) || (not(d) && not(r)) { 1 } else { 0 }) +
      (if (u && l && not(ul)) || (not(u) && not(l)) { 1 } else { 0 }) +
      (if (u && r && not(ur)) || (not(u) && not(r)) { 1 } else { 0 })
    }}).fold(init=0, fn(a, b) { a + b })
    area * sides
  }).fold(init=0, fn(a, b) { a + b }).to_int64()
}

test "day12_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day12.test")
  assert_eq!(part2(input), 80)
}

test "day12_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day12.input")
  inspect!(part2(input), content="865662")
}
