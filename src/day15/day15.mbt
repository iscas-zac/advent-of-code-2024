// fn parse(s: String) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
// fn parsec(s: Char) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
typealias Board[T] = @utils.Board[T]

fn part1(input: String) -> Int64 {
  guard let [board, dirs] = input.split("\r\n\r\n").collect() else { _ => panic() }
  let board: Board[Char] = board.split("\r\n").map(fn(s) { s.to_array() }).collect()
  let dirs = dirs.replace_all(old="\r\n", new="").iter().map(fn {
    '^' => (0, -1)
    'v' => (0, +1)
    '<' => (-1, 0)
    '>' => (+1, 0)
    _ => panic()
  }).collect()
  let mut init = board.eachi(None, fn(ch, res, loc) { if ch == '@' { Some(loc) } else { res }}).unwrap()
  let boxes = board.eachi([], fn(ch, res, loc) { if ch == 'O' { res..push(loc) } else { res }})
  let mut boxes = Set::from_array(boxes)
  let walls = board.eachi([], fn(ch, res, loc) { if ch == '#' { res..push(loc) } else { res }})
  let walls = Set::from_array(walls)
  fn update(dir: (Int, Int)) {
    let movable = []
    let mut next_init = init
    let moved_boxes = Set::of([])
    loop Some(init) {
      None => break
      Some(to_move) => {
        let next_ind = Board::add(to_move, dir)
        if boxes.contains(next_ind) { movable.push(to_move); continue Some(next_ind) }
        else if walls.contains(next_ind) { movable.clear(); break }
        else { movable.push(to_move); continue None }
      }
    }
    for loc in movable {
      if init == loc { next_init = Board::add(loc, dir) }
      else { moved_boxes.add(loc) }
    }
    init = next_init
    boxes = boxes.difference(moved_boxes).union(Set::from_iter(moved_boxes.iter().map(fn(loc) { Board::add(loc, dir) })))
  }
  for dir in dirs {
    update(dir)
    // let mut temp = ""
    // for y in 0..<board.height() {
    //   for x in 0..<board.width() {
    //     if boxes.contains((x, y)) { temp = temp + "O" }
    //     else if init == (x, y) { temp = temp + "@" }
    //     else { temp = temp + "." }
    //   }
    //   temp = temp + "\n"
    // }
    // println(temp)
    // println("")
  }

  boxes.iter().fold(init=0, fn(acc, loc) { acc + (loc.0 + 100 * loc.1).to_int64() })
}

test "day15_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day15.test")
  assert_eq!(part1(input), 10092)
}

test "day15_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day15.input")
  inspect!(part1(input), content="1485257")
}

fn part2(input: String) -> Int64 {
  guard let [board, dirs] = input.split("\r\n\r\n").collect() else { _ => panic() }
  let board: Board[Char] = board.split("\r\n").map(fn(s) { s.to_array().map(fn {
    '#' => ['#', '#']
    'O' => ['[', ']']
    '.' => ['.', '.']
    '@' => ['@', '.']
    _ => panic()
  }).flatten() }).collect()
  let dirs = dirs.replace_all(old="\r\n", new="").iter().map(fn {
    '^' => (0, -1)
    'v' => (0, +1)
    '<' => (-1, 0)
    '>' => (+1, 0)
    _ => panic()
  }).collect()
  let mut init = board.eachi(None, fn(ch, res, loc) { if ch == '@' { Some(loc) } else { res }}).unwrap()
  println(init)
  let boxes = board.eachi([], fn(ch, res, loc) { if ch == '[' { res..push(loc) } else { res }})
  let mut boxes = Set::from_array(boxes)
  let walls = board.eachi([], fn(ch, res, loc) { if ch == '#' && loc.0 % 2 == 0 { res..push(loc) } else { res }})
  let walls = Set::from_array(walls)
  let mut cnt = 0
  fn update(dir: (Int, Int)) {
    let movable = []
    let mut next_init = init
    let moved_boxes = Set::of([])
    loop [init] {
      [] => break
      lst => {
        movable.append(lst)
        let nexts = []
        let hittables = lst.map(fn(loc) {
          match dir {
            (0, 1) | (0, -1) => {
              if loc == init { [Board::add(loc, dir), Board::add(Board::add(loc, dir), (-1, 0))] }
              else { [Board::add(loc, dir), Board::add(Board::add(loc, dir), (-1, 0)), Board::add(Board::add(loc, dir), (1, 0))] }
            }
            (1, 0) | (-1, 0) => {
              if loc == init && dir == (1, 0) { [Board::add(loc, dir)] }
              else if dir == (1, 0) { [Board::add(loc, (2, 0))] }
              else { [Board::add(loc, (-2, 0))] }
            }
            _ => panic()
          }
        }).flatten()
        for hittable in hittables {
          if boxes.contains(hittable) { nexts.push(hittable) }
          else if walls.contains(hittable) { movable.clear(); nexts.clear(); break }
        }
        continue nexts
      }
    }
    for loc in movable {
      if init == loc { next_init = Board::add(loc, dir) }
      else { moved_boxes.add(loc) }
    }
    // let mut content = "\{cnt} = @ \{dir} \{init}\n"
    // if init == next_init { content = "" }
    init = next_init
    // for box in moved_boxes.iter() {
      // content += "\{cnt} = [ with \{box.0}, \{box.1} \n"
    // }
    // let a = @fs.read_file_to_string?(path="src/day15/moves1.txt").unwrap()
    // @fs.write_string_to_file(path="src/day15/moves1.txt", content=a+content)
    boxes = boxes.difference(moved_boxes).union(Set::from_iter(moved_boxes.iter().map(fn(loc) { Board::add(loc, dir) })))
  }
  for dir in dirs {
    update(dir)
    cnt += 1
  }
    let mut temp = ""
    for y in 0..<board.height() {
      for x in 0..<board.width() {
        if boxes.contains((x, y)) { temp = temp + "[" }
        else if boxes.contains((x-1, y)) { temp = temp + "]" }
        else if walls.contains((x, y)) { temp = temp + "#" }
        else if walls.contains((x-1, y)) { temp = temp + "#" }
        else if init == (x, y) { temp = temp + "@" }
        else { temp = temp + "." }
      }
      temp = temp + "\n"
    }
    println(temp)
    println("")
    println(dirs.length())

  boxes.iter().fold(init=0, fn(acc, loc) { acc + (loc.0 + 100 * loc.1).to_int64() })
}

test "day15_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day15.test")
  assert_eq!(part2(input), 9021)
}

test "day15_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day15.input")
  inspect!(part2(input), content="1475512")
}
