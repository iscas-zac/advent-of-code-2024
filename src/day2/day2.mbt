fn part1(input: String) -> Int {
  let lines = input.split("\r\n")
  let mut warning = false
  let num_arrs = lines
    .map(fn { line => line
      .split(" ")
      .map(fn { ch => try @strconv.parse_int!(ch) catch { _ => { warning = true; 0 } } })
      .collect() })
  if warning { panic() }
  fn is_safe(nums: Array[Int]) -> Bool {
    let len = nums.length()
    if nums[1:].length() != nums[:len-1].length() { println("not same"); panic() }
    (loop nums[1:], nums[:len-1] {
      [], _ => break true
      _, [] => break true
      [nex, .. as tl1], [prev, .. as tl2] => {
        if nex - prev < 4 && nex - prev > 0 {
          continue tl1, tl2
        } else { break false }
      }
    }) || (loop nums[1:], nums[:len-1] {
      [], _ => break true
      _, [] => break true
      [nex, .. as tl1], [prev, .. as tl2] => {
        if nex - prev > -4 && nex - prev < 0 {
          continue tl1, tl2
        } else { break false }
      }
    })
  }
  // println(num_arrs.map(fn { it => is_safe(it) }))
  num_arrs.filter(fn { it => is_safe(it) }).collect().length()
}

test "day2_part1_test" {
  let input = @fs.read_file_to_string!(path="data/day2.test")
  assert_eq!(part1(input), 2)
}

test "day2_part1_examine" {
  let input = @fs.read_file_to_string!(path="data/day2.input")
  inspect!(part1(input), content="390")
}

fn part2(input: String) -> Int {
    let lines = input.split("\r\n")
  let mut warning = false
  let num_arrs = lines
    .map(fn { line => line
      .split(" ")
      .map(fn { ch => try @strconv.parse_int!(ch) catch { _ => { warning = true; 0 } } })
      .collect() })
  if warning { panic() }
  fn is_safe(nums: Array[Int]) -> Bool {
    fn check_range(lo: Int, hi: Int) -> Bool {
      fn check_slice(nums: Array[Int]) -> Option[Int] {
        let len = nums.length()
        for i = 0; i < len - 1; i = i + 1 {
          let dif = nums[i] - nums[i + 1]
          if dif >= hi || dif <= lo {
            break Some(i)
          }
        } else { None }
      }
      guard let Some(i) = check_slice(nums) else { _ => return true }
      fn judge_drop_at(index: Int) -> Bool {
        let (left, right) = nums.split_at(index)
        let (_, right) = right.split_at(1)
        let cont = {
          guard let Some(tail) = left.last() else { _ => true }
          guard let Some(head) = right.get(0) else { _ => true }
          (tail - head < hi) && (tail - head > lo)
        }
        check_slice(left).is_empty() && check_slice(right).is_empty() && cont
      }
      judge_drop_at(i) || judge_drop_at(i + 1)
    }
    check_range(-4, 0) || check_range(0, 4)
  }
  num_arrs.filter(fn { it => is_safe(it) }).collect().length()
}

test "day2_part2_test" {
  let input = @fs.read_file_to_string!(path="data/day2.test")
  assert_eq!(part2(input), 4)
}

test "day2_part2_examine" {
  let input = @fs.read_file_to_string!(path="data/day2.input")
  inspect!(part2(input), content="439")
}
