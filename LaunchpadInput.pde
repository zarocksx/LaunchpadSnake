import themidibus.*; 
import java.lang.reflect.Method;
import javax.sound.midi.MidiMessage;
public class LaunchpadInput {
  String[] deviceName;
  boolean isConnected;
  int currentColor;
  ArrayList devices = new ArrayList();
  int[] buttonTimer;
  MidiBus myBus;
  
  public LaunchpadInput(String[] device) {
    this.deviceName = device;
    this.init();
  }
  
  void init(){
    println(this.connect());
    if (this.connect() == false ) this.disconnect();
    
  }
  
  int getcolor(){
   return this.currentColor; 
  }
  
  void delay(int time) {
    int current = millis();
    while (millis () < current+time) Thread.yield();
  }

  boolean connect() { //<>// //<>//
  
    String[] available_inputs = MidiBus.availableInputs(); 
    for (int i = 0;i < available_inputs.length;i++) {
      for(int x=0; x < this.deviceName.length; x++) {
        println("Check for device " + this.deviceName[x] + " against " + available_inputs[i] );
        if (available_inputs[i].indexOf(this.deviceName[x]) > -1 ) {
          println("* * * * Add device " + this.deviceName[x] + " * * * * ");
          this.devices.add( new MidiBus(this, this.deviceName[x], this.deviceName[x]) );
          return true;
        }
      }
    }
    return false;
  }
  
  void disconnect() {
    println("Launchpad is unavalaible. \nExiting.");
    exit(); 
  }
  
  void midiMessage(MidiMessage message, long timestamp, String bus_name) {
   println("data here");
   try {
   int button = (int)(message.getMessage()[1] & 0xFF) ;
   int padColor = (int)(message.getMessage()[2] & 0xFF);
   this.invokeNoteHandler(button, padColor, timestamp, bus_name);
   this.activeLed(padColor, button);
   } catch (Exception e) {
     if (debug == true) {
       e.printStackTrace();
     }
   }
}
  
  void invokeNoteHandler(int button, int padColor, long timestamp, String bus_name) {
    println("button: "+button+" -- color: "+padColor);
    try {
      Class[] cls = new Class[1]; // verifier l'utilitée de cls
      cls[0] = int.class;
      Method handler = this.getClass().getMethod( "onNote" + button, cls ); // cherche la methode
      handler.invoke(this, padColor);//appel la fonction trouvée
    } catch (Exception e) {
      if (debug == true) {
        e.printStackTrace();
      }
    }
    if (debug == true) {
       println(timestamp);
       println(bus_name);
     }
  }
  
  int[] intToTab(int n) {
   int ones = n%10;
   int tens = (n/10)%10;
   //int hundreds = (n/100)%10;
   //int thousands = (n/1000);
   int[] coords = {tens,ones};
   return coords;
  }
  
  void activeLed(int buttonColor, int button) {
    MidiBus pad = (MidiBus)this.devices.get(0);
    pad.sendNoteOn(0, button, button);

    pad.sendNoteOff(0, button, button);
  }
  void onNote81(int vel) {
    if (vel > 0 ) { currentColor = vel*2; }
  }
  
}
