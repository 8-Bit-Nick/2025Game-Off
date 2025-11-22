// Purpose: a single puff that drifts, scales up, and fades out

life   = 18;          // frames until it disappears (~0.3s at 60fps)
vx     = lengthdir_x(irandom_range(0, 1), direction); // will be set by spawner; default tiny drift
vy     = lengthdir_y(irandom_range(0, 1), direction);
grow   = 0.02;        // how much to scale per frame
spin   = irandom_range(-4, 4);  // subtle rotation
image_xscale = 0.7;
image_yscale = 0.7;
image_alpha  = 0.9;
image_blend  = make_color_rgb(255, 180, 60); 
