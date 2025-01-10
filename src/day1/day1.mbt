fn part1(input: String) -> Int {
  let pairs = input.split("\r\n").map(fn { line => line.split("   ").collect() })
  let list1 = pairs.map(fn { l => try @strconv.parse_int!(l[0]) catch { _ => 0 } }).collect()
  let list2 = pairs.map(fn { l => try @strconv.parse_int!(l[1]) catch { _ => 0 } }).collect()
  list1.sort()
  list2.sort()
  loop 0, list1[:], list2[:] {
    s, [], _ => break s
    prev, [hd1, .. as tl1], [hd2, .. as tl2] => continue prev + @int.abs(hd1 - hd2), tl1, tl2
    _, [_, ..], [] => 0
  }
}

test "day1_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day1.test")
  // println(1)
  // println(input)
  // println(1)
  // let a = #|3   4
  //   #|4   3
  //   #|2   5
  //   #|1   3
  //   #|3   9
  //   #|3   3
  // let mut i = 0
  // while (i < a.length()) {
  //   println("start")
  //   println(a[i])
  //   println(input[i])
  //   println("end")
  //   i = i + 1
  // }

  // println(@strconv.parse_int!("1\r"))
  assert_eq!(part1(input), 11)
}

test "day1_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day1.input")
  inspect!(part1(input), content="1765812")
}

fn part2(input: String) -> Int {
  let pairs = input.split("\r\n").map(fn { line => line.split("   ").collect() })
  let list1 = pairs.map(fn { l => try @strconv.parse_int!(l[0]) catch { _ => 0 } }).collect()
  let list2 = pairs.map(fn { l => try @strconv.parse_int!(l[1]) catch { _ => 0 } }).collect()
  list1.map(fn {
    item => list2.filter(fn { i => i == item }).length() * item
  }).fold(init=0, fn { acc, next => acc + next })
}

test "day1_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day1.test")
  assert_eq!(part2(input), 31)
}

test "day1_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day1.input")
  inspect!(part2(input), content="20520794")
}
