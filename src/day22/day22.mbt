fn parse(s: String) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }
// fn parsec(s: Char) -> Int64 { @strconv.parse_int64?(s.to_string()).unwrap() }

fn mix(a: Int64, b: Int64) -> Int64 {
  a.lxor(b)
}
fn prune(a: Int64) -> Int64 {
  a % 16777216
}
fn generate(seed: Int64) -> Int64 {
  let ans = (seed * 64) |> mix(seed) |> prune
  let ans = (ans / 32) |> mix(ans) |> prune
  let ans = (ans * 2048) |> mix(ans) |> prune
  ans
}

test "validate generate" {
  let num: Int64 = 123
  let num = generate(num)
  assert_eq!(num, 15887950)
  let num = generate(num)
  assert_eq!(num, 16495136)
  let num = generate(num)
  assert_eq!(num, 527345)
  let num = generate(num)
  assert_eq!(num, 704524)
  let num = generate(num)
  assert_eq!(num, 1553684)
  let num = generate(num)
  assert_eq!(num, 12683156)
  let num = generate(num)
  assert_eq!(num, 11100544)
  let num = generate(num)
  assert_eq!(num, 12249484)
  let num = generate(num)
  assert_eq!(num, 7753432)
  let num = generate(num)
  assert_eq!(num, 5908254)
}

fn part1(input: String) -> Int64 {
  let lines = input.split("\r\n").map(parse).collect()
  lines.map(fn(init) {
    let mut num = init
    for _ in 0..<2000 {
      num = generate(num)
    }
    num
  }).fold(init=0, fn(a, b) { a + b })
}

test "day22_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day22.test")
  assert_eq!(part1(input), 37327623)
}

test "day22_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day22.input")
  inspect!(part1(input), content="20071921341")
}

fn get_diff_map(init: Int64, round: Int) -> Map[(Int64, Int64, Int64, Int64), Int64] {
  let mut num = init
  let seq = [num % 10]
  for _ in 0..<round {
    num = generate(num)
    seq.push(num % 10)
  }
  let rec = loop 0, [], {} { num, diff, rec => {
      diff.push(seq[num+1] - seq[num])
        if num - 2 > 0 {
          let key = (diff[num-3],
            diff[num-2],
            diff[num-1],
            diff[num])
          if rec[key] == None { rec[key] = seq[num+1] }
        }
      if num == seq.length() - 2 { break rec }
      else { continue num+1, diff, rec }
    }
  }
  rec
}

fn part2(input: String) -> Int64 {
  let lines = input.split("\r\n").map(parse).collect()
  let highest_with_diffs = lines.map(fn(x) { get_diff_map(x, 2000) })

  let mut max: Int64 = 0
  let mut max_key = None
  let keys = []
  for a in -10..=10 {
    for b in -10..=10 {
      for c in -10..=10 {
        for d in -10..=10 {
          keys.push((a.to_int64(), b.to_int64(), c.to_int64(), d.to_int64()))
        }
      }
    }
  }
  let ans: Map[_, Int64] = {}
  for key in keys {
    ans[key] = highest_with_diffs.fold(init=0, fn(acc, rec) {
      rec[key].or_default() + acc
    })
  }
  for key in keys {
    let val = ans[key].unwrap()
    if val > max { max = val; max_key = Some(key) }
  }
  println(max_key)
  println(highest_with_diffs.map(fn(rec) {
    rec[max_key.unwrap()].or_default()
  }))
  max
}

test "test_diffmap" {
  let map = get_diff_map(123, 10)
  println(map)
  assert_eq!(map[(-1, -1, 0, 2)], Some(6))
}

test "day22_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day22.test2")
  assert_eq!(part2(input), 23)
}

test "day22_part2_test_long" {
  let input = @fs.read_file_to_string!(path="data/day22.test2")
  let rep = (input + "\r\n").repeat(700)
  assert_eq!(part2(rep + input), (23 * 701).to_int64())
}

test "day22_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day22.input")
  inspect!(part2(input), content="2242")
}
