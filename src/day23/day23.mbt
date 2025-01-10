fn parse(s: String) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
fn parsec(s: Char) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
fn part1(input: String) -> Int64 {
  let links = input.split("\r\n").map(fn(x) {
    let [a, b] = x.split("-").to_array()
    (a, b)
  })
  let items = Set::from_array(links.map(fn { (x, y) => [x, y] }).to_array().flatten())
  let table = Map::of([])
  for item in links {
    let (left, right) = item
    if table[left] == None {
      table[left] = Set::of([])
    }
    table[left].unwrap().add(right)
    if table[right] == None {
      table[right] = Set::of([])
    }
    table[right].unwrap().add(left)
  }

  let all_connect = {}
  for i1 in items {
    guard let Some(neighbors) = table[i1] else { _ => continue }
    for i2 in neighbors {
      let commons = table[i2].unwrap().intersection(neighbors)
      for i3 in commons {
        all_connect[[i1, i2, i3]..sort().to_string()] = [i1, i2, i3]
      }
    }
  }
  let mut count = 0
  for name in all_connect.keys() {
    if name.contains("\"t") { count += 1 }
  }

  count.to_int64()
}

test "day23_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day23.test")
  assert_eq!(part1(input), 7)
}

test "day23_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day23.input")
  inspect!(part1(input), content="1173")
}

fn joinTo[T: Show](this: Array[T]) -> String {
  if this.is_empty() { "" }
  else {
    let base = this[0].to_string()
    loop base, this[1:] {
      res, [] => break res
      base, [hd, .. as tl] => { continue base + "," + hd.to_string(), tl }
    }
  }
}

fn part2(input: String) -> String {
  let links = input.split("\r\n").map(fn(x) {
    let [a, b] = x.split("-").to_array()
    (a, b)
  })
  let items = Set::from_array(links.map(fn { (x, y) => [x, y] }).to_array().flatten())
  let table = Map::of([])
  for item in links {
    let (left, right) = item
    if table[left] == None {
      table[left] = Set::of([])
    }
    table[left].unwrap().add(right)
    if table[right] == None {
      table[right] = Set::of([])
    }
    table[right].unwrap().add(left)
  }
  let all_connect = {}
  for i1 in items {
    guard let Some(neighbors) = table[i1] else { _ => continue }
    for i2 in neighbors {
      let commons = table[i2].unwrap().intersection(neighbors)
      for i3 in commons {
        all_connect[joinTo([i1, i2, i3]..sort())] = (
          [i1, i2, i3],
          table[i1].unwrap()
            .intersection(table[i2].unwrap())
            .intersection(table[i3].unwrap())
        )
      }
    }
  }
  let last_big_map = loop {}, all_connect {
    last, this => {
      if this.is_empty() { break last }
      let new_connect = {}
      for _, v in this {
        let (members, extensions) = v
        for i4 in extensions.iter() {
          new_connect[joinTo([i4, ..members]..sort())] = (
            [i4, ..members],
            members.fold(init=table[i4].unwrap(), fn(acc, name) {
              acc.intersection(table[name].unwrap())
            })
          )
        }
      }
      continue this, new_connect
    }
  }
  for k, _ in last_big_map {
    return k
  } else { "" }
}

test "day23_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day23.test")
  assert_eq!(part2(input), "co,de,ka,ta")
}

test "day23_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day23.input")
  inspect!(part2(input), content="cm,de,ez,gv,hg,iy,or,pw,qu,rs,sn,uc,wq")
}