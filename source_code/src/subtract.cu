#include "subtract.h"
#include <cuda_runtime.h>
#include <stdio.h>

__global__ void subtractKernel(int* input, int* output, int value, int size) {
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < size) {
        output[idx] = input[idx] - value;
    }
}

Subtraction::Subtraction(int w, int h, int val) : width(w), height(h), value(val) {
    int size = width * height * sizeof(int);
    cudaMalloc(&d_output, size);
}

Subtraction::~Subtraction() {
    if (d_output) {
        cudaFree(d_output);
    }
}

void Subtraction::execute(int* d_input) {
    int size = width * height;
    int threadsPerBlock = 256;
    int blocksPerGrid = (size + threadsPerBlock - 1) / threadsPerBlock;
    
    subtractKernel<<<blocksPerGrid, threadsPerBlock>>>(d_input, d_output, value, size);
    cudaDeviceSynchronize();
}