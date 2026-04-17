#include "pipeline.h"

Pipeline::Pipeline(int w, int h, int addVal, int subVal, int mulVal) 
    : width(w), height(h) {
    addObj = new Addition(w, h, addVal);
    subObj = new Subtraction(w, h, subVal);
    mulObj = new Multiplication(w, h, mulVal);
}

Pipeline::~Pipeline() {
    delete addObj;
    delete subObj;
    delete mulObj;
}

void Pipeline::execute(int* d_input) {
    // Step 1: Addition
    addObj->execute(d_input);
    
    // Step 2: Subtraction (using addition's output)
    subObj->execute(addObj->getOutput());
    
    // Step 3: Multiplication (using subtraction's output)
    mulObj->execute(subObj->getOutput());
}