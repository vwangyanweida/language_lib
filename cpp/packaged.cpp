#include <future>
#include <iostream>
#include <thread>

using namespace std;

int Add(int x, int y) {
	return x + y;
}

int main() {
	packaged_task<int(int, int)> task(Add);
	future<int> futu = task.get_future();
	task(1 ,2);
	cout << futu.get() << endl;
}
