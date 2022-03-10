abstract class PathfindingEnvNode {
  abstract public float getDistance(PathfindingEnvNode node);
  abstract public float getHeuristic(PathfindingEnvNode end);
}

abstract class PathfindingEnv {
  protected PathfindingEnvNode start;
  protected PathfindingEnvNode end;
  
  
  abstract public ArrayList<PathfindingEnvNode> getNeighbours(PathfindingEnvNode node);
  abstract public void setValidated(PathfindingEnvNode node);
  abstract public void display();
  
  
  public void setStartNode(PathfindingEnvNode start_) {
    start = start_;
  }
  
  public void setEndNode(PathfindingEnvNode end_) {
    end = end_;
  }
  
  public PathfindingEnvNode getStartNode() {
    return start;
  }
  
  public PathfindingEnvNode getEndNode() {
    return end;
  }
}
