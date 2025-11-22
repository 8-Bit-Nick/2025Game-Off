// location
x += vx;
y += vy;

image_xscale += grow;
image_yscale += grow;
image_angle  += spin;

// fade and die
life -= 1;
image_alpha = max(0, life / 18);
if (life <= 0) instance_destroy();
