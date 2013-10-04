#include <iostream>
#include <cmath>

using namespace std;

class helloworlder {
public:
    helloworlder(const char * from) : text_(from)
    {
        cout << "Hello, world! from " << text_ << std::endl;
        double d = (double)text_[0];
        double r = ::asinh(d);
        cout << "asinh(" << d << ")=" << r << std::endl;
    }
    ~helloworlder()
    {
        cout << "Goodbye, world! from " << text_ << std::endl;
    }
private:
    const char * text_;
};

helloworlder g_hello("global");

int main(int argc, char ** argv)
{
    helloworlder aHello(argv[0]);
    
    return 0;
}
