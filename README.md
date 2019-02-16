<b>x86_64 Projects</b><br />
I am currently trying to learn the 64 bit version of the x86 assembly language.

My current project is a postfix notation calculator that prints the result in hexadecimal and decimal. For example, 1 2 + would print 0x03.

To run:<br />
Linux:<br />
	- nasm -f elf64 -o calculator.o calculator.asm<br />
	- ld calculator.o -o calculator<br />
	- ./calculator<br />
	<br />
MacOS:<br />
	- nasm -f macho64 -o calculator_macos.o calculator_macos.asm<br />
	- ld calculator_macos.o -o calculator_mac -macosx_version_min 10.13 -lSystem<br />
	- ./calculator_macos<br />
