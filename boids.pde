ArrayList<Fish> fishes;
int fishAmount = 300;

void setup()
{
   size(800, 600,P3D); // Use this line to run in windowed mode
   // fullScreen(P3D); // Use this line to run in fullScreen
   fishes = new ArrayList();
   for (int i = 0; i < fishAmount; i++)
   {
      fishes.add(new Fish( (int) random(0, width), (int) random(0, height))); 
   }
}

void draw()
{
   background(14, 127, 200);
   for (Fish f : fishes)
   {
      f.update(); 
   }
}
