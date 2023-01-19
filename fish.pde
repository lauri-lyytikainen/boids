class Fish
{
  PVector pos, vel;
  float speed, sightDistance, noise, speedBoost;
  ArrayList<PVector> pastPos, pastVel;

  color[] colors  = {
    color(240, 216, 168), 
    color(134, 183, 177), 
    color(242, 215, 148), 
    color(249, 42, 0)
  };

  color headColor = colors[(int)random(0, colors.length)];
  color bodyColor = colors[(int)random(0, colors.length)];
  color tailColor = colors[(int)random(0, colors.length)];

  public Fish(int x, int y)
  {
    pos           = new PVector(x, y);
    vel           = PVector.random2D();
    speed         = random(1, 2);
    speedBoost    = 0;
    sightDistance = 200;
    noise         = random(0, 1000);
    pastPos       = new ArrayList();
    pastVel       = new ArrayList();
  }


  public void update()
  {
    move();
    show();
  }

  // Move the fish
  private void move()
  {
    control();
    pos.add(vel.x * (speed + speedBoost), vel.y * (speed + speedBoost));
    if (pos.x > width) {
      pos.x = pos.x - width;
    }
    if (pos.y > height) {
      pos.y = pos.y - height;
    }
    if (pos.x < 0) {
      pos.x = width + pos.x;
    }
    if (pos.y < 0) {
      pos.y = height + pos.y;
    }
  }

  // Render the fish
  private void show()
  {
    push();
    translate(pos.x, pos.y);
    rotate(vel.heading() + HALF_PI);
    
    strokeWeight(0);
    stroke(0, 0);
    fill(headColor);
    ellipse(0, 0, 10, 20);
    ellipse(0, 2, 15, 10);
    
    stroke(0);
    strokeWeight(2);
    point(2, -6);
    point(-2, -6);
    
    pop();
    
    push();
    
    translate(pastPos.get(0).x, pastPos.get(0).y);
    rotate(pastVel.get(0).heading() + HALF_PI);
    strokeWeight(0);    
    stroke(0, 0);
    fill(tailColor);
    
    quad(7, 7, 0, 3, -7, 7, 0, -5);
    pop();
    
    for (int i = pastPos.size() - 2; i > 0; i--)
    {
      stroke(bodyColor);
      strokeWeight(map(i, 1, pastPos.size() - 1, 5, 10));
      point(pastPos.get(i).x, pastPos.get(i).y);
    }
  }

  // Control the fish in a flock simulation
  private void control()
  {
    pastPos.add(new PVector(pos.x, pos.y));
    pastVel.add(new PVector(vel.x, vel.y));

    // Remove old positions and velocities
    if (pastPos.size() > (int)(speed * 10))
    {
      pastPos.remove(pastPos.get(0));
    }

    if (pastVel.size() > (int)(speed * 10))
    {
      pastVel.remove(pastVel.get(0));
    }

    PVector averageVelocity = new PVector(vel.x, vel.y);
    PVector averagePos      = new PVector(pos.x, pos.y);
    int     amount          = 1;

    for (Fish f : fishes)
    {
      float dist = pos.dist(f.pos);

      if (dist <= sightDistance / 2 && f != this)
      {
        //Separation
        PVector dir = new PVector(f.pos.x - pos.x, f.pos.y - pos.y);
        dir.mult(-1 * (1 / (dist * dist)));
        dir.normalize();
        vel.add(dir.mult(0.01));

        //Alignment
        averageVelocity.add(f.vel);
        amount++;

        //Cohesion
        averagePos.add(f.pos);
      }
    }

    // Move away from mouse
    float dist = dist(mouseX, mouseY, pos.x, pos.y);
    if (dist <= sightDistance / 2)
    {
      speedBoost = map(dist,sightDistance / 2, 0, 0, 1);
      PVector dir = new PVector(mouseX - pos.x, mouseY - pos.y);
      dir.mult(-1 * (1 / (dist * dist)));
      dir.normalize();
      vel.add(dir.mult(0.1));
    }
    else
    {
       speedBoost = 0; 
    }
    if (amount != 0) {

      vel.add(averageVelocity.div(amount).mult(0.1));


      averagePos.div(amount);
      averagePos.sub(pos);
      vel.add(averagePos.mult(0.003));
    }

    // Add noise to velocity
    vel.rotate(map(noise(noise), 0, 1, -0.05, 0.05));
    noise += 0.01;

    vel.normalize();
  }
}
