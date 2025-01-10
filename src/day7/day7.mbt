fn powerset(n: Int) -> Array[Array[Bool]] {
  if n == 0 { return [[]] }
  powerset(n - 1)
    .map(fn { arr => [arr.copy()..push(true), arr.copy()..push(false)] })
    .flatten()
}

fn part1(input: String) -> BigInt {
  input.split("\r\n")
    .map(fn { l => {
        let [target, items] = l.split(": ").collect()
        let target = BigInt::from_string(target)
        let items = items.split(" ").map(fn { i => BigInt::from_string(i) }).collect()
        let sign_combs = powerset(items.length() - 1)
        // print(sign_combs)
        // print(items)
        for signs in sign_combs {
          if target == (loop items[0], signs[:], items[1:] {
            res, [], _ => break res
            res, [sign, .. as rest], [next, .. as others] => continue if sign { res + next } else { res * next }, rest, others
          }) { break target }
        } else { 0 }
      } })
    .fold(init=0, fn(a: BigInt, b: BigInt) { a + b })
}

test "day7_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day7.test")
  assert_eq!(part1(input), 3749)
}

test "day7_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day7.input")
  inspect!(part1(input), content="7579994664753")
}

fn part2(input: String) -> BigInt {
  fn powerset(n: Int) -> Array[Array[Int]] {
    if n == 0 { return [[]] }
    powerset(n - 1)
      .map(fn { arr => [arr.copy()..push(0), arr.copy()..push(1), arr.copy()..push(2)] })
      .flatten()
  }

  input.split("\r\n")
    .map(fn { l => {
        let [target, items] = l.split(": ").collect()
        let target = BigInt::from_string(target)
        let items = items.split(" ").map(fn { i => BigInt::from_string(i) }).collect()
        let sign_combs = powerset(items.length() - 1)
        // print(sign_combs)
        // print(items)
        for signs in sign_combs {
          if target == (loop items[0], signs[:], items[1:] {
            res, [], _ => break res
            res, [sign, .. as rest], [next, .. as others] => continue if sign == 0 { res + next }
              else if sign == 1 { res * next }
              else { BigInt::from_string(res.to_string() + next.to_string())}, rest, others
          }) { break target }
        } else { 0 }
      } })
    .fold(init=0, fn(a: BigInt, b: BigInt) { a + b })
}

test "day7_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day7.test")
  assert_eq!(part2(input), 11387)
}

test "day7_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day7.input")
  inspect!(part2(input), content="438027111276610")
}
