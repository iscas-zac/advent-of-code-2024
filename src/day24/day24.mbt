fn parse(s: String) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
fn parsec(s: Char) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
fn part1(input: String) -> Int64 {
  let [inits, gates] = input.split("\r\n\r\n").to_array()
  let inits = Map::from_iter(inits.split("\r\n").map(fn(line) {
    let [name, value] = line.split(": ").to_array()
    (name, parse(value))
  }))
  let gates = gates.split("\r\n").map(fn(line) {
    let [left, op, right, _, res] = line.split(" ").to_array()
    (res, op, left, right)
  })
  let zs = gates.map(fn { (res, _, _, _) => {
    if res.starts_with("z") { [(res, parse(res.trim("z")))] }
    else { [] }
  } }).to_array().flatten() |> Map::from_array

  let vals = {}
  let changed = inits.keys()
  for k, v in inits { vals[k] = v }
  fn propagate() {
    for gate in gates {
      guard let Some(left) = vals[gate.2] else { _ => continue }
      guard let Some(right) = vals[gate.3] else { _ => continue }
      match gate.1 {
        "AND" => vals[gate.0] = left & right
        "OR" => vals[gate.0] = left | right
        "XOR" => vals[gate.0] = left ^ right
        _ => panic()
      }
    }
  }
  while zs.keys().any(fn(z) { vals[z] == None }) {
    propagate();
  }
  zs.iter().map(fn { (name, offset) => {
    vals[name].unwrap() << offset.to_int()
  }}).fold(init=0, fn(a, b) { a + b })
}

test "day24_part1_test1" {
  let input = @fs.read_file_to_string!(path="data/day24.test1")
  assert_eq!(part1(input), 4)
}

test "day24_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day24.test")
  assert_eq!(part1(input), 2024)
}

test "day24_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day24.input")
  inspect!(part1(input), content="65740327379952")
}

fn part2(input: String) -> String {
  let [inits, gates] = input.split("\r\n\r\n").to_array()
  let inits = Map::from_iter(inits.split("\r\n").map(fn(line) {
    let [name, value] = line.split(": ").to_array()
    (name, parse(value))
  }))
  let gates = gates.split("\r\n").map(fn(line) {
    let [left, op, right, _, res] = line.split(" ").to_array()
    (res, op, left, right)
  })
  let zs = gates.map(fn { (res, _, _, _) => {
    if res.starts_with("z") { [(res, parse(res.trim("z")))] }
    else { [] }
  } }).to_array().flatten() |> Map::from_array

  let xs = inits.iter().map(fn { (k, _v) => {
    if k.starts_with("x") { [(k, parse(k.trim("x")))] }
    else { [] }
  }}).to_array().flatten() |> Map::from_array

  let ys = inits.iter().map(fn { (k, _v) => {
    if k.starts_with("y") { [(k, parse(k.trim("y")))] }
    else { [] }
  }}).to_array().flatten() |> Map::from_array

  let deps = loop zs.keys().map(fn(k) { (k, Set::of([k])) }) |> Map::from_iter, zs.keys().to_array() {
    res, [] => break res
    deps, changed => {
      let to_change = Set::of([])
      for item in changed {
        if not(deps.contains(item)) { deps[item] = Set::of([]) }
        let dominators = deps[item].unwrap()
        for node in gates.to_array()
          .map(fn { (res, _, l, r) => if res == item { [l, r] } else { [] }})
          .flatten() {
            dominators.add(node)
            to_change.add(node)
        }
        for _, v in deps {
          if v.contains(item) { for x in dominators { v.add(x) }}
        }
      }
      continue deps, to_change.to_array()
    }
  }
  
  fn calculate(x: Int64, y: Int64) {
    let vals = {}
    for k, v in xs { vals[k] = x >> v.to_int() & 1 }
    for k, v in ys { vals[k] = y >> v.to_int() & 1 }
    while zs.keys().any(fn(z) { vals[z] == None }) {
      for gate in gates {
        guard let Some(left) = vals[gate.2] else { _ => continue }
        guard let Some(right) = vals[gate.3] else { _ => continue }
        match gate.1 {
          "AND" => vals[gate.0] = left & right
          "OR" => vals[gate.0] = left | right
          "XOR" => vals[gate.0] = left ^ right
          _ => panic()
        }
      }
    }
    vals
  }

  fn narrow(x, y) {
    let vals = calculate(x, y)
    let correct = x + y
    let possibles = []
    for name, offset in zs {
      if ((correct >> offset.to_int()) & 1) != vals[name].unwrap() {
        // possibles.append(deps[name].unwrap().to_array())
        possibles.push(name)
      }
    }
    possibles |> Set::from_array |> Set::to_array
  }

  let mut possibles = Set::of([])
  for x in 0..<1000 {
    possibles = possibles.union(narrow(x.to_int64(), 0) |> Set::from_array)
    if possibles.size() > 0 { println(x); break }
  }

  // println(narrow(1000000000000, 1000))

  let swaps = []

  swaps
    .flatten()
    ..sort()
    .map(fn(name) { name + "," })
    .fold(init="", fn(a, b) { a + b })
    .trim_end(",")
}

// test "day24_part2_test" {
//   let input = @fs.read_file_to_string!(path="data/day24.test")
//   assert_eq!(part2(input), 31)
// }

test "day24_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day24.input")
  inspect!(part2(input))
}

test "day24_part2_experiment" {
  let input = @fs.read_file_to_string!(path="data/day24.input")
  let [inits, gates] = input.split("\r\n\r\n").to_array()
  let inits = Map::from_iter(inits.split("\r\n").map(fn(line) {
    let [name, value] = line.split(": ").to_array()
    (name, parse(value))
  }))
  let gates = gates.split("\r\n").map(fn(line) {
    let [left, op, right, _, res] = line.split(" ").to_array()
    (res, op, left, right)
  }).collect()
    
  fn swap(sym1, sym2, gates: Array[(String, String, String, String)]) {
    gates.map(fn { (out, a, b, c) => {
      if out == sym1 { (sym2, a, b, c ) }
      else if out == sym2 { (sym1, a, b, c ) }
      else { (out, a, b, c )}
    }})
  }
  // #1
  let gates = swap("swt", "z07", gates)
  // #2
  let gates = swap("pqc", "z13", gates)
  // #3
  let gates = swap("bgs", "z31", gates)
  // #4
  let gates = swap("rjm", "wsv", gates)
  let zs = gates.map(fn { (res, _, _, _) => {
    if res.starts_with("z") { [(res, parse(res.trim("z")))] }
    else { [] }
  } }).flatten() |> Map::from_array

  let xs = inits.iter().map(fn { (k, _v) => {
    if k.starts_with("x") { [(k, parse(k.trim("x")))] }
    else { [] }
  }}).to_array().flatten() |> Map::from_array

  let ys = inits.iter().map(fn { (k, _v) => {
    if k.starts_with("y") { [(k, parse(k.trim("y")))] }
    else { [] }
  }}).to_array().flatten() |> Map::from_array

  let and0s = gates.map(fn { (sym, "AND", l, r) => {
    if (l.contains("x") && r.contains("y")) { [(parse(l.trim("x")), sym)] }
    else if (l.contains("y") && r.contains("x")) { [(parse(l.trim("y")), sym)] }
    else { [] }
  }; _ => [] }).flatten() |> Map::from_array

  let xor0s = gates.map(fn { (sym, "XOR", l, r) => {
    if (l.contains("x") && r.contains("y")) { [(parse(l.trim("x")), sym)] }
    else if (l.contains("y") && r.contains("x")) { [(parse(l.trim("y")), sym)] }
    else { [] }
  }; _ => [] }).flatten() |> Map::from_array

  let pre_carry = {}
  let carry = { 0: "brj" }
  for i in 1..<and0s.to_array().length() {
    guard let [item] = gates.filter(fn(x) {
      x.1 == "AND" && [x.2, x.3].contains(carry[i-1].unwrap())
    }) else { _ => { println("need last \{carry[i-1]}"); println(i); break }}
    guard [item.2, item.3].contains(xor0s[i.to_int64()].unwrap()) else {
      println("pre carry \{i} need last xor \{xor0s[i.to_int64()].unwrap()} but got \{item}");
    }
    pre_carry[i] = item.0
    guard let [item] = gates.filter(fn(x) {
      x.1 == "OR" && [x.2, x.3].contains(pre_carry[i].unwrap())
    }) else { _ => { println("need pre \{pre_carry[i]}"); println(i); break }}
    carry[i] = item.0
  }

  println(xor0s)
  // inspect!(part2(input))
}