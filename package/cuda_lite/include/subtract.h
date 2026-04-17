#ifndef SUBTRACT_H
#define SUBTRACT_H

class Subtraction {
private:
    int width;
    int height;
    int value;
    int* d_output;
    
public:
    Subtraction(int w, int h, int val);
    ~Subtraction();
    void execute(int* d_input);
    int* getOutput() const { return d_output; }
};

#endif