pub fn to_int_arr(line: String) -> Result[Array[Int], String] {
  let mut warning = false
  let arr = line
    .split(" ")
    .map(fn { ch => try @strconv.parse_int!(ch) catch { _ => { warning = true; 0 } } })
    .collect()
  if warning { Err("some int is not parseable") } else { Ok(arr) }
}

pub fn get_opt(s: String, offset: Int) -> Option[Char] {
  if offset >= s.length() { None }
  else { Some(s[offset]) }
}

