#ifndef PIPELINE_H
#define PIPELINE_H

#include "add.h"
#include "multiply.h"


class Pipeline {
private:
    Addition* addObj;
    Multiplication* mulObj;
    
    
    int width;
    int height;
    
public:
    Pipeline(int w, int h, int addVal, int subVal, int mulVal);
    ~Pipeline();
    void execute(int* d_input);
    int* getFinalOutput() const { return mulObj->getOutput(); }
};

#endif