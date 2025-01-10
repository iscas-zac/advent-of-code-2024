pub(all) type Board[T] Array[Array[T]]

pub fn Board::height[T](self: Board[T]) -> Int {
  self._.length()
}

pub fn Board::width[T](self: Board[T]) -> Int {
  self._[0].length()
}

pub fn Board::out_of_bound[T](self: Board[T], tup: (Int, Int)) -> Bool {
  let (x, y) = tup
  x < 0 || x >= self.width() || y < 0 || y >= self.height()
}

pub fn Board::get2[T](self: Board[T], tup: (Int, Int)) -> Option[T] {
  let (x, y) = tup
  if not(self.out_of_bound((x, y))) { Some(self._[y][x]) }
  else { None }
}

pub fn Board::set2[T](self: Board[T], tup: (Int, Int), v: T) -> Bool {
  let (x, y) = tup
  if not(self.out_of_bound((x, y))) { self._[y][x] = v; true }
  else { false }
}

pub fn Board::add(tup1: (Int, Int), tup2: (Int, Int)) -> (Int, Int) {
  (tup1.0 + tup2.0, tup1.1 + tup2.1)
}

pub fn Board::each[T, R](self: Board[T], init: R, action: ((T, R) -> R)) -> R {
  let mut acc = init
  for i in 0..<self.width() {
    for j in 0..<self.height() {
      acc = action(self._[j][i], acc)
    }
  }
  acc
}

pub fn Board::eachi[T, R](self: Board[T], init: R, action: ((T, R, (Int, Int)) -> R)) -> R {
  let mut acc = init
  for i in 0..<self.width() {
    for j in 0..<self.height() {
      acc = action(self._[j][i], acc, (i, j))
    }
  }
  acc
}

test "use board" {
  let board: Board[Int] = [[1, 2], [3, 4]]
  assert_eq!(board.get2((1, 1)), Some(4))
  assert_eq!(board.get2((2, 2)), None)
  assert_eq!(board.set2((1, 1), 5), true)
  assert_eq!(board.each(0, fn { a, b => a + b }), 11)
}