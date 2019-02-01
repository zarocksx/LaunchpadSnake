Configgy config;
LaunchpadInput lp;

boolean debug = false;
int currentColor = 0;


void setup() {
  size(450, 450); // permet 9X9 cases de 50 px de coté

  config = new Configgy("config.jsi"); // le device enregistré dans le fichier .jsi ( utiliser midi_check ;) )
  lp = new LaunchpadInput(config.getStrings("devices"));
}

void draw() {
  background(lp.currentColor);
}
