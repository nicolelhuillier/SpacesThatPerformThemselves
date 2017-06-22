import processing.serial.*;

println(Serial.list());

println();
println();

for(int i =0; i < Serial.list().length; i++){
  println(i+": "+Serial.list()[i]);
}

 