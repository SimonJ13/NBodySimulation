#include <stdio.h>
#include "body.h"
#include "init.h"
#include "nbody_cuda.h"
#include <cuda_runtime.h>

const int N = 3;
const int t = 100;
const float dt = 0.01f;
const float soften = 1e-5f;
const float G = 1.0f;

int main() {
    Body bodies[N];
    initialize_bodies(bodies, N, 42);

    Body* d_bodies;
    cudaMalloc(&d_bodies, N * sizeof(Body));
    cudaMemcpy(d_bodies, bodies, N * sizeof(Body), cudaMemcpyHostToDevice);

    int threads_per_block = 128;
    int blocks = (N + threads_per_block - 1) / threads_per_block;

    int step = 0;
    for (float time = 0.0f; time < t; time += dt) {

        gpu_update<<<blocks, threads_per_block>>>(d_bodies, N, dt, soften, G);
        cudaDeviceSynchronize();

        cudaMemcpy(bodies, d_bodies, N * sizeof(Body), cudaMemcpyDeviceToHost);

        printf("Step %d (t = %.2f)\n", step++, time);
        for (int i = 0; i < N; i++) {
            printf("  Body %d: x=%.6f y=%.6f z=%.6f\n",
                   i, bodies[i].x, bodies[i].y, bodies[i].z);
        }
        printf("\n");
    }

    cudaFree(d_bodies);
    return 0;
}
