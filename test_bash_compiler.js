const data = [
  [2, 2, 1, 8],
  [2, 6, 4, 1],
  [2, 10, 4, 1],
  [6, 7, 1, 3],

  [9, 3, 1, 8],
  [13, 3, 1, 8],
  [10, 2, 3, 1],
  [10, 6, 3, 1],

  [17, 2, 4, 1],
  [16, 3, 1, 3],
  [17, 6, 3, 1],
  [20, 7, 1, 3],
  [16, 10, 4, 1],

  [23, 2, 1, 9],
  [27, 2, 1, 9],
  [24, 6, 3, 1],

  [2, 13, 26, 2],
  [8, 15, 14, 3],

]

let result = ""
let strokeCount = 1
/*
stroke6: # top -
    li $a0, 9
    li $a1, 2
    li $a2, 3
    li $a3, 1
    la $v0, stroke7
    j fill_rect
*/

for (const d of data) {
  result += `stroke${strokeCount}:\n`
  
  for (let i = 0; i < 4; i++) {
    result += `    li $a${i}, ${d[i]}\n`
  }
  result += `    la $v0, stroke${strokeCount + 1}\n`
  result += `    j fill_rect\n`
  result += "\n"

  strokeCount ++ 
}
result += `stroke${strokeCount}:\n`

console.log(result)