all:
	python3.7 setup.pyx build_ext --inplace
clear:
	rm -f *.c *.so
