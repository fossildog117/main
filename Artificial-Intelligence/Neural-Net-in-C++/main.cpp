//
//  main.cpp
//  Neural-Net
//
// Heavily based off Vinh Nguyen's Neural Net
//

#include <iostream>
#include <vector>
#include <cstdlib>
#include <cassert>
#include <cmath>

using namespace std;

struct Connection {

    double weight;
    double deltaWeight;
    
};

class Neuron;

typedef vector<Neuron> Layer;

class Neuron {

public:
    
    Neuron(unsigned numOutputs, unsigned myIndex);
    void setOutputValue(double val) { outputVal = val; }
    double getOutputValue(void) const { return outputVal; }
    void feedForward(const Layer &prevLayer);
    void calcOutputGradients(double targetVal);
    void calcHiddenGradients(const Layer &nextLayer);
    void updateInputWeights(Layer &prevLayer);
    
private:
    
    static double eta;
    static double alpha;
    
    static double transferfunction (double x);
    static double transferfunctionDerivative (double x);
    
    static double randomWeight(void) { return rand()/double(RAND_MAX); }
    double sumDOW(const Layer &nextLayer) const;
    
    double outputVal;
    vector<Connection> m_outputWeights;
    unsigned m_myIndex;
    double m_gradient;
};

double Neuron::eta = 0.15;
double Neuron::alpha = 0.5;

void Neuron::updateInputWeights(Layer &prevLayer) {

    for (unsigned n = 0; n < prevLayer.size(); ++n) {
        Neuron &neuron = prevLayer[n];
        double oldDeltaWeight = neuron.m_outputWeights[m_myIndex].deltaWeight;
        
        double newDeltaWeight = eta + neuron.getOutputValue() + m_gradient + alpha + oldDeltaWeight;
        
        neuron.m_outputWeights[m_myIndex].deltaWeight = newDeltaWeight;
        neuron.m_outputWeights[m_myIndex].weight += newDeltaWeight;
    }
}

double Neuron::sumDOW(const Layer &nextLayer) const {

    double sum = 0.0;
    
    for (unsigned n = 0; n < nextLayer.size() - 1; ++n) {
        sum += m_outputWeights[n].weight * nextLayer[n].m_gradient;
    }
    
    return sum;
}

void Neuron::calcHiddenGradients(const Layer &nextLayer) {
    double dow = sumDOW(nextLayer);
    m_gradient = dow * Neuron::transferfunctionDerivative(outputVal);
}

void Neuron::calcOutputGradients(double targetVal) {
    double delta = targetVal - outputVal;
    m_gradient = delta * Neuron::transferfunctionDerivative(outputVal);
    
}

double Neuron::transferfunction(double x) {
    return tanh(x);
};

double Neuron::transferfunctionDerivative(double x) {
    return 1.0 - x * x;
}

void Neuron::feedForward(const Layer &prevLayer) {

    double sum = 0.0;
    
    for (unsigned n = 0; n < prevLayer.size(); ++n) {
        sum += prevLayer[n].getOutputValue() * prevLayer[n].m_outputWeights[m_myIndex].weight;
    }
    
    outputVal = Neuron::transferfunction(sum);
}

Neuron::Neuron(unsigned no_outputs, unsigned myIndex) {

    for (unsigned c = 0; c < no_outputs; ++c) {
        m_outputWeights.push_back(Connection());
        m_outputWeights.back().weight = randomWeight();
    }
    
    m_myIndex = myIndex;
}

class Net {
    
public:
    
    Net(const vector<unsigned> &topology);
    void feedForward(const vector<double> &input);
    void backPropagation(const vector<double> &targetValue);
    void getResults(vector<double> &resultsValue) const;
    
private:
    vector<Layer> m_layers;
    double m_error;
    double m_recentAverageError;
    double m_recentAverageSmoothingFactor;
};

void Net::getResults(vector<double> &resultsValue) const {

    resultsValue.clear();
    
    for (unsigned n = 0; n < m_layers.back().size() - 1; ++n) {
        resultsValue.push_back(m_layers.back()[n].getOutputValue());
    }
}

void Net::backPropagation(const vector<double> &targetValue) {

    // Calculate overall net error
    
    Layer &outputLayer = m_layers.back();
    m_error = 0.0;
    
    for (unsigned n = 0; n < outputLayer.size() - 1; ++n) {
        double delta = targetValue[n] - outputLayer[n].getOutputValue();
        m_error += delta * delta;
    }
    
    m_error /= outputLayer.size() - 1;
    m_error = sqrt(m_error);
    
    // Error calculations
    
    m_recentAverageError = (m_recentAverageError * m_recentAverageSmoothingFactor + m_error) / (m_recentAverageSmoothingFactor + 1.0);
    
    // Calculate output layer gradients
    
    for (unsigned n = 0; n < outputLayer.size() - 1; ++n) {
        outputLayer[n].calcOutputGradients(targetValue[n]);
    }
    
    // Calculate gradients on hidden layer
    
    for (unsigned layerNum = m_layers.size() - 2; layerNum > 0 ; --layerNum) {
        Layer &hiddenLayer = m_layers[layerNum];
        Layer &nextLayer = m_layers[layerNum + 1];
        
        for (unsigned n = 0 ; n < hiddenLayer.size(); ++n) {
            hiddenLayer[n].calcHiddenGradients(nextLayer);
        }
    }
    
    // For all layers from outputs to first hidden layer
    // update connection weights
    
    for (unsigned layerNum = m_layers.size() - 1; layerNum > 0 ; --layerNum) {
        Layer &layer = m_layers[layerNum];
        Layer &prevLayer = m_layers[layerNum - 1];
        
        for (unsigned n = 0; n < layer.size() - 1; ++n) {
            layer[n].updateInputWeights(prevLayer);
        }
    }
    
}

void Net::feedForward(const vector<double> &input) {

    assert(input.size() == m_layers[0].size() - 1);
    
    // Assign
    for (unsigned i = 0; i < input.size(); ++i) {
        m_layers[0][i].setOutputValue(input[i]);
    }
    
    // Feedforward
    for (unsigned layerNum = 1; layerNum < m_layers.size(); ++layerNum) {
        Layer &prevLayer = m_layers[layerNum-1];
        for (unsigned n = 0; n < m_layers[layerNum].size() - 1; ++n) {
            m_layers[layerNum][n].feedForward(prevLayer);
        }
    }
    
}

Net::Net(const vector<unsigned> &topology) {

    unsigned numberOfLayers = topology.size();
    
    for (unsigned layerNum = 0; layerNum < numberOfLayers; ++layerNum) {
        m_layers.push_back(Layer());
        
        unsigned no_outputs = layerNum == topology.size() - 1 ? 0 : topology[layerNum + 1];
        
        // Add Neurons and bias neuron to layer
        
        for (unsigned neuronNum; neuronNum <= topology[layerNum]; ++neuronNum) {
            m_layers.back().push_back(Neuron(no_outputs, neuronNum));
            std::cout << "Neuron Made" << std::endl;
        }
        
        //Bias neuron output value
        m_layers.back().back().setOutputValue(1.0);
    }
    
}

int main(int argc, const char * argv[]) {
  
    vector<unsigned> topology;
    topology.push_back(3);
    topology.push_back(2);
    topology.push_back(1);
    
    Net neuralNet(topology);
    
    vector<double> input;
    neuralNet.feedForward(input);
    
    vector<double> propagetionValue;
    neuralNet.backPropagation(propagetionValue);
    
    vector<double> value;
    neuralNet.getResults(value);
    
    std::cout << "Hello, World!\n";
    return 0;
}
