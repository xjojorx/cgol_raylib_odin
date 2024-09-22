package conway

import "core:fmt"
import rand "core:math/rand"
import rl "vendor:raylib"

width :: 500
height :: 500
cell_size :: 2
alive_chance :: .2

State :: enum {
  Alive = 1,
  Dead = 0
}

main :: proc() {
  fmt.println("hellope!")

  rl.InitWindow(1000, 1000, "game of life")
  // rl.SetTargetFPS(5)

  grid, grid2 := init_grid()


  showing1 := false
  for !rl.WindowShouldClose() {
    //apply rules
    if(showing1) {
      evolve(grid, grid2)
    } else {
      evolve(grid2, grid)
    }



    rl.BeginDrawing()
    rl.ClearBackground(rl.DARKGRAY)

    if(showing1){
      draw_grid(grid)
    }
    else{
      draw_grid(grid2)
    }


    rl.DrawFPS(10, 10)
    rl.EndDrawing()

    showing1 = !showing1
  }

  rl.CloseWindow()
}


init_grid :: proc() -> ([][]State, [][]State) {
  // grid := [dynamic][dynamic]i32{}

  // rand.reset(u64(123))
  g := make([][]State, height)
  g2 := make([][]State, height)
  for i in 0..<height {
    g[i] = make([]State, width)
    g2[i] = make([]State, width)
    for j in 0..<width {
      val := rand.float32()
      if(val < alive_chance)
      {
        g[i][j] = .Alive
        g2[i][j] = .Alive
      }
    }
  }

  return g,g2
}

draw_grid :: proc(grid: [][]State) {
  for i in 0..<len(grid) {
    for j in 0..<len(grid[i]) {
      color := rl.DARKGRAY

      if(grid[i][j] == .Alive) {
        color = rl.WHITE
      }
      if(grid[i][j] == .Dead) {
        color = rl.BLACK
      }

      rl.DrawRectangle(i32(i*cell_size), i32(j*cell_size), cell_size, cell_size, color)
    }
  }

}

evolve:: proc(from, to : [][]State) {
  for i in 0..<len(from) {
    for j in 0..<len(from[i]) {
      n := count_neighbors(from, i, j)
      state := from[i][j]

      to[i][j] = state

      if state == .Dead {
        if n == 3 {
          to[i][j] = .Alive
        // } else  {
        //   c := rand.float32()
        //   if(c < alive_chance/2.0) {
        //     to[i][j] = .Alive
        //   }
        }
      }
      else if state == .Alive {
        if n < 2{
          to[i][j] = .Dead
        } else if n > 3 {
          to[i][j] = .Dead
        }  
      }


    }
  }
}

count_neighbors :: proc(from: [][]State, row, col: int) -> int {
  n := 0

  for i in row-1..=row+1 {
    if(i >= 0 && i < len(from))
    {
      for j in col-1..=col+1 {
        if (j>=0 && j< len(from[i])) {
          if !(i == row && j== col){
            if(from[i][j] == .Alive){
              n += 1
            }
          }
        }
      }
    }
  }


  return n
}
