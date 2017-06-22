boolean portsReady = false; // don't send anything unless the ports are ready

static Serial serialPorts[]; 


/**
 * This function inits the serial ports, and returns true iff it found all five walls
 */
boolean initWallControllers() {
  String portNames[] = Serial.list();
  //  printArray(Serial.list());

  serialPorts = new Serial[5];
  
  final int NUM_WALLS = 5;
  int wallsFound = 0;
  final int TIMEOUT_MS = 4000;
  final int MAX_TRY = 10;

  String[] wallPortNames = new String[NUM_WALLS];
  
  final String[] wallPortNamesFromFile = loadStrings("portsNames.txt");
  
  if (null!=wallPortNamesFromFile) {
    Arrays.sort(portNames, new Comparator<String>() {
      public int compare(String s1, String s2) {
        if (Arrays.asList(wallPortNamesFromFile).contains(s1)) { return 1; } else { return -1; }
      }
    });
  }
  
  for (int i = 0; wallsFound<(NUM_WALLS) && i<portNames.length; ++i) {
  
    try {
      Serial testPort = new Serial(this, portNames[i], 9600);
      testPort.bufferUntil('\n');
      testPort.write('\r'); //BusTestNew sketch gracefully ignores carriage returns.
      int tryCount = 0;
      boolean found = false;
      
      while (!found && tryCount<MAX_TRY) {
        if (testPort.available() > 0) {
          String initStr = testPort.readStringUntil('\n');
          if (initStr != null) {
            println("Found init Str:" + initStr);
            final String INIT_PREFIX = "Master-";
            int position = initStr.indexOf(INIT_PREFIX);
            if (-1!=position && position<(initStr.length() - INIT_PREFIX.length())) {
              String wallNum = initStr.substring(position + INIT_PREFIX.length());
              try {
                int wallNumInt =  Integer.parseInt(wallNum.trim());
                serialPorts[wallNumInt] = testPort;
                println("Identified wall #"+wallNumInt+" on port: "+portNames[i]);
                wallPortNames[wallNumInt] = portNames[i];
                found = true;
                wallsFound++;
              } catch (RuntimeException e) {
                println("Unable to extract wall ID: '"+wallNum+"'");
              }
            }
          }
        }
        tryCount++;
        delay(TIMEOUT_MS/MAX_TRY);
      }
      
      if (MAX_TRY==tryCount) {
        println("TIMEOUT!");
        testPort.stop();
      }
    }
    catch(RuntimeException e){
      println("Inaccessible Port: "+portNames[i]);
    }
       
  }
  
  if (NUM_WALLS == wallsFound) {
    saveStrings("portsNames.txt", wallPortNames);
  }

  //serialPorts[0] = new Serial(this, portName1, 9600);
  //serialPorts[1] = new Serial(this, portName2, 9600);
  //serialPorts[2] = new Serial(this, portName3, 9600);
  //serialPorts[3] = new Serial(this, portName4, 9600);
  //serialPorts[4] = new Serial(this, portName5, 9600);
  portsReady = true; //Elsewhere in the code (in the draw loop?) it relys on this 'portsReady' to be true only after the ports are open for proper functioning.

  return (NUM_WALLS == wallsFound);
}