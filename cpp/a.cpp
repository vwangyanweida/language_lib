#include <thread>
#include <future>
#include <iostream>
#include <string>
#include <exception>
#include <stdexcept>
#include <functional>
#include <utility>
#include <chrono>

void doSomething(std::promise<std::string>& p) {
	try {
		std::cout << "read char ('x' for exception): ";
		char c = std::cin.get();
		if (c == 'x') {
			throw std::runtime_error(std::string("char ")+c+" read");
		}
		std::string s = std::string("char ") + c + " processed";
		p.set_value(std::move(s));

		std::this_thread::sleep_for(std::chrono::seconds(2));
		p.set_value(std::string("this is second number"));

	} catch (...) {
		p.set_exception(std::current_exception());
	}
	
}

int main() {
	try {
		std::promise<std::string> p;
		std::thread t(doSomething, std::ref(p));
		t.detach();

		std::future<std::string> f(p.get_future());
		std::cout << "result: " << f.get() << std::endl;

		std::future<std::string> g(p.get_future());
		std::cout << "result: " << g.get() << std::endl;

	} catch (const std::exception& e) {
		std::cerr << "EXCEPTION: " << e.what() << std::endl;
	} catch (...) {
		std::cerr << "EXCEPTION: " << std::endl;
	}
}
