all:
	python3 setup.pyx build_ext --inplace
clear:
	rm -f *.c *.so
