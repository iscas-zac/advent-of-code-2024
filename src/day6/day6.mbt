fn part1(input: String) -> Int {
  let board = input.split("\r\n").map(fn { s => s.to_array() }).to_array()
  let height = board.length()
  let width = board[0].length()
  fn loc(c: Char) -> Bool {
    c == 'v' || c == '^' || c == '<' || c == '>'
  }
  let guard_loc_y = board.search_by(fn { s => false == s.search_by(loc).is_empty() }).unwrap()
  let guard_loc_x = board[guard_loc_y].search_by(loc).unwrap()
  let trace = board.copy()
  let init_dir = board[guard_loc_y][guard_loc_x]
  let mut current_x = guard_loc_x
  let mut current_y = guard_loc_y
  let mut dir = init_dir
  fn proceed() -> Bool {
    let (dx, dy) = match dir {
      'v' => (0, 1)
      '^' => (0, -1)
      '<' => (-1, 0)
      '>' => (1, 0)
      _ => panic()
    }
    if current_y + dy < 0 || current_y + dy >= height ||
      current_x + dx < 0 || current_x + dx >= width { return true }
    if board[current_y + dy][current_x + dx] == '#' {
      dir = match dir {
        'v' => '<'
        '^' => '>'
        '<' => '^'
        '>' => 'v'
        _ => panic()
      }
    } else {
      trace[current_y][current_x] = 'x'
      current_x = current_x + dx
      current_y = current_y + dy
    }
    false
  }
  while(false == proceed()) {}
  // println(trace.join("\n"))
  1 + trace.map(fn { s => s.filter(fn { c => c == 'x' }).length() }).fold(init=0, fn { x, y => x + y })
}

test "day6_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day6.test")
  assert_eq!(part1(input), 41)
}

test "day6_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day6.input")
  inspect!(part1(input), content="5564")
}

fn part2(input: String) -> Int {
  let board = input.split("\r\n").map(fn { s => s.to_array() }).to_array()
  let height = board.length()
  let width = board[0].length()
  fn loc(c: Char) -> Bool {
    c == 'v' || c == '^' || c == '<' || c == '>'
  }
  let guard_loc_y = board.search_by(fn { s => false == s.search_by(loc).is_empty() }).unwrap()
  let guard_loc_x = board[guard_loc_y].search_by(loc).unwrap()
  let trace = board.copy()
  let init_dir = board[guard_loc_y][guard_loc_x]
  let mut current_x = guard_loc_x
  let mut current_y = guard_loc_y
  let mut dir = init_dir
  fn proceed() -> Bool {
    let (dx, dy) = match dir {
      'v' => (0, 1)
      '^' => (0, -1)
      '<' => (-1, 0)
      '>' => (1, 0)
      _ => panic()
    }
    if current_y + dy < 0 || current_y + dy >= height ||
      current_x + dx < 0 || current_x + dx >= width { return true }
    if board[current_y + dy][current_x + dx] == '#' {
      dir = match dir {
        'v' => '<'
        '^' => '>'
        '<' => '^'
        '>' => 'v'
        _ => panic()
      }
    } else {
      trace[current_y][current_x] = 'x'
      current_x = current_x + dx
      current_y = current_y + dy
    }
    false
  }
  let mut count = 0
  println(123)
  // while(false == proceed()) {}
  for x in 0..<width {
    for y in 0..<height {
      current_x = guard_loc_x
      current_y = guard_loc_y
      dir = init_dir
      let new_path = []
      let phantom = board[y][x]
      board[y][x] = '#'
      
      while(false == proceed()) {
        if new_path.contains((current_x, current_y, dir)) {
          count += 1
          // board[y][x] = 'O'
          // println(board)
          // println("")
          break
        }
        new_path.push((current_x, current_y, dir))
      }
      board[y][x] = phantom
      // println(x)
      // println(y)
    }
  }
  // for x, y, dir in path {
  //   let (vx, vy) = (x, y)
  //   let (this_turn, dx, dy) = match dir {
  //     'v' => ('<', -1, 0)
  //     '^' => ('>', 1, 0)
  //     '<' => ('^', 0, -1)
  //     '>' => ('v', 0, 1)
  //     _ => panic()
  //   }
  //   while false == (vy + dy < 0 || vy + dy >= height ||
  //     vx + dx < 0 || vx + dx >= width || board[vy + dy][vx + dx] == '#') {
  //     if (path.contains((vx, vy, this_turn))) { count += 1 }
  //     vy = vy + dy
  //     vx = vx + dx
  //   }
  // }
  count
}

test "day6_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day6.test")
  assert_eq!(part2(input), 6)
}

test "day6_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day6.input")
  inspect!(part2(input), content="1976")
}
