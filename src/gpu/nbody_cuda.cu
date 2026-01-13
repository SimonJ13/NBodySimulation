#include "body.h"
#include <cuda_runtime.h>



__global__ void gpu_update(Body* bodies, int N, float dt, float soften, float G){

    int i = blockIdx.x * blockDim.x + threadIdx.x;
    if(i >= N) return;

    float fx = 0.0;
    float fy = 0.0;
    float fz = 0.0;

        
    for (int j = 0; j < N; j++){
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
        

           