set -e


g++ main.cpp -o assemble

# run assembler
ASSEMBLY="TestCases/Batch2/0-asmfiles/*.asm.txt"
for file in ${ASSEMBLY}
do
	printf ${file} | ./assemble
	# TESTCASE=$(basename ${file} .asm.txt)
	# >&2 echo ${file}
done

# move files to 2-output
HEX="TestCases/Batch2/0-asmfiles/*.hex.txt"
for file in ${HEX}
do
	mv ${file} TestCases/Batch2/2-output
done
