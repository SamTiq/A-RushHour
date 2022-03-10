String setCharAt(String s, char c, int i) {
  return s.substring(0, i) + c + s.substring(i + 1);
}

class RushHourEnvNode extends PathfindingEnvNode {
  private String state;
  
  RushHourEnvNode(String state_) {
    state = state_;
  }
  
  public float getDistance(PathfindingEnvNode node) {
    return 1;
  }
  
  public float getHeuristic(PathfindingEnvNode end) {
    float h = 0.0;
    
    if (state.charAt(17) == '0') return 0.0;
    
    for (int i = 0; i < 6; i++) {
      if (state.charAt(17 - i) != '_') h += 1;
      if (state.charAt(17 - i) == '0') break;
    }
    
    return h;
  }
  
  public String getState() {
    return state;
  }
  
  @Override
  public boolean equals(Object o) {
    if (o == this) {
        return true;
    }
    
    if (!(o instanceof RushHourEnvNode)) {
        return false;
    }
     
    RushHourEnvNode node = (RushHourEnvNode) o;
    if (state.charAt(17) == '0' && node.getState().charAt(17) == '0') {
      return true;
    }
     
    return state.equals(node.getState());
  }
  
  @Override
  public int hashCode() {
      return state.hashCode();
  }
}



class RushHourEnv extends PathfindingEnv {
  private RushHourEnvNode current;
  private String[] levels = new String[]{
    "aa___eb__d_eb00d_eb__d__c___ffc_ggg_",
    "aac_ddbbc__ej00__ejkkk_ej__hffii_hgg",
    "abbc__a__c__a00c____dggg__d__f__eeef",
    "b__aaabcce__00de_i__d__i__fhhi__fggg",
    "aaed__b_ed__b00d__bccc___________fff",
    "a_bccca_bd__a00d__eeff_i_____igghh_i",
    "aa_bbb___dcce00d_je_giijffg__j__ghhh",
    "abb_l_adc_lkadc00keeeh_k__fhjjggfii_"
  };
  private int currentLevel = 0;
  
  RushHourEnv() {
    start = new RushHourEnvNode(levels[currentLevel]);
    current = ((RushHourEnvNode) start);
    end = new RushHourEnvNode("_________________0__________________");
  }
  
  
  
  public ArrayList<PathfindingEnvNode> getNeighbours(PathfindingEnvNode node) {
    ArrayList<PathfindingEnvNode> result = new ArrayList<PathfindingEnvNode>();
    
    String nodeState = ((RushHourEnvNode) node).getState();
    
    for (int i = 0; i < 6; i++) {
      int lastLeft = -1;
      int lastRight = -1;
      int lastTop = -1;
      int lastBot = -1;
      for (int j = 0; j < 6; j++) {
        if (nodeState.charAt(i*6 + j) == '_' && lastLeft == -1)  {
          lastLeft = j;
        } else if (nodeState.charAt(i*6 + j) != '_' && lastLeft != -1) {
          if (j + 1 <= 5 && nodeState.charAt(i*6 + j) == nodeState.charAt(i*6 + j + 1)) {
            for (int m = lastLeft; m < j; m++) {
              String newnodeState = nodeState;
              char id = nodeState.charAt(i*6 + j);
              int k = 0;
              while (j + k <= 5 && id == nodeState.charAt(i*6 + j + k)) {
                newnodeState = setCharAt(newnodeState, id, i*6 + m + k);
                newnodeState = setCharAt(newnodeState, '_', i*6 + j + k);
                k++;
              }
              
              result.add(new RushHourEnvNode(newnodeState));
            }
          }
          
          lastLeft = -1;
        }
        
        if (nodeState.charAt(i*6 + (5 - j)) == '_' && lastRight == -1)  {
          lastRight = (5 - j);
        } else if (nodeState.charAt(i*6 + (5 - j)) != '_' && lastRight != -1) {
          if (j + 1 <= 5 && nodeState.charAt(i*6 + (5 - j)) == nodeState.charAt(i*6 + (5 - j - 1))) {
            for (int m = lastRight ; m > (5 - j); m--) {
              String newnodeState = nodeState;
              char id = nodeState.charAt(i*6 + (5 - j));
              int k = 0;
              while (j + k <= 5 && id == nodeState.charAt(i*6 + (5 - j - k))) {
                newnodeState = setCharAt(newnodeState, id, i*6 + (m - k));
                newnodeState = setCharAt(newnodeState, '_', i*6 + (5 - j - k));
                k++;
              }
              
              result.add(new RushHourEnvNode(newnodeState));
            }
          }
          
          lastRight = -1;
        }
        
        if (nodeState.charAt(j*6 + i) == '_' && lastTop == -1)  {
          lastTop = j;
        } else if (nodeState.charAt(j*6 + i) != '_' && lastTop != -1) {
          if (j + 1 <= 5 && nodeState.charAt(j*6 + i) == nodeState.charAt((j + 1)*6 + i)) {
            for (int m = lastTop; m < j; m++) {
              String newnodeState = nodeState;
              char id = nodeState.charAt(j*6 + i);
              int k = 0;
              while (j + k <= 5 && id == nodeState.charAt((j + k)*6 + i)) {
                newnodeState = setCharAt(newnodeState, id, (m + k)*6 + i);
                newnodeState = setCharAt(newnodeState, '_', (j + k)*6 + i);
                k++;
              }
              
              result.add(new RushHourEnvNode(newnodeState));
            }
          }
          
          lastTop = -1;
        }
        
        if (nodeState.charAt((5 - j)*6 + i) == '_' && lastBot == -1)  {
          lastBot = (5 - j);
        } else if (nodeState.charAt((5 - j)*6 + i) != '_' && lastBot != -1) {
          if (j + 1 <= 5 && nodeState.charAt((5 - j)*6 + i) == nodeState.charAt((5 - j - 1)*6 + i)) {
            for (int m = lastBot ; m > (5 - j); m--) {
              String newnodeState = nodeState;
              char id = nodeState.charAt((5 - j)*6 + i);
              int k = 0;
              while (j + k <= 5 && id == nodeState.charAt((5 - j - k)*6 + i)) {
                newnodeState = setCharAt(newnodeState, id, (m - k)*6 + i);
                newnodeState = setCharAt(newnodeState, '_', (5 - j - k)*6 + i);
                k++;
              }
              
              result.add(new RushHourEnvNode(newnodeState));
            }
          }
          
          lastBot = -1;
        }
      }
    }
    
    return result;
  }
  
  public void setValidated(PathfindingEnvNode node) {
    current = ((RushHourEnvNode) node);
    
    delay(150);
    return;
  }
  
  
  
  
  
  ///////// CONTROLS /////////
  public void changeLevel(int delta) {
    currentLevel += delta;
    currentLevel = min(max(currentLevel, 0), 7);
    start = new RushHourEnvNode(levels[currentLevel]);
    current = ((RushHourEnvNode) start);
  }
  
  
  
  
  
  ///////// DISPLAY /////////
  public void display() {
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 6; j++) {
        stroke(66, 66, 66);
        fill(33, 33, 33);
        rect(j*width/6.0, i*width/6.0, width/6.0, width/6.0);
      }
    }
    
    for (int i = 0; i < 6; i++) {
      for (int j = 0; j < 6; j++) {
        if (current.getState().charAt(i*6 + j) != '_') {
          if (current.getState().charAt(i*6 + j) == '0') {
            fill(255, 0, 0);
          } else {
            randomSeed( ("azoeubivtgqsdkdjf" + current.getState().charAt(i*6 + j) + "disgyuqkfnchfe").hashCode() );
            
            colorMode(HSB, 360, 100, 100);
            fill(random(0, 360), random(50, 75), random(75, 100));
            colorMode(RGB, 255, 255, 255);
          }
          
          
          float x, y, w, h;
          x = j*width/6.0 + width/6.0/10.0;
          y = i*width/6.0 + width/6.0/10.0;
          w = width/6.0 - 2*width/6.0/10.0;
          h = width/6.0 - 2*width/6.0/10.0;
          if (j + 1 <= 5 && current.getState().charAt(i*6 + j) == current.getState().charAt(i*6 + j + 1))
            w += 2*width/6.0/10.0;
          if (i + 1 <= 5 && current.getState().charAt(i*6 + j) == current.getState().charAt((i + 1)*6 + j))
            h += 2*width/6.0/10.0;
          if (j - 1 >= 0 && current.getState().charAt(i*6 + j) == current.getState().charAt(i*6 + j - 1)) {
            x -= width/6.0/10.0;
            w += width/6.0/10.0;
          }
          if (i - 1 >= 0 && current.getState().charAt(i*6 + j) == current.getState().charAt((i - 1)*6 + j)) {
            y -= width/6.0/10.0;
            h += width/6.0/10.0;
          }
          
          noStroke();
          rect(x, y, w, h);
        }
      }
    }
  }
}
