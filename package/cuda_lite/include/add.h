#ifndef ADD_H
#define ADD_H

class Addition {
private:
    int width;
    int height;
    int value;
    int* d_output;
    
public:
    Addition(int w, int h, int val);
    ~Addition();
    void execute(int* d_input);
    int* getOutput() const { return d_output; }
};

#endif