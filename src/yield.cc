#include <iostream>
#include <algorithm>
#pragma clang diagnostic ignored "-Wunreachable-code"
#define NORETURN __attribute__ ((noreturn)) __attribute__ ((optnone)) void

NORETURN yield(const int &i){
	const void *_continue = __builtin_return_address(0);
	const void *_return = __builtin_return_address(1);
	asm("push %0 \n\t"
		"jmp *%1 \n\t"
		: :"r"(_continue), "r"(_return));
	throw 0;
}

NORETURN fibonacci(int n) {
	int x0=0, x1=1;
	if(n<2) exit(n);
	for(int i=2; i<=n; ++i){
		std::swap(x0, x1);
		x1+=x0;
		yield(x1);
	}
	exit(x1);
}

NORETURN next(){
	asm("pop %%rax \n\t"
		"jmp *%%rax \n\t"
		: :);
	throw 0;
}

int main(int argc, char const *argv[]) {
	// iteration variable
	volatile int i = 0;

	// init iteration
	fibonacci(argc>1?atoi(argv[1]):0);

	// iterate
	while(1) {
		std::cout<<i<<std::endl;
		next();
	}
}
