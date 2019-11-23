#include <vector>
#include <iostream>
using namespace std;

void vPrint(vector<int>&  coll) {
	for (auto i: coll)
	  cout << i << endl;
}

int main()
{
	vector<int> a = {1, 2, 4, 5, 6};
	vPrint(a);

}
