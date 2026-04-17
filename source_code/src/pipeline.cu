#include "pipeline.h"

Pipeline::Pipeline(int w, int h, int addVal, int subVal, int mulVal) 
    : width(w), height(h) {
    addObj = new Addition(w, h, addVal);
    mulObj = new Multiplication(w, h, mulVal);
    
#ifdef CUDA_PRO
    subObj = new Subtraction(w, h, subVal);
#else
    // Suppress unused parameter warning in LITE version
    (void)subVal;
#endif
}

Pipeline::~Pipeline() {
    delete addObj;
    delete mulObj;
    
#ifdef CUDA_PRO
    delete subObj;
#endif
}

void Pipeline::execute(int* d_input) {
#ifdef CUDA_PRO
    // PRO version: Full pipeline with add, subtract, and multiply
    addObj->execute(d_input);
    subObj->execute(addObj->getOutput());
    mulObj->execute(subObj->getOutput());
#else
    // LITE version: Only add and multiply
    addObj->execute(d_input);
    mulObj->execute(addObj->getOutput());
#endif
}