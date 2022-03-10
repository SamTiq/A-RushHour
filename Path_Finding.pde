PathfindingEnv env;
AStar astar;

void setup() {
  size(800, 800);
    
  env = new GridEnv(50);
}

void draw() {
  env.display();
}

void pathfind() {
  astar = new AStar(env);
}

void keyPressed() {
  switch (key) {
    case '1':
      if (env instanceof GridEnv)
        ((GridEnv) env).changeStartNode();
      if (env instanceof RushHourEnv)
        ((RushHourEnv) env).changeLevel(-1);
      break;
    case '2':
      if (env instanceof GridEnv)
        ((GridEnv) env).changeEndNode();
      if (env instanceof RushHourEnv)
        ((RushHourEnv) env).changeLevel(1);
      break;
    case '3':
      if (env instanceof GridEnv)
        ((GridEnv) env).changeHeight(-1000);
      break;
    case '4':
      if (env instanceof GridEnv)
        ((GridEnv) env).changeHeight(+1000);
      break;
    case '5':
      if (env instanceof GridEnv)
        ((GridEnv) env).resetGrid();
      break;
    case '6':
      if (env instanceof RushHourEnv)
        env = new GridEnv(50);
      else if (env instanceof GridEnv)
        env = new RushHourEnv();
      break;
    case ' ':
      if (env instanceof GridEnv)
        ((GridEnv) env).resetState();
      thread("pathfind");
      break;
  }
}
