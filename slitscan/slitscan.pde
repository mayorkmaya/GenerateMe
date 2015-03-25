// Distort the image
// generateme.blog@gmail.com
// Tomasz Sulej // generateme.tumblr.com
//
// Licence: <http://unlicense.org>

// - click to change
// - keypress to save result

// sometimes it copies the image, I don't know why, ignore and click more

// put file name here
String filename = "test.jpg"; 
   
// logic starts here   
int[] fx;
int[] fy;
  
float[] phx;
float[] phy;
  
int[] sx,sy;
  
boolean[] skipfx;
boolean[] skipfy;
  
boolean dox,doy;
  
PImage img;

float[][] ft = new float[2][32];  
  
int depth; // number of octaves  
  
void setup() {
  img = loadImage(filename);
  size(img.width,img.height);
  noStroke();
  fill(255);
  background(0);
 
  for(int i=0;i<32;i++) {
    ft[0][i] = pow(2.0,i);
    ft[1][i] = 0.5*1.0/ft[0][i];
  }

  int s = width>height?height:width;
  depth = (int)(log(s)/log(2));

  println(depth);

  mouseClicked();
}

void mouseClicked() {
  int fxnum = (int)random(depth);
  int fynum = (int)random(depth);
   
  fx = new int[fxnum+1]; 
  fy = new int[fynum+1];
  sx = new int[fxnum+1]; 
  sy = new int[fynum+1];
  
  phx = new float[fxnum+1];
  phy = new float[fynum+1];
  
  skipfx = new boolean[fxnum+1];
  skipfy = new boolean[fynum+1];
  
  for(int i=0;i<fxnum;i++) {
    fx[i]=(int)random(6);
    phx[i] = random(1);
    skipfx[i] = random(1)<0.2;
    sx[i] = random(1)<0.2?-1:1;
  }
  for(int i=0;i<fynum;i++) {
    fy[i]=(int)random(6);
    phy[i] = random(1);
    skipfy[i] = random(1)<0.2;
    sy[i] = random(1)<0.2?-1:1;
  }
  
  dox = random(1)<0.8;
  doy = dox?random(1)<0.8:true;
   
  float v=0;
  for(int y=0;y<height;y++)
  for(int x=0;x<width;x++) {
    float iy = map(y,0,height,0,1);
   
    v=0;
    if(doy) for(int i=0;i<fy.length;i++)
       if(!skipfy[i]) v+=sy[i]*getValue(fy[i],iy,i,phy[i]); 
    
    float ry = 2*iy+v;
    float y2 = (3*height+ry * height/2)%height;  
     
    float ix = map(x,0,width,0,1);
    v=0;
    if(dox) for(int i=0;i<fx.length;i++)
       if(!skipfx[i]) v+=sx[i]*getValue(fx[i],ix,i,phx[i]); 
     
    
    float rx = 2*ix+v;
    float x2 = (3*width+rx * width/2)%width;   
     
    fill(img.get((int)x2,(int)y2)); 
    rect(x,y,1,1);
  } 
}

void keyPressed() {
  save("res_"+(int)random(10000,99999)+"_"+filename);
}

void draw() {}

float getValue(int fun, float idx, int freq, float phase) {
  switch(fun) {
    case 0: return getSin(idx,freq,phase);
    case 1: return getSaw(idx,freq,phase);
    case 2: return getTriangle(idx,freq,phase);
    case 3: return getCutTriangle(idx,freq,phase);
    case 4: return getSquare(idx,freq,phase);
    case 5: return getNoise(idx,freq,phase);
    default: return getSin(idx,freq,phase);
  }
}

float getNoise(float idx, int freq, float phase) {
  return 2*ft[1][freq]*(noise((idx+phase)*ft[0][freq])-0.5);
}

float getSin(float idx, int freq, float phase) {
  float p = ft[0][freq];
  return ft[1][freq] * sin(idx*TWO_PI*p+phase*TWO_PI);
}

float getSaw(float idx, int freq, float phase) {
  float p = ft[0][freq];
  float rp = 2.0*ft[1][freq];
  float p2 = p*((idx+phase+ft[1][freq])%1.0);
  return rp*(p2-floor(p2)-0.5);
}

float getSquare(float idx, int freq, float phase) {
  float p = ft[0][freq];
  float rp = ft[1][freq];
  return (((idx*p)+phase)%1.0)<0.5?rp:-rp;
}

float getTriangle(float idx, int freq, float phase) {
  return 2*abs(getSaw(idx,freq,phase+0.5*ft[1][freq]))-ft[1][freq];
}

float getCutTriangle(float idx, int freq, float phase) {
  return constrain(getTriangle(idx,freq,phase),-ft[1][freq+1],ft[1][freq+1]);
}
