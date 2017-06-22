var WebSocketServer = require('ws').Server;

var SERVER_PORT = 8081;               // port number for the webSocket server
var wss = new WebSocketServer({port: SERVER_PORT}); // the webSocket server
var connections = new Array;          // list of connections to the server
var myPorts = [];
var portWalls = []; //map wall ID per port
var wallPort = []; //map wall numbers to ports

wss.on('connection', handleConnection);
 
function handleConnection(client) {
 console.log("New Connection"); // you have a new client
 connections.push(client); // add this client to the connections array
 
 client.on('message', sendToSerial ); // when a client sends a message,
 
 client.on('close', function() { // when a client closes its connection
   console.log("connection closed"); // print it out
   var position = connections.indexOf(client); // get the client's position in the array
   connections.splice(position, 1); // and delete it from the array
 });

}


function sendToSerial(data) {
 jsonData = JSON.parse(data);
 if (jsonData.wallNumber !== undefined && jsonData.data !== undefined) {
   if (wallPort[jsonData.wallNumber] !== undefined) {
    wallPort[jsonData.wallNumber].write(jsonData.data+"\n");
   } else {
    console.log("unable to send to wall #"+jsonData.wallNumber+" - wall not connected or not initialized");
   }
 } else {
  console.log("malformed ws request received: "+data);
 }
}

// This function broadcasts messages to all webSocket clients
function broadcast(data) {
 for (myConnection in connections) {   // iterate over the array of connections
  connections[myConnection].send(data); // send the data to each connection
 }
}

function showPortOpen(portNum) {
   port = myPorts[portNum];
   console.log("port open ("+portNum+")");
   console.log("Data rate: " + port.options.baudRate);
}

function portToWall(portNum) {
  return (portWalls[portNum]==undefined)? -1 : portWalls[portNum]; 
}
 
function sendSerialData(portNum,data) {
  if (data.startsWith("Master-")) {
    wallNum = data.substr(7,1);
    portWalls[portNum] = wallNum;
    wallPort[wallNum] = myPorts[portNum];
  }
   console.log(portNum+":"+data);
   // if there are webSocket connections, send the serial data
   // to all of them:
   if (connections.length > 0) {
     jsonData = { "wallNumber" : portToWall(portNum), "data" : data }
     broadcast(JSON.stringify(jsonData));
   }
}
 
function showPortClose() {
   console.log("port closed (" + portNum + ")");
}
 
function showError(portNum,error) {
   console.log("Serial port #"+portNum+" error: " + error);
}



var serialport = require('serialport');// include the library
 //  SerialPort = serialport.SerialPort; // make a local instance of it



// get port name from the command line:
console.log("Connecting ports: ("+(process.argv.length-2)+")");
for (i = 0; i<process.argv.length-2; ++i) {
  portname = process.argv[i+2];
  console.log("added port: "+portname);
  myPorts[i] = (new serialport(portname, {
                     baudRate: 9600,
                     // look for return and newline at the end of each data packet:
                     parser: serialport.parsers.readline("\n") }) 
              );

  myPorts[i].on('open',
      (function (pNum) { 
        return function() {
          showPortOpen(pNum);
        } 
      })(i) 
    );

  myPorts[i].on('data',
      (function (pNum) { 
        return function(data) {
          sendSerialData(pNum,data);
        } 
      })(i) 
    );

  myPorts[i].on('close',
      (function (pNum) { 
        return function() {
          showPortClose(pNum);
        } 
      })(i) 
    );

  myPorts[i].on('error',
      (function (pNum) { 
        return function(error) {
          showError(pNum,error);
        } 
      })(i) 
    );

}


