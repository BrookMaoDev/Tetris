let tetromino = [
  [ 0, 1, 0 ],
  [ 0, 1, 0 ],
  [ 0, 1, 1 ],
]
// let tetromino = [
//   [ 0, 0 ],
//   [ 0, 1],
// ]
// let tetromino = [
//   [ 0, 1, 0, 0 ],
//   [ 0, 1, 0, 0],
//   [ 0, 1, 0, 0],
//   [ 0, 1, 0, 0],
// ]
for (let i = 0; i < 4; i++) {
  PrintTetromino(tetromino)
  tetromino = RotateCW(tetromino)

  console.log("")  
}

/**
 * Rotates tetromino clockwise.
 * @param { number[][] } tetromino
 * @returns { number[][] }
 */
function RotateCW(tetromino) {
  const len = tetromino.length
  // empty 0 len x len matrix
  let rotatedTetromino = new Array(len).fill().map(i => new Array(len).fill(0)) 

  let r2 = 0 // increment row for every col inc 
  // but this means r2 = c

  let c2 = len-1
  for (let r = 0; r < len; r++) {
    for (let c = 0; c < len; c++) {
      rotatedTetromino[c][c2] = tetromino[r][c]
    }

    c2 --
  }

  return rotatedTetromino
}

/**
 * @param { number[][] } tetromino
 */
function PrintTetromino(tetromino) {
  for (let r of tetromino) {
    let printData = ``
    for (let c of r) {
      if (c == 0) {
        printData += `□`
      } else {
        printData += `■`
      }
    }

    console.log(printData)
  }
}