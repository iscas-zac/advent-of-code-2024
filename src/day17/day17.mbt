fn parse(s: String) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
fn parsec(s: Char) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
fn part1(input: String) -> String {
  let lines = input.split("\r\n")
  let regA = lines.find_first(fn(s) { s.contains("Register A") })
    .unwrap()
    .substring(start=12)
  let mut regA = parse(regA).to_int()
  let regB = lines.find_first(fn(s) { s.contains("Register B") })
    .unwrap()
    .substring(start=12)
  let mut regB = parse(regB).to_int()
  let regC = lines.find_first(fn(s) { s.contains("Register C") })
    .unwrap()
    .substring(start=12)
  let mut regC = parse(regC).to_int()
  let prog = lines.find_first(fn(s) { s.contains("Program") })
    .unwrap()
    .substring(start=9)
    .split(",")
    .map(fn(num) { parse(num).to_int() })
    .collect()
  let out = []
  let combo = fn {
    0..<4 as op => op
    4 => regA
    5 => regB
    6 => regC
    _ => panic()
  }
  loop prog[:] {
    [] => break
    [0, data, .. as res] => { regA = regA >> combo(data); continue res }
    [1, data, .. as res] => { regB = regB.lxor(data); continue res }
    [2, data, .. as res] => { regB = combo(data) % 8; continue res }
    [3, data, .. as res] => { if regA == 0 { continue res } else { continue prog[data:] } }
    [4, _, .. as res] => { regB = regB.lxor(regC); continue res }
    [5, data, .. as res] => { out.push(combo(data) % 8); continue res }
    [6, data, .. as res] => { regB = regA >> combo(data); continue res }
    [7, data, .. as res] => { regC = regA >> combo(data); continue res }
    _ => panic()
  }
  out.to_string().replace_all(old=", ", new=",").trim("[]")
}

test "day17_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day17.test")
  assert_eq!(part1(input), "4,6,3,5,6,3,5,2,1,0")
}

test "day17_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day17.input")
  inspect!(part1(input), content="4,3,7,1,5,3,0,5,4")
}

test "day17_part2_validate" {
  let mut regA: Int64 = 190384615275535
  let mut regB: Int64 = 0
  let mut regC: Int64 = 0
  let prog = [2,4,1,2,7,5,4,5,0,3,1,7,5,5,3,0]
  let out = []
  let combo = fn {
    0..<4 as op => op.to_int64()
    4 => regA
    5 => regB
    6 => regC
    _ => panic()
  }
  loop prog[:] {
    [] => break
    [0, data, .. as res] => { regA = regA >> combo(data).to_int(); continue res }
    [1, data, .. as res] => { regB = regB.lxor(data.to_int64()); continue res }
    [2, data, .. as res] => { regB = combo(data) % 8; continue res }
    [3, data, .. as res] => { if regA == 0 { continue res } else { continue prog[data:] } }
    [4, _, .. as res] => { regB = regB.lxor(regC); continue res }
    [5, data, .. as res] => { out.push(combo(data) % 8); continue res }
    [6, data, .. as res] => { regB = regA >> combo(data).to_int(); continue res }
    [7, data, .. as res] => { regC = regA >> combo(data).to_int(); continue res }
    _ => panic()
  }
  println(out.to_string().replace_all(old=", ", new=",").trim("[]"))
}

enum Info {
  Known(Int64)
  // Xor(Info, Info)
  // Neq(Info)
  Bits(Map[Int, Int])
  Unknown
} derive(Eq, Show)

struct State {
  regA: Ref[Info]
  regB: Ref[Info]
  regC: Ref[Info]
  out: Array[Int64]
} derive (Show)

fn part2(input: String) -> Int64 {
  let lines = input.split("\r\n")
  let regA = lines.find_first(fn(s) { s.contains("Register A") })
    .unwrap()
    .substring(start=12)
  let regA = parse(regA).to_int()
  let regB = lines.find_first(fn(s) { s.contains("Register B") })
    .unwrap()
    .substring(start=12)
  let regB = parse(regB).to_int()
  let regC = lines.find_first(fn(s) { s.contains("Register C") })
    .unwrap()
    .substring(start=12)
  let regC = parse(regC).to_int()
  let prog = lines.find_first(fn(s) { s.contains("Program") })
    .unwrap()
    .substring(start=9)
    .split(",")
    .map(fn(num) { parse(num).to_int() })
    .collect()
  let out = []
  let combo: (Int, State) -> Info = fn {
    0..<4 as op, _ => Known(op.to_int64())
    4, s => s.regA.val
    5, s => s.regB.val
    6, s => s.regC.val
    _, _ => panic()
  }
  let jump_sites = prog.iter2()
    .to_array()
    .filter(fn { (ind, 3) => ind % 2 == 0; _ => false })
    .map(fn { (ind, _) => (ind, prog[ind + 1]) })
  let out_sites = prog.iter2()
    .to_array()
    .filter(fn { (ind, 5) => ind % 2 == 0; _ => false })
    .map(fn { (ind, _) => ind })
  let len = prog.length()
  let paths = loop [([], 0)], [] {
    [], completed => break completed
    partials, completed => {
      if completed.length() > 10 { break completed } // conditional
      let nex = []
      loop partials[:] {
        [] => break
        [(p, l), .. as res] => {
          if l == len && p.filter(fn { (5, _) => true; _ => false }).length() == len { completed.push(p) }
          else if l < len && p.filter(fn { (5, _) => true; _ => false }).length() <= len {
            match (prog[l], prog[l+1]) {
              (3, loc) => {
                nex.push((p.copy()..push((3, loc)), loc))
                nex.push((p.copy()..push((3, loc)), l+2))
              }
              pair => nex.push((p..push(pair), l+2))
            }
          }
          continue res
        }
      }
      continue nex, completed
    }
  }
  
  fn make_state() { { regA: Ref::new(Unknown), regB: Ref::new(Unknown), regC: Ref::new(Unknown), out: [] } }
  fn unify(a: Ref[Info], b: Ref[Info]) -> Bool {
    match (a.val, b.val) {
      (Unknown, _) => { a.val = b.val; return true }
      (_, Unknown) => { b.val = a.val; return true }
      (Bits(left), Bits(right)) => {
        let c = Map::of([])

        for k in left.keys() {
          c[k] = left[k].unwrap()
        }
        for k in right.keys() {
          if c.contains(k) && c[k] != right[k] { return false }
          c[k] = right[k].unwrap()
        }
        
        a.val = Bits(c)
        b.val = Bits(c)
        true
      }
      (Known(k), Bits(m)) | (Bits(m), Known(k)) => {
        for offset in m.keys() {
          let v = m[offset].unwrap()
          if k.land((1).to_int64() << offset) != v.to_int64() << offset { return false }
        }
        a.val = Known(k)
        b.val = Known(k)
        true
      }
      (Known(aa), Known(bb)) => { aa == bb }
    }
  }
  fn to_bitmap(x: Int64) -> Set[Int] {
    loop x, 0, Set::of([]) {
      0, _, s => break s
      val, counter, s => {
        if val.land(1) == 1 { s.add(counter) }
        continue val >> 1, counter + 1, s
      }
    }
  }
  fn shift(prev: Ref[Info], nex: Ref[Info], n: Int) -> Bool {
    let bitset = Array::make(64, 0).mapi(fn(ind, _a) { ind })
    match (prev.val, nex.val) {
      (Known(a), Known(b)) => b == a >> n
      (Bits(a), Bits(b)) => {
        unify(prev, Ref::new(Bits(b.iter().map(fn(kvp) { (kvp.0 + n, kvp.1) }).filter(fn(kvp) { kvp.0 < 64 })|> Map::from_iter))) &&
        unify(nex, Ref::new(Bits(a.iter().map(fn(kvp) { (kvp.0 - n, kvp.1) }).concat(bitset.filter(fn(x) { x > 64 - n }).map(fn(x) { (x, 0) }).iter()).filter(fn(kvp) { kvp.0 >= 0 })|> Map::from_iter)))
      }
      (Known(a), _) => { nex.val = Known(a >> n); true }
      (_, Known(b)) => {
        let nbits = to_bitmap(b)
        unify(prev, Ref::new(Bits(bitset.map(fn(x) {
          if (nbits.contains(x)) { (x + n, 1) } else { (x + n, 0) }
        }).filter(fn(kvp) { kvp.0 < 64 })|> Map::from_array)))
      }
      (Bits(a), _) => { unify(nex, Ref::new(Bits(a.iter().map(fn(kvp) { (kvp.0 - n, kvp.1) }).filter(fn(kvp) { kvp.0 >= 0 })|> Map::from_iter))) }
      (_, Bits(b)) => { unify(prev, Ref::new(Bits(b.iter().map(fn(kvp) { (kvp.0 + n, kvp.1) }).concat(bitset.filter(fn(x) { x > 64 - n }).map(fn(x) { (x, 0) }).iter()).filter(fn(kvp) { kvp.0 < 64 })|> Map::from_iter))) }
      _ => true
    }
  }

  let possibles = []
  
  for path in paths {
    let states = [{ regA: Ref::new(Unknown), regB: Ref::new(Known(0)), regC: Ref::new(Known(0)), out: [] }]

    fn xor3(a: Ref[Info], b: Ref[Info], c: Ref[Info]) -> Bool {
      match (a.val, b.val, c.val) {
        (Known(a), _, Known(c)) => { unify(Ref::new(Known(a.lxor(c))), b) }
        (_, Known(b), Known(c)) => { unify(Ref::new(Known(b.lxor(c))), a) }
        (Known(a), Known(b), _) => { unify(Ref::new(Known(b.lxor(a))), c) }
        (Bits(left), Bits(right), Known(c)) | (Known(c), Bits(left), Bits(right)) |
          (Bits(left), Known(c), Bits(right)) => {
          let op = to_bitmap(c)
          for k, v in left {
            if right.contains(k) {
              if not(v.lxor(op.contains(k).to_int()) == right[k].unwrap()) { return false }
            } else { right[k] = v.lxor(op.contains(k).to_int()) }
          }
          for k, v in right {
            left[k] = v.lxor(op.contains(k).to_int())
          }
          true
        }
        (Bits(m), Unknown, Known(c)) | (Known(c), Unknown, Bits(m)) => {
          let op = to_bitmap(c)
          b.val = Bits(m.iter().map(fn { (k, v) => {
            (k, v.lxor(op.contains(k).to_int()))
          }}) |> Map::from_iter)
          true
        }
        (Unknown, Bits(m), Known(c)) | (Unknown, Known(c), Bits(m)) => {
          let op = to_bitmap(c)
          a.val = Bits(m.iter().map(fn { (k, v) => {
            (k, v.lxor(op.contains(k).to_int()))
          }}) |> Map::from_iter)
          true
        }
        (Bits(m), Known(i), Unknown) | (Known(i), Bits(m), Unknown) => {
          let op = to_bitmap(i)
          c.val = Bits(m.iter().map(fn { (k, v) => {
            (k, v.lxor(op.contains(k).to_int()))
          }}) |> Map::from_iter)
          true
        }
        // (Unknown, b) => prev.regB.val = Xor(b, Known(data))
        // (a, Unknown) => nex.regB.val = Xor(a, Known(data))
        other => { println(other); true }
      }
    }
    fn propagate(i: Int) {
      let prev = states[i]
      let nex = states[i+1]
      // let content = if @fs.path_exists(path="D:\\learning\\aoc\\2024\\test\\pre"+i.to_string()+".txt") {
      //   @fs.read_file_to_string?(path="D:\\learning\\aoc\\2024\\test\\pre"+i.to_string()+".txt").unwrap()
      // } else { "" }
      // @fs.write_string_to_file(path="D:\\learning\\aoc\\2024\\test\\pre"+i.to_string()+".txt", content=content+"\n"+prev.to_string())
      // let content = if @fs.path_exists(path="D:\\learning\\aoc\\2024\\test\\nex"+i.to_string()+".txt") {
      //   @fs.read_file_to_string?(path="D:\\learning\\aoc\\2024\\test\\nex"+i.to_string()+".txt").unwrap()
      // } else { "" }
      // @fs.write_string_to_file(path="D:\\learning\\aoc\\2024\\test\\nex"+i.to_string()+".txt", content=content+"\n"+nex.to_string())

      println(path[i])
      println(prev)
      // if states.length() > 5 { println(states[4]) }
      println(nex)
      match path[i] {
        (0, data) => {
          guard unify(prev.regB, nex.regB) else { panic() }
          guard unify(prev.regC, nex.regC) else { panic() }
          match (data, prev.regA.val) {
            (0..<4, _) => { guard shift(prev.regA, nex.regA, data) else { panic() }}
            (4, _) => { guard unify(nex.regA, Ref::new(Known(0))) else { panic() }}
            (5, _) => {
              match prev.regB.val {
                Known(i) => { guard shift(prev.regA, nex.regA, i.to_int()) else { panic() } }
                _ => {()}
              }
            }
            (6, _) => {
              match prev.regC.val {
                Known(i) => { guard shift(prev.regA, nex.regA, i.to_int()) else { panic() } }
                _ => {()}
              }
            }
            (_, Unknown) => {()}
            _ => panic()
          }
          guard unify(prev.regB, nex.regB) else { panic() }
          guard unify(prev.regC, nex.regC) else { panic() }
          nex.out.clear()
          nex.out.append(prev.out.copy())
        }
        (1, data) => {
          guard unify(prev.regA, nex.regA) else { panic() }
          guard unify(prev.regC, nex.regC) else { panic() }
          guard xor3(prev.regB, nex.regB, Ref::new(Known(data.to_int64())))
          else { panic() }
          
          // guard prev.out.length() == nex.out.length() else { panic() }
          // for j in 0..<prev.out.length() {
          //   guard unify(prev.out[j], nex.out[j]) else { panic() }
          // }
          guard unify(prev.regA, nex.regA) else { panic() }
          guard unify(prev.regC, nex.regC) else { panic() }
          nex.out.clear()
          nex.out.append(prev.out.copy())
        }
        (2, data) => {
          guard unify(prev.regA, nex.regA) else { panic() }
          guard unify(prev.regC, nex.regC) else { panic() }
          fn bst(reg: Ref[_]) {
            match (reg.val, nex.regB.val) {
              (Known(a), _) => { guard unify(nex.regB, Ref::new(Known(a.land(7))))}
              (_, Known(b)) => { guard unify(reg, Ref::new(Bits(Map::from_array([
                (0, b.land(1).to_int()),
                (1, b.land(2).to_int() / 2),
                (2, b.land(4).to_int() / 4),
              ])))) }
              (Bits(m1), Bits(m2)) => {
                for i in 3..<64 { m2[i] = 0 }
                guard unify(reg, Ref::new(Bits(m2.iter().filter(fn(p) { p.0 < 3 }) |> Map::from_iter)))
                guard unify(nex.regB, Ref::new(Bits(m1.iter().filter(fn(p) { p.0 < 3 }) |> Map::from_iter)))
              }
              (Bits(m1), Unknown) => {
                let new_m = m1.iter().filter(fn(p) { p.0 < 3 }) |> Map::from_iter
                for i in 3..<64 { new_m[i] = 0 }
                nex.regB.val = Bits(new_m)
              }
              (Unknown, Bits(m2)) => {
                for i in 3..<64 { m2[i] = 0 }
                reg.val = Bits(m2.iter().filter(fn(p) { p.0 < 3 }) |> Map::from_iter)
              }
              _ => ()
            }
          }
          match data {
            0..<4 => { guard unify(nex.regB, Ref::new(Known(data.to_int64()))) else { panic() }}
            4 => { bst(prev.regA) }
            5 => { bst(prev.regB) }
            6 => { bst(prev.regC) }
            _ => panic()
          }
          guard unify(prev.regA, nex.regA) else { panic() }
          guard unify(prev.regC, nex.regC) else { panic() }
          nex.out.clear()
          nex.out.append(prev.out.copy())
        }
        (3, data) => {
          if i+1 == path.length() || path[i+1] != (prog[2*data], prog[2*data+1]) {
            guard unify(prev.regA, Ref::new(Known(0))) else { panic() }
          } else {
            // match nex.regA.val { // Try to make a non-zero
            //   Bits(m) => {
            //     if m.values().all(fn(it) { it == 0 }) {
            //       for i in 0..<64 {
            //         if m[i].is_empty() { m[i] = 1; break }
            //       }
            //     }
            //   }
            //   _ => ()
            // }
          }
          guard unify(prev.regA, nex.regA) else { panic() }
          guard unify(prev.regB, nex.regB) else { panic() }
          guard unify(prev.regC, nex.regC) else { panic() }
          nex.out.clear()
          nex.out.append(prev.out.copy())
        }
        (4, _) => {
          guard unify(prev.regA, nex.regA)
          guard unify(prev.regC, nex.regC)
          guard xor3(prev.regB, prev.regC, nex.regB)
          guard unify(prev.regA, nex.regA)
          guard unify(prev.regC, nex.regC)
          nex.out.clear()
          nex.out.append(prev.out.copy())
        }
        (5, data) => {
          let l = prev.out.length()
          nex.out.clear()
          nex.out.append(prog[:l+1].iter().map(fn(x) { x.to_int64() }).to_array())
          let interest = prog[l]
          let bitmap = Ref::new(Bits(Map::from_array([
            (0, interest.land(1)),
            (1, interest.land(2)/2),
            (2, interest.land(4)/4)
          ])))
          match data {
            0..<4 => { guard data == interest else { panic() }}
            4 => { guard unify(prev.regA, bitmap) else { panic() } }
            5 => { guard unify(prev.regB, bitmap) else { panic() } }
            6 => { guard unify(prev.regC, bitmap) else { panic() } }
            _ => panic()
          }
          
          guard unify(prev.regA, nex.regA) else { panic() }
          guard unify(prev.regB, nex.regB) else { panic() }
          guard unify(prev.regC, nex.regC) else { panic() }
        }
        (6, data) => {
          guard unify(prev.regA, nex.regA) else { panic() }
          guard unify(prev.regC, nex.regC) else { panic() }
          match (data, prev.regA.val) {
            (0..<4, _) => { guard shift(prev.regA, nex.regB, data) else { panic() }}
            (4, _) => { guard unify(nex.regB, Ref::new(Known(0))) else { panic() }}
            (5, _) => {
              match prev.regB.val {
                Known(i) => { guard shift(prev.regA, nex.regB, i.to_int()) else { panic() } }
                _ => {()}
              }
            }
            (6, _) => {
              match prev.regC.val {
                Known(i) => { guard shift(prev.regA, nex.regB, i.to_int()) else { panic() } }
                _ => {()}
              }
            }
            (_, Unknown) => {()}
            _ => panic()
          }
          guard unify(prev.regC, nex.regC) else { panic() }
          guard unify(prev.regA, nex.regA) else { panic() }
          nex.out.clear()
          nex.out.append(prev.out.copy())
        }
        (7, data) => {
          guard unify(prev.regB, nex.regB) else { panic() }
          guard unify(prev.regA, nex.regA) else { panic() }
          match (data, prev.regA.val) {
            (0..<4, _) => { guard shift(prev.regA, nex.regC, data) else { panic() }}
            (4, _) => { guard unify(nex.regC, Ref::new(Known(0))) else { panic() }}
            (5, _) => {
              match prev.regB.val {
                Known(i) => { guard shift(prev.regA, nex.regC, i.to_int()) else { panic() }; }
                _ => { nex.regC.val = Unknown }
              }
            }
            (6, _) => {
              match prev.regC.val {
                Known(i) => { guard shift(prev.regA, nex.regC, i.to_int()) else { panic() } }
                _ => { nex.regC.val = Unknown }
              }
            }
            (_, Unknown) => {()}
            _ => panic()
          }
          guard unify(prev.regB, nex.regB) else { panic() }
          guard unify(prev.regA, nex.regA) else { panic() }
          nex.out.clear()
          nex.out.append(prev.out.copy())
        }
        _ => panic()
      }
      fn fill(reg: Ref[_]) {
        match reg.val {
          Bits(m) => {
            for i in 0..<64 {
              if not(m.contains(i)) { break }
            } else {
              reg.val = Known(m.iter().map(fn(kvp) { ((1).to_int64() << kvp.0) * kvp.1.to_int64() }).fold(init=0, fn(a, b) { a + b }))
            }
          }
          _ => ()
        }
      }
      fill(prev.regA)
      fill(prev.regB)
      fill(prev.regC)
      fill(nex.regA)
      fill(nex.regB)
      fill(nex.regC)
      println(prev)
      println(nex)
    }

    let plen = path.length()
    for i in 0..<plen {
      states.push(make_state())
      propagate(i)
    }

    for i in 0..<plen {
      propagate(plen - i - 1)
    }
    for i in 0..<plen {
      propagate(i)
    }
    for i in 0..<plen {
      propagate(plen - i - 1)
    }

    match states[0].regA.val {
      Known(a) => possibles.push(a)
      Bits(map) => possibles.push(map.iter().fold(init=0, fn(acc, kv) {
        acc + (kv.1).to_int64() * ((1).to_int64() << kv.0)
      }))
      _ => ()
    }
    println(states[0])
    for i in 0..<plen {
      println(path[i])
      println(states[i+1])
    }
  }
  let mut regA = possibles[0]
  let mut regB = regB.to_int64()
  let mut regC = regC.to_int64()
  let out = []
  let combo = fn {
    0..<4 as op => op.to_int64()
    4 => regA
    5 => regB
    6 => regC
    _ => panic()
  }
  loop prog[:] {
    [] => break
    [0, data, .. as res] => { regA = regA >> combo(data).to_int(); println((regA, regB, regC, (0, data))); continue res }
    [1, data, .. as res] => { regB = regB.lxor(data.to_int64()); println((regA, regB, regC, (1, data))); continue res }
    [2, data, .. as res] => { regB = combo(data) % 8; println((regA, regB, regC, (2, data))); continue res }
    [3, data, .. as res] => { if regA == 0 { println((regA, regB, regC, (3, data))); continue res } else { println((regA, regB, regC)); continue prog[data:] } }
    [4, _, .. as res] => { regB = regB.lxor(regC); println((regA, regB, regC, (4, 0))); continue res }
    [5, data, .. as res] => { out.push(combo(data) % 8); println((regA, regB, regC, (5, data))); continue res }
    [6, data, .. as res] => { regB = regA >> combo(data).to_int(); println((regA, regB, regC, (6, data))); continue res }
    [7, data, .. as res] => { regC = regA >> combo(data).to_int(); println((regA, regB, regC, (7, data))); continue res }
    _ => panic()
  }
  println(out.to_string().replace_all(old=", ", new=",").trim("[]"))
  possibles[0]
}

test "day17_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day17.test2")
  assert_eq!(part2(input), 117440)
}

test "day17_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day17.input")
  inspect!(part2(input), content="35184372088832")
}
