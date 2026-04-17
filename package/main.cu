#include <iostream>
#include <cstdlib>
#include <ctime>
#include <cuda_runtime.h>
#include "pipeline.h"

void printMatrix(int* matrix, int width, int height, const char* name) {
    std::cout << name << ":" << std::endl;
    for (int i = 0; i < height; i++) {
        for (int j = 0; j < width; j++) {
            std::cout << matrix[i * width + j] << "\t";
        }
        std::cout << std::endl;
    }
    std::cout << std::endl;
}

int main(int argc, char* argv[]) {
    if (argc != 6) {
        std::cerr << "Usage: " << argv[0] << " <width> <height> <add> <sub> <mul>" << std::endl;
        return 1;
    }
    
    int width = atoi(argv[1]);
    int height = atoi(argv[2]);
    int addVal = atoi(argv[3]);
    int subVal = atoi(argv[4]);
    int mulVal = atoi(argv[5]);
    
    int size = width * height;
    
    // Initialize Host Memory
    std::srand(std::time(nullptr));
    int* h_input = new int[size];
    for (int i = 0; i < size; i++) {
        h_input[i] = rand() % 100;
    }
    
    printMatrix(h_input, width, height, "Original Matrix");
    
    // Allocate and Copy to Device
    int* d_input;
    cudaMalloc(&d_input, size * sizeof(int));
    cudaMemcpy(d_input, h_input, size * sizeof(int), cudaMemcpyHostToDevice);
    
    // Execute Pipeline (Implementation hidden in .so)
    Pipeline pipeline(width, height, addVal, subVal, mulVal);
    pipeline.execute(d_input);
    
    // Retrieve Results
    int* h_output = new int[size];
    cudaMemcpy(h_output, pipeline.getFinalOutput(), size * sizeof(int), cudaMemcpyDeviceToHost);
    
    printMatrix(h_output, width, height, "Final Matrix (Result of Pipeline)");
    
    // Cleanup
    cudaFree(d_input);
    delete[] h_input;
    delete[] h_output;
    
    return 0;
}