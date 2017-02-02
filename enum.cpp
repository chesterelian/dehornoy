#include <iostream>
#include <string>
#include <sstream>

using namespace std;

/*
 * argv[1] is braid index
 * argv[2] is min word length
 * argv[3] is max word length
 */
int main(int argc, char* argv[]) {
  stringstream c1(argv[1]), c2(argv[2]), c3(argv[3]);
  int n, minLen, maxLen;
  int len, i;

  if (argc != 4) {
    cerr << "Need exactly 3 numeric arguments.\n";
    return 1;
  }

  if (!(c1 >> n)) {
    cerr << "Error: First argument " << argv[1] << " is not a number.\n";
    return 1;
  }

  if (!(c2 >> minLen)) {
    cerr << "Error: Second argument " << argv[2] << " is not a number.\n";
    return 1;
  }

  if (!(c3 >> maxLen)) {
    cerr << "Error: Third argument " << argv[3] << " is not a number.\n";
    return 1;
  }

  for (len = minLen; len <= maxLen; len++) {
    int* word = new int[len];
    for (i = 0; i < len; i++) {
    }
  }

  return 0;
}
