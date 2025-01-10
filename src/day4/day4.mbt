fn part1(input: String) -> Int {
  let block = input.split("\r\n").map(fn { s => s.to_array() }).to_array()
  let height = block.length()
  let width = block[0].length()
  fn search_next(this: (Int, Int), direction: (Int, Int), target: Char) -> Bool {
    if this.0 + direction.0 < 0 { return false }
    if this.0 + direction.0 >= height { return false }
    if this.1 + direction.1 < 0 { return false }
    if this.1 + direction.1 >= width { return false }
    block[this.0 + direction.0][this.1 + direction.1] == target
  }
  let directions = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, -1), (1, 1)]
  let mut instances = 0
  for x in 0..<height {
    for y in 0..<width {
      if block[x][y] == 'X' {
        for dir in directions {
          let mut this = (x, y)
          guard search_next(this, dir, 'M') else { continue }
          this = (this.0 + dir.0, this.1 + dir.1)
          guard search_next(this, dir, 'A') else { continue }
          this = (this.0 + dir.0, this.1 + dir.1)
          guard search_next(this, dir, 'S') else { continue }
          // println((x, y))
          // println(dir)
          // println("")
          instances += 1
        }
      }
    }
  }
  instances
}

test "day4_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day4.test")
  assert_eq!(part1(input), 18)
}

test "day4_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day4.input")
  inspect!(part1(input), content="2618")
}

fn part2(input: String) -> Int {
  let block = input.split("\r\n").map(fn { s => s.to_array() }).to_array()
  let height = block.length()
  let width = block[0].length()
  fn search_next(this: (Int, Int), direction: (Int, Int), target: Char) -> Bool {
    if this.0 + direction.0 < 0 { return false }
    if this.0 + direction.0 >= height { return false }
    if this.1 + direction.1 < 0 { return false }
    if this.1 + direction.1 >= width { return false }
    block[this.0 + direction.0][this.1 + direction.1] == target
  }
  // let directions = [(-1, 0), (1, 0), (0, -1), (0, 1), (-1, -1), (-1, 1), (1, -1), (1, 1)]
  let directions = [(-1, 0), (1, 0), (0, -1), (0, 1)]
  let mut instances = 0
  for x in 0..<height {
    for y in 0..<width {
      if block[x][y] == 'A' {
        for dir in directions {
          let (m1, m2) = if dir.0 != 0 { ((dir.0, -1), (dir.0, 1)) }
            else { ((-1, dir.1), (1, dir.1)) }
          let (s1, s2) = if dir.0 != 0 { ((-dir.0, -1), (-dir.0, 1)) }
            else { ((-1, -dir.1), (1, -dir.1)) }
          guard search_next((x, y), m1, 'M') else { continue }
          guard search_next((x, y), m2, 'M') else { continue }
          guard search_next((x, y), s1, 'S') else { continue }
          guard search_next((x, y), s2, 'S') else { continue }
          // println((x, y))
          // println(dir)
          // println("")
          instances += 1
        }
      }
    }
  }
  instances
}

test "day4_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day4.test")
  assert_eq!(part2(input), 9)
}

test "day4_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day4.input")
  inspect!(part2(input), content="2011")
}
