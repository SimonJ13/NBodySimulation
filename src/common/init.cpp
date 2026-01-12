#include "init.h"
#include <random>

void initialize_bodies(Body* bodies, int N, unsigned int seed) {
    std::mt19937 rng(seed);
    std::uniform_real_distribution<float> dist(-1.0f, 1.0f);

    for (int i = 0; i < N; i++) {
        bodies[i].x = dist(rng);
        bodies[i].y = dist(rng);
        bodies[i].z = dist(rng);

        bodies[i].vx = 0.0f;
        bodies[i].vy = 0.0f;
        bodies[i].vz = 0.0f;

        bodies[i].m = 1.0f;
    }
}