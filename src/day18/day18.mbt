fn parse(s: String) -> Int { @strconv.parse_int?(s.to_string()).unwrap() }
fn parsec(s: Char) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }

typealias Board[T] = @utils.Board[T]
fn part1(input: String, range: Int, bytes: Int) -> Int64 {
  let falling = input.split("\r\n")
    .map(fn(s) { s.split(",").map(parse).collect() })
    .map(fn(l) { (l[0], l[1]) })
  let board: Board[Char] = Array::make(range, 0).map(fn(_s) { Array::make(range, '.') })
  for tup in falling[:bytes] {
    guard board.set2(tup, '#') else { panic() }
  }
  let costs = loop [(0, 0)], Map::from_array([((0, 0), 0)]) {
    [], map => break map
    working, m => continue [(-1, 0), (1, 0), (0, -1), (0, 1)].map(fn(dir) {
      let changed = []
      for loc in working {
        let v = m[loc].unwrap() + 1
        let nex = Board::add(dir, loc)
        if board.out_of_bound(nex) || board.get2(nex) == Some('#') { continue } 
        if m[nex] == None || m[nex].unwrap() > v {
          m[nex] = v
          changed.push(nex)
        }
      }
      changed
    }).flatten(), m
  }
  
  costs[(range-1, range-1)].unwrap().to_int64()
}

test "day18_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day18.test")
  assert_eq!(part1(input, 7, 12), 22)
}

test "day18_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day18.input")
  inspect!(part1(input, 71, 1024), content="436")
}

fn part2(input: String, range: Int, bytes: Int) -> String {
  let falling = input.split("\r\n")
    .map(fn(s) { s.split(",").map(parse).collect() })
    .map(fn(l) { (l[0], l[1]) })
    .collect()
  let board: Board[Char] = Array::make(range, 0).map(fn(_s) { Array::make(range, '.') })
  fn reachable(bytes) {
    for tup in falling {
      guard board.set2(tup, '.') else { panic() }
    }
    for tup in falling[:bytes] {
      guard board.set2(tup, '#') else { panic() }
    }
    let preds = loop [(0, 0)], Set::of([(0, 0)]) {
      [], map => break map
      working, m => continue [(-1, 0), (1, 0), (0, -1), (0, 1)].map(fn(dir) {
        let changed = []
        for loc in working {
          let nex = Board::add(dir, loc)
          if board.out_of_bound(nex) || board.get2(nex) == Some('#') { continue } 
          if not(m.contains(nex)) {
            changed.push(nex)
            m.add(nex)
          }
        }
        changed
      }).flatten()..dedup(), m
    }
    preds
  }

  let len = falling.length()
  let nth = loop 0, (len - 1) / 2, len - 1, reachable((len-1)/2).contains((range-1, range-1)) {
    lo, mid, _hi, false => {
      if mid == lo + 1 { break lo }
      else { continue lo, (lo+mid)/2, mid, reachable((lo+mid)/2).contains((range-1, range-1)) }
    }
    _lo, mid, hi, true => {
      if mid == hi - 1 { break mid }
      else { continue mid, (hi+mid)/2, hi, reachable((hi+mid)/2).contains((range-1, range-1)) }
    }
  }
  let item = falling[nth]
  item.0.to_string() + "," + item.1.to_string()
}

test "day18_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day18.test")
  assert_eq!(part2(input, 7, 12), "6,1")
}

test "day18_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day18.input")
  inspect!(part2(input, 71, 1024), content="61,50")
}
