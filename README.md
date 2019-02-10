#x86_64 Projects
I am currently trying to learn the 64 bit version of the x86 assembly language.

My current project is a postfix notation calculator that prints the result in hexadecimal. For example, 1 2 + would print 0x03.

##To run:
###Linux:
	- nasm -f elf64 -o calculator.o calculator.asm
	- ld calculator.o -o calculator
	- ./calculator
###MacOS:
	- nasm -f macho64 -o calculator_mac.o calculator_mac.asm
	- ld calculator_mac.o -o calculator_mac -macosx_version_min 10.13 -lSystem
	- ./calculator_mac