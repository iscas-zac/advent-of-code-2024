fn part1(input: String) -> Int64 {
  let lines = input.split(" ").map(fn { s => @strconv.parse_int64?(s).unwrap() }).to_array()
  (loop lines, 0 {
    lines, 25 => break lines
    lines, num => continue lines.iter().flat_map(fn {
      0 => [(1).to_int64()].iter()
      num => {
        let digits = num.to_string()
        if digits.length() % 2 == 0 {
          [
            @strconv.parse_int64?(digits.substring(end=digits.length() / 2)).unwrap(),
            @strconv.parse_int64?(digits.substring(start=digits.length() / 2)).unwrap(),
          ].iter()
        } else { [ num * 2024 ].iter() }
      }
    }).to_array(), num + 1
  }).length().to_int64()
}

test "day11_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day11.test")
  assert_eq!(part1(input), 55312)
}

test "day11_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day11.input")
  inspect!(part1(input), content="220999")
}

fn transform1(start: Int64) -> Array[Int64] {
  match start {
  0 => [(1).to_int64()]
    num => {
      let digits = num.to_string()
      if digits.length() % 2 == 0 {
        [
          @strconv.parse_int64?(digits.substring(end=digits.length() / 2)).unwrap(),
          @strconv.parse_int64?(digits.substring(start=digits.length() / 2)).unwrap(),
        ]
      } else { [ num * 2024 ] }
    }
  }
}

// [0] --0-> [0], length = 1
let cache: Map[(Int64, Int), Int64] = Map::from_array([(((0).to_int64(), 0), 1)])
// fn transform(start: Array[Int64], blink: Int) -> Array[Int64] {
//   loop start, blink {
//     res, 0 => break res
//     seed, 1 => break seed.map(transform1).flatten()
//     seed, n => continue seed.map(transform1).flatten(), n - 1
//   }
// }

fn getlen(start: Array[Int64], blink: Int) -> Int64 {
  start.map(fn { n => {
    println(n.to_string() + " " + blink.to_string())
    if blink == 0 {
      cache[(n, blink)] = 1
      return (1).to_int64()
    }
    guard let Some(res) = cache[(n, blink)] else { _ => {
      // if n == 1 && blink > 3 {
      //   let num = getlen([2], blink - 3) * 2 + getlen([0], blink - 3) + getlen([4], blink - 3)
      //   cache[(n, blink)] = num
      //   return num
      // }
      // if n == 2 && blink > 3 {
      //   let num = getlen([4], blink - 3) * 2 + getlen([0], blink - 3) + getlen([8], blink - 3)
      //   cache[(n, blink)] = num
      //   return num
      // }
      // if n == 3 && blink > 3 {
      //   let num = getlen([6], blink - 3) + getlen([0], blink - 3) + getlen([7], blink - 3) + getlen([2], blink - 3)
      //   cache[(n, blink)] = num
      //   return num
      // }
      // if n == 4 && blink > 3 {
      //   let num = getlen([8], blink - 3) + getlen([0], blink - 3) + getlen([9], blink - 3) + getlen([6], blink - 3)
      //   cache[(n, blink)] = num
      //   return num
      // }
      // if n == 5 && blink > 5 {
      //   let num = getlen([2, 0, 4, 8, 2, 8, 8, 0], blink - 5)
      //   cache[(n, blink)] = num
      //   return num
      // }
      // if n == 6 && blink > 5 {
      //   let num = getlen([2, 4, 5, 7, 9, 4, 5, 6], blink - 5)
      //   cache[(n, blink)] = num
      //   return num
      // }
      // if n == 7 && blink > 5 {
      //   let num = getlen([2, 8, 6, 7, 6, 0, 3, 2], blink - 5)
      //   cache[(n, blink)] = num
      //   return num
      // }
      // if n == 8 && blink > 5 {
      //   let num = getlen([3, 2, 7, 7, 2, 6], blink - 5) + getlen([8], blink - 4)
      //   cache[(n, blink)] = num
      //   return num
      // }
      // if n == 9 && blink > 5 {
      //   let num = getlen([3, 6, 8, 6, 9, 1, 8, 4], blink - 5)
      //   cache[(n, blink)] = num
      //   return num
      // }
      let num = getlen(transform1(n), blink - 1);
      cache[(n, blink)] = num
      num
    } }
    
    res

  } }).fold(init=0, fn { a, b => a + b })
}

fn part2(input: String) -> Int64 {
  let lines = input.split(" ").map(fn { s => @strconv.parse_int64?(s).unwrap() }).to_array()
  getlen(lines, 75)
}

test "day11_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day11.test")
  assert_eq!(part2(input), 55312)
}

test "day11_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day11.input")
  inspect!(part2(input), content="261936432123724")
}
