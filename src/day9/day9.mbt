fn part1(input: String) -> BigInt {
  let input = input.to_array().map(fn { len => @strconv.parse_int?(len.to_string()).unwrap() })
  let starts: Array[BigInt] = input.fold(init=[0], fn { acc, len => acc..push(acc.last().unwrap() + BigInt::from_int(len)) })
  let occupied: BigInt = input.mapi(fn { ind, len => if ind % 2 == 0 { len } else { 0 } }).fold(init=0, fn { a, b => a + BigInt::from_int(b) })
  let mut block_cur = 0
  let mut countdown = input.length() / 2
  let mut trail = BigInt::from_int(input[input.length() - 1])
  let mut res: BigInt = 0
  while (starts[block_cur + 1] < occupied) {
    if block_cur % 2 == 0 {
      res += BigInt::from_int(block_cur) / 2 * (starts[block_cur] + starts[block_cur + 1] - 1) * (starts[block_cur + 1] - starts[block_cur]) / 2
    } else {
      let mut spare = BigInt::from_int(input[block_cur])
      let mut cur = starts[block_cur]
      while (spare > 0) {
        if spare > trail {
          res += BigInt::from_int(countdown) * (cur * 2 + trail - 1) * trail / 2
          countdown -= 1
          spare -= trail
          cur += trail
          trail = BigInt::from_int(input[countdown * 2])
        } else {
          res += BigInt::from_int(countdown) * (cur * 2 + spare - 1) * spare / 2
          trail = trail - spare
          spare = 0
        }
        
      }
    }
    println(block_cur)
    println(countdown)
    println(res)
    println("")

    block_cur += 1
  }
  res += BigInt::from_int(block_cur) / 2 * (starts[block_cur] + occupied - 1) * (occupied - starts[block_cur]) / 2
  res
}

test "day9_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day9.test")
  assert_eq!(part1(input), 1928)
}

test "day9_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day9.input")
  println(input.length())
  inspect!(part1(input), content="6154342737974")
}

fn part2(input: String) -> BigInt {
  let input = input.to_array().map(fn { len => @strconv.parse_int?(len.to_string()).unwrap() })
  let starts: Array[BigInt] = input.fold(init=[0], fn { acc, len => acc..push(acc.last().unwrap() + BigInt::from_int(len)) })
  let nums = input.iter2().to_array().map_option(fn { (ind, len) => if ind % 2 == 0 { Some((starts[ind], len)) } else { None } })
  let intervals = Map::from_array(nums.iter2().to_array())
  fn get_spare(filled: Map[Int, (BigInt, Int)], needed: Int) -> Option[BigInt] {
    let occupied = filled.values().to_array()..sort_by(fn { i1, i2 => i1.0.compare(i2.0) })
    for cur in 0..<occupied.length() - 1 {
      let start = occupied[cur].0 + BigInt::from_int(occupied[cur].1)
      let end = occupied[cur + 1].0
      if end - start >= BigInt::from_int(needed) { return Some(start) }
    }
    None
  }
  let located = loop intervals, nums.length() - 1 {
    ls, processing => {
      if processing == 0 { break ls }
      let (start, len) = intervals[processing].unwrap()
      guard let Some(moved) = get_spare(ls, len) else { _ => continue ls, processing - 1 }
      if moved > start { continue ls, processing - 1 }
      let new_map = ls..set(processing, (moved, len))
      continue new_map, processing - 1
    }
  }
  // println(located)
  located.to_array()
    .map(fn { (label, (start, len)) => BigInt::from_int(label) * (start * 2 + BigInt::from_int(len) - 1) * BigInt::from_int(len) / 2 })
    .fold(init=0, fn { a, b => a + b })
}

test "day9_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day9.test")
  assert_eq!(part2(input), 2858)
}

test "day9_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day9.input")
  inspect!(part2(input), content="6183632723350")
}
