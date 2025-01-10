// fn parse(s: String) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
// fn parsec(s: Char) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
typealias Board[T] = @utils.Board[T]

fn part1(input: String) -> Int64 {
  let board: Board[Char] = input.split("\r\n").map(fn(s) { s.to_array() }).collect()
  let dirs = [(0, 1), (0, -1), (1, 0), (-1, 0)]
  let start = board.eachi(None, fn(ch, res, loc) { if ch == 'S' { Some(loc) } else { res }}).unwrap()
  let end = board.eachi(None, fn(ch, res, loc) { if ch == 'E' { Some(loc) } else { res }}).unwrap()
  let costs = Map::from_array([((start, (1, 0)), 0)])
  fn rotate(loc: (Int, Int), dir: (Int, Int)) {
    let val = costs[(loc, dir)].unwrap()
    match costs[(loc, (dir.1, -dir.0))] {
      Some(v) => if v > val + 1000 { costs[(loc, (dir.1, -dir.0))] = val + 1000 }
      None => costs[(loc, (dir.1, -dir.0))] = val + 1000
    }
    match costs[(loc, (-dir.1, dir.0))] {
      Some(v) => if v > val + 1000 { costs[(loc, (-dir.1, dir.0))] = val + 1000 }
      None => costs[(loc, (-dir.1, dir.0))] = val + 1000
    }    
  }
  rotate(start, (1, 0))
  fn search(loc: (Int, Int)) -> Array[(Int, Int)] {
    let availables = []
    for dir in dirs {
      guard let Some(v) = costs[(loc, dir)] else { _ => continue }
      let next_loc = Board::add(loc, dir)
      guard board.get2(next_loc) != Some('#') else { continue }
      guard let Some(target) = costs[(next_loc, dir)] else { _ => { costs[(next_loc, dir)] = v + 1; rotate(next_loc, dir); availables.push(next_loc) } }
      if target > v + 1 { costs[(next_loc, dir)] = v + 1; rotate(next_loc, dir); availables.push(next_loc) }
    }
    availables
  }
  loop [start] {
    [] => break
    lst => { continue lst.map(fn(loc) { search(loc) }).flatten() }
  }
  dirs.map(fn(dir) { costs[(end, dir)].or(@int.max_value) }).fold(init=@int.max_value, fn(acc, v) { if acc < v { acc } else { v } }).to_int64()
}

test "day16_part1_test1" {
  let input = @fs.read_file_to_string!(path="data/day16.test1")
  assert_eq!(part1(input), 7036)
}

test "day16_part1_test2" {
  let input = @fs.read_file_to_string!(path="data/day16.test2")
  assert_eq!(part1(input), 11048)
}

test "day16_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day16.input")
  inspect!(part1(input), content="109496")
}

fn part2(input: String) -> Int64 {
    let board: Board[Char] = input.split("\r\n").map(fn(s) { s.to_array() }).collect()
  let dirs = [(0, 1), (0, -1), (1, 0), (-1, 0)]
  let start = board.eachi(None, fn(ch, res, loc) { if ch == 'S' { Some(loc) } else { res }}).unwrap()
  let end = board.eachi(None, fn(ch, res, loc) { if ch == 'E' { Some(loc) } else { res }}).unwrap()
  let costs = Map::from_array([((start, (1, 0)), 0)])
  fn rotate(loc: (Int, Int), dir: (Int, Int)) {
    let val = costs[(loc, dir)].unwrap()
    match costs[(loc, (dir.1, -dir.0))] {
      Some(v) => if v > val + 1000 { costs[(loc, (dir.1, -dir.0))] = val + 1000 }
      None => costs[(loc, (dir.1, -dir.0))] = val + 1000
    }
    match costs[(loc, (-dir.1, dir.0))] {
      Some(v) => if v > val + 1000 { costs[(loc, (-dir.1, dir.0))] = val + 1000 }
      None => costs[(loc, (-dir.1, dir.0))] = val + 1000
    }    
  }
  rotate(start, (1, 0))
  fn search(loc: (Int, Int)) -> Array[(Int, Int)] {
    let availables = []
    for dir in dirs {
      guard let Some(v) = costs[(loc, dir)] else { _ => continue }
      let next_loc = Board::add(loc, dir)
      guard board.get2(next_loc) != Some('#') else { continue }
      guard let Some(target) = costs[(next_loc, dir)] else { _ => { costs[(next_loc, dir)] = v + 1; rotate(next_loc, dir); availables.push(next_loc) } }
      if target > v + 1 { costs[(next_loc, dir)] = v + 1; rotate(next_loc, dir); availables.push(next_loc) }
    }
    availables
  }
  loop [start] {
    [] => break
    lst => { continue lst.map(fn(loc) { search(loc) }).flatten() }
  }
  let best = dirs.map(fn(dir) { costs[(end, dir)].or(@int.max_value) }).fold(init=@int.max_value, fn(acc, v) { if acc < v { acc } else { v } })
  let best_dirs = dirs.filter(fn(dir) { costs[(end, dir)] == Some(best) })
  fn backwards(loc: (Int, Int), dir: (Int, Int)) -> Array[((Int, Int), (Int, Int))] {
    let this = costs[(loc, dir)].unwrap()
    let availables = []
    for d in [dir, (-dir.1, dir.0), (dir.1, -dir.0)] {
      let prev_loc = Board::add(loc, (-d.0, -d.1))
      guard let Some(target) = costs[(prev_loc, d)] else { _ => continue }
      if (d == dir && target == this - 1) || (target == this - 1001) { availables.push((prev_loc, d)) }
    }
    availables
  }
  let nodes = Set::of([])
  loop best_dirs.map(fn(dir) { (end, dir) }) {
    [] => break
    lst => {
      for p in lst {
        let (node, _) = p
        nodes.add(node)
      }
      // println(lst)
      continue lst.map(fn { (loc, dir) => { backwards(loc, dir) } }).flatten()
    }
  }
  nodes.size().to_int64()
}

test "day16_part2_test1" {
  let input = @fs.read_file_to_string!(path="data/day16.test1")
  assert_eq!(part2(input), 45)
}
test "day16_part2_test2" {
  let input = @fs.read_file_to_string!(path="data/day16.test2")
  assert_eq!(part2(input), 64)
}

test "day16_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day16.input")
  inspect!(part2(input), content="551")
}
