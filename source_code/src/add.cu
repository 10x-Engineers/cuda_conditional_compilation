#include "add.h"
#include <cuda_runtime.h>
#include <stdio.h>

__global__ void addKernel(int* input, int* output, int value, int size) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < size) {
        output[idx] = input[idx] + value;
    }
}

Addition::Addition(int w, int h, int val) : width(w), height(h), value(val) {
    int size = width * height * sizeof(int);
    cudaMalloc(&d_output, size);
}

Addition::~Addition() {
    if (d_output) {
        cudaFree(d_output);
    }
}

void Addition::execute(int* d_input) {
    int size = width * height;
    int threadsPerBlock = 256;
    int blocksPerGrid = (size + threadsPerBlock - 1) / threadsPerBlock;
    
    addKernel<<<blocksPerGrid, threadsPerBlock>>>(d_input, d_output, value, size);
    cudaDeviceSynchronize();
}