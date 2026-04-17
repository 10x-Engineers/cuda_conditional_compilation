#ifndef MULTIPLY_H
#define MULTIPLY_H

class Multiplication {
private:
    int width;
    int height;
    int value;
    int* d_output;
    
public:
    Multiplication(int w, int h, int val);
    ~Multiplication();
    void execute(int* d_input);
    int* getOutput() const { return d_output; }
};

#endif