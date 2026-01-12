#include <iostream>
#include <cmath>
#include "body.h"
#include "init.h"

const int t = 100;
const int N = 2;
const float soften = 1e-5;
const float dt = 0.01;
const float G = 1.0;




void update(Body* bodies){
    for(int i = 0; i < N; i++){

        float fx = 0.0;
        float fy = 0.0;
        float fz = 0.0;

        
        for(int j = 0; j < N; j++){
            if(i == j) continue;

            float dx = bodies[j].x - bodies[i].x;
            float dy = bodies[j].y - bodies[i].y;
            float dz = bodies[j].z - bodies[i].z;

            float r2 = dx*dx + dy*dy + dz*dz + soften;
            float r = sqrt(r2);

            float f = G * bodies[i].m * bodies[j].m / r2;

            fx += f * dx / r;
            fy += f * dy / r;
            fz += f * dz / r;
        }

        
        float ax = fx / bodies[i].m;
        float ay = fy / bodies[i].m;
        float az = fz / bodies[i].m;

       
        bodies[i].vx += ax * dt;
        bodies[i].vy += ay * dt;
        bodies[i].vz += az * dt;

        bodies[i].x += bodies[i].vx * dt;
        bodies[i].y += bodies[i].vy * dt;
        bodies[i].z += bodies[i].vz * dt;
    }
}






int main(){

    Body bodies[N];

    initialize_bodies(bodies, N, 42);

    for (float t = 0; t < 100; t += dt){

        update(bodies);

        printf("t=%.2f: Body 0 -> x=%.3f y=%.3f z=%.3f\n",
       t, bodies[0].x, bodies[0].y, bodies[0].z);


    }

    
    return 0;
}