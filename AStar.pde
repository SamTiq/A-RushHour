///////// TODO PART /////////
import java.util.ArrayList;
import java.util.PriorityQueue;

class AStar  {
  private PathfindingEnv env;
  
  AStar(PathfindingEnv env_) {
    env = env_;
    solve();
  }
  
  private void solve() {
    ArrayList<PathfindingEnvNode> closed = new ArrayList<PathfindingEnvNode>();
    Wrapper top;
    Wrapper start;

    if (env.getStartNode() != null && env.getEndNode() != null) {
        // on créé notre queue
        PriorityQueue<Wrapper> queue = new PriorityQueue<>();

        // on créé notre wrapper de départ et on l'ajoute à la queue
        start = new Wrapper(env.getStartNode(), null, 0.0, 0.0);
        queue.add(start);

        // on créé notre wrapper d'arrivé
        Wrapper end = new Wrapper(env.getEndNode(), null, 99999.0, 0.0);

        // on créé notre wrapper de départ
        top = queue.poll();

        while (!top.node.equals(end.node)) {
          println(queue.size());
          // on ajoute les voisin à la queue
          if (!closed.contains(top.node)) {
            ArrayList<PathfindingEnvNode> neighbours = this.env.getNeighbours(top.node);
            for (PathfindingEnvNode element : neighbours) {
              // calcul de la distance
              float distance = top.distance + element.getDistance(top.node);
              // calcul de l'heuristique
              float heuristic = element.getHeuristic(end.node);
              Wrapper neighbour = new Wrapper(element, top, distance, heuristic);
              queue.add(neighbour);
            }

            // on ajoute notre point courant au tableau des points explorés
            closed.add(top.node);

          }


          // on choisis un nouveau point courant
          top = queue.poll();
        }

        ArrayList<PathfindingEnvNode> path = new ArrayList<PathfindingEnvNode>();

        // on ajoute de manière récusive les parents du noeud courant
        while(!top.node.equals(start.node)) {
          path.add(top.node);
          top = top.parent;
        }

        for(int i=path.size()-1; i >= 0; i--) {
          env.setValidated(path.get(i));
        }
      }
  }
}

public class Wrapper implements Comparable<Wrapper> {
  public PathfindingEnvNode node;
  public Wrapper parent;
  public float distance;
  public float heuristic;

  Wrapper(PathfindingEnvNode node, Wrapper parent, float distance, float heuristic) {
    this.node = node;
    this.parent = parent;
    this.distance = distance;
    this.heuristic = heuristic;
  }

  @Override
  public int compareTo(Wrapper other) {
      if (other == null) return -1;

      float a = this.distance + this.heuristic; 
      float b = other.distance + other.heuristic;

      if (a > b) return 1;
      else if (a < b) return -1;
      return 0;
  }
}