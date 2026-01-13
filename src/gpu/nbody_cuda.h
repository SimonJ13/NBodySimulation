#pragma once
#include "body.h"


__global__ void gpu_update(Body* bodies, int N, float dt, float soften, float G);