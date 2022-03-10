class GridEnvNode extends PathfindingEnvNode {
  private int x, y;
  private float h;
  
  GridEnvNode(int x_, int y_) {
    x = x_;
    y = y_;
    h = random(0.0, 5000.0);
  }
  
  public float getDistance(PathfindingEnvNode node) {
    return abs(h - ((GridEnvNode) node).h) + 1;
  }
  
  public float getHeuristic(PathfindingEnvNode end) {
    return sqrt(sq(x - ((GridEnvNode) end).x) + sq(y - ((GridEnvNode) end).y));
  }
  
  public int getX() {
    return x;
  }
  
  public int getY() {
    return y;
  }
  
  public float getH() {
    return h;
  }
  
  public float setH(float h_) {
    return h = h_;
  }
}

class GridEnv extends PathfindingEnv {
  private final int gridSize;
  private GridEnvNode[][] grid;
  private int[][] state;  // 0 -> Not seen; 1 -> Seen; 2 -> Explored; 3 -> Validated
  
  GridEnv(int gridSize_) {
    gridSize = gridSize_;
    grid = new GridEnvNode[gridSize][gridSize];
    state = new int[gridSize][gridSize];
    
    resetGrid();
    resetState();
  }
  
  public void resetGrid() {
    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        if (grid[x][y] == null)
          grid[x][y] = new GridEnvNode(x, y);
        else
          grid[x][y].setH(0.0);
      }
    }
    resetState();
  }
  
  public void resetState() {
    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        state[x][y] = 0;
      }
    }
  }
  
  
  
  
  
  public ArrayList<PathfindingEnvNode> getNeighbours(PathfindingEnvNode node) {
    ArrayList<PathfindingEnvNode> result = new ArrayList<PathfindingEnvNode>();
    
    setExplored(node);
    if (((GridEnvNode) node).getX() + 1 < gridSize) {
      PathfindingEnvNode neighbor = grid[((GridEnvNode) node).getX() + 1][((GridEnvNode) node).getY()];
      result.add(neighbor);
      setSeen(neighbor);
    }
    if (((GridEnvNode) node).getY() + 1 < gridSize) {
      PathfindingEnvNode neighbor = grid[((GridEnvNode) node).getX()][((GridEnvNode) node).getY() + 1];
      result.add(neighbor);
      setSeen(neighbor);
    }
    if (((GridEnvNode) node).getX() - 1 >= 0) {
      PathfindingEnvNode neighbor = grid[((GridEnvNode) node).getX() - 1][((GridEnvNode) node).getY()];
      result.add(neighbor);
      setSeen(neighbor);
    }
    if (((GridEnvNode) node).getY() - 1 >= 0) {
      PathfindingEnvNode neighbor = grid[((GridEnvNode) node).getX()][((GridEnvNode) node).getY() - 1];
      result.add(neighbor);
      setSeen(neighbor);
    }
    
    return result;
  }
  
  private void setSeen(PathfindingEnvNode node) {
    if (state[((GridEnvNode) node).getX()][((GridEnvNode) node).getY()] < 1) {
      state[((GridEnvNode) node).getX()][((GridEnvNode) node).getY()] = 1;
      delay(1);
    }
  }
  
  private void setExplored(PathfindingEnvNode node) {
    if (state[((GridEnvNode) node).getX()][((GridEnvNode) node).getY()] < 2) {
      state[((GridEnvNode) node).getX()][((GridEnvNode) node).getY()] = 2;
      delay(1);
    }
  }
  
  public void setValidated(PathfindingEnvNode node) {
    if (state[((GridEnvNode) node).getX()][((GridEnvNode) node).getY()] < 3) {
      state[((GridEnvNode) node).getX()][((GridEnvNode) node).getY()] = 3;
      delay(10);
    }
  }
  
  
  
  
  
  
  
  ///////// DISPLAY /////////
  public void display() {
    stroke(66, 66, 66);
    for (int x = 0; x < gridSize; x++) {
      for (int y = 0; y < gridSize; y++) {
        GridEnvNode node = grid[x][y];
        fill(33 + 189*(node.h/10000));
        rect(node.getX()*width/gridSize, node.getY()*width/gridSize, width/gridSize, width/gridSize);
        
        switch (state[x][y]) {
          case 1:
            fill(0, 127, 255, 63);
            rect(node.getX()*width/gridSize, node.getY()*width/gridSize, width/gridSize, width/gridSize);
            break;
            
          case 2:
            fill(0, 255, 255, 63);
            rect(node.getX()*width/gridSize, node.getY()*width/gridSize, width/gridSize, width/gridSize);
            break;
            
          case 3:
            fill(0, 255, 255, 191);
            rect(node.getX()*width/gridSize, node.getY()*width/gridSize, width/gridSize, width/gridSize);
            break;
        }
      }
    }
    
    if (start != null) {
      fill(0, 255, 0);
      rect(((GridEnvNode) start).getX()*width/gridSize, ((GridEnvNode) start).getY()*width/gridSize, width/gridSize, width/gridSize);
    }
    
    if (end != null) {
      fill(255, 0, 0);
      rect(((GridEnvNode) end).getX()*width/gridSize, ((GridEnvNode) end).getY()*width/gridSize, width/gridSize, width/gridSize);
    }
  }
  
  
  
  ///////// CONTROLS /////////
  public void changeStartNode() {
    setStartNode(grid[mouseX/(width/gridSize)][mouseY/(width/gridSize)]);
    resetState();
  }
  
  public void changeEndNode() {
    setEndNode(grid[mouseX/(width/gridSize)][mouseY/(width/gridSize)]);
    resetState();
  }
  
  public void changeHeight(float delta) {
    GridEnvNode node = grid[mouseX/(width/gridSize)][mouseY/(width/gridSize)];
    node.h += delta;
    node.h = min(max(node.h, 0), 10000);
    
    if (node.getX() + 1 < gridSize) {
      GridEnvNode neighbor = grid[node.getX() + 1][node.getY()];
      neighbor.h += delta/2.0;
      neighbor.h = min(max(neighbor.h, 0), 10000);
    }
    if (node.getY() + 1 < gridSize) {
      GridEnvNode neighbor = grid[node.getX()][node.getY() + 1];
      neighbor.h += delta/2.0;
      neighbor.h = min(max(neighbor.h, 0), 10000);
    }
    if (node.getX() - 1 >= 0) {
      GridEnvNode neighbor = grid[node.getX() - 1][node.getY()];
      neighbor.h += delta/2.0;
      neighbor.h = min(max(neighbor.h, 0), 10000);
    }
    if (node.getY() - 1 >= 0) {
      GridEnvNode neighbor = grid[node.getX()][node.getY() - 1];
      neighbor.h += delta/2.0;
      neighbor.h = min(max(neighbor.h, 0), 10000);
    }
    
    resetState();
  }
}
