
output/rv32ui-p-lb:     file format elf32-littleriscv


Disassembly of section .text.init:

01000000 <_start>:
 1000000:	00000097          	auipc	x1,0x0
 1000004:	28408093          	addi	x1,x1,644 # 1000284 <tdat>
 1000008:	00008f03          	lb	x30,0(x1)
 100000c:	fff00e93          	addi	x29,x0,-1
 1000010:	00200193          	addi	x3,x0,2
 1000014:	23df1c63          	bne	x30,x29,100024c <fail>

01000018 <test_3>:
 1000018:	00000097          	auipc	x1,0x0
 100001c:	26c08093          	addi	x1,x1,620 # 1000284 <tdat>
 1000020:	00108f03          	lb	x30,1(x1)
 1000024:	00000e93          	addi	x29,x0,0
 1000028:	00300193          	addi	x3,x0,3
 100002c:	23df1063          	bne	x30,x29,100024c <fail>

01000030 <test_4>:
 1000030:	00000097          	auipc	x1,0x0
 1000034:	25408093          	addi	x1,x1,596 # 1000284 <tdat>
 1000038:	00208f03          	lb	x30,2(x1)
 100003c:	ff000e93          	addi	x29,x0,-16
 1000040:	00400193          	addi	x3,x0,4
 1000044:	21df1463          	bne	x30,x29,100024c <fail>

01000048 <test_5>:
 1000048:	00000097          	auipc	x1,0x0
 100004c:	23c08093          	addi	x1,x1,572 # 1000284 <tdat>
 1000050:	00308f03          	lb	x30,3(x1)
 1000054:	00f00e93          	addi	x29,x0,15
 1000058:	00500193          	addi	x3,x0,5
 100005c:	1fdf1863          	bne	x30,x29,100024c <fail>

01000060 <test_6>:
 1000060:	00000097          	auipc	x1,0x0
 1000064:	22708093          	addi	x1,x1,551 # 1000287 <tdat4>
 1000068:	ffd08f03          	lb	x30,-3(x1)
 100006c:	fff00e93          	addi	x29,x0,-1
 1000070:	00600193          	addi	x3,x0,6
 1000074:	1ddf1c63          	bne	x30,x29,100024c <fail>

01000078 <test_7>:
 1000078:	00000097          	auipc	x1,0x0
 100007c:	20f08093          	addi	x1,x1,527 # 1000287 <tdat4>
 1000080:	ffe08f03          	lb	x30,-2(x1)
 1000084:	00000e93          	addi	x29,x0,0
 1000088:	00700193          	addi	x3,x0,7
 100008c:	1ddf1063          	bne	x30,x29,100024c <fail>

01000090 <test_8>:
 1000090:	00000097          	auipc	x1,0x0
 1000094:	1f708093          	addi	x1,x1,503 # 1000287 <tdat4>
 1000098:	fff08f03          	lb	x30,-1(x1)
 100009c:	ff000e93          	addi	x29,x0,-16
 10000a0:	00800193          	addi	x3,x0,8
 10000a4:	1bdf1463          	bne	x30,x29,100024c <fail>

010000a8 <test_9>:
 10000a8:	00000097          	auipc	x1,0x0
 10000ac:	1df08093          	addi	x1,x1,479 # 1000287 <tdat4>
 10000b0:	00008f03          	lb	x30,0(x1)
 10000b4:	00f00e93          	addi	x29,x0,15
 10000b8:	00900193          	addi	x3,x0,9
 10000bc:	19df1863          	bne	x30,x29,100024c <fail>

010000c0 <test_10>:
 10000c0:	00000097          	auipc	x1,0x0
 10000c4:	1c408093          	addi	x1,x1,452 # 1000284 <tdat>
 10000c8:	fe008093          	addi	x1,x1,-32
 10000cc:	02008283          	lb	x5,32(x1)
 10000d0:	fff00e93          	addi	x29,x0,-1
 10000d4:	00a00193          	addi	x3,x0,10
 10000d8:	17d29a63          	bne	x5,x29,100024c <fail>

010000dc <test_11>:
 10000dc:	00000097          	auipc	x1,0x0
 10000e0:	1a808093          	addi	x1,x1,424 # 1000284 <tdat>
 10000e4:	ffa08093          	addi	x1,x1,-6
 10000e8:	00708283          	lb	x5,7(x1)
 10000ec:	00000e93          	addi	x29,x0,0
 10000f0:	00b00193          	addi	x3,x0,11
 10000f4:	15d29c63          	bne	x5,x29,100024c <fail>

010000f8 <test_12>:
 10000f8:	00c00193          	addi	x3,x0,12
 10000fc:	00000213          	addi	x4,x0,0
 1000100:	00000097          	auipc	x1,0x0
 1000104:	18508093          	addi	x1,x1,389 # 1000285 <tdat2>
 1000108:	00108f03          	lb	x30,1(x1)
 100010c:	000f0313          	addi	x6,x30,0
 1000110:	ff000e93          	addi	x29,x0,-16
 1000114:	13d31c63          	bne	x6,x29,100024c <fail>
 1000118:	00120213          	addi	x4,x4,1 # 1 <_start-0xffffff>
 100011c:	00200293          	addi	x5,x0,2
 1000120:	fe5210e3          	bne	x4,x5,1000100 <test_12+0x8>

01000124 <test_13>:
 1000124:	00d00193          	addi	x3,x0,13
 1000128:	00000213          	addi	x4,x0,0
 100012c:	00000097          	auipc	x1,0x0
 1000130:	15a08093          	addi	x1,x1,346 # 1000286 <tdat3>
 1000134:	00108f03          	lb	x30,1(x1)
 1000138:	00000013          	addi	x0,x0,0
 100013c:	000f0313          	addi	x6,x30,0
 1000140:	00f00e93          	addi	x29,x0,15
 1000144:	11d31463          	bne	x6,x29,100024c <fail>
 1000148:	00120213          	addi	x4,x4,1 # 1 <_start-0xffffff>
 100014c:	00200293          	addi	x5,x0,2
 1000150:	fc521ee3          	bne	x4,x5,100012c <test_13+0x8>

01000154 <test_14>:
 1000154:	00e00193          	addi	x3,x0,14
 1000158:	00000213          	addi	x4,x0,0
 100015c:	00000097          	auipc	x1,0x0
 1000160:	12808093          	addi	x1,x1,296 # 1000284 <tdat>
 1000164:	00108f03          	lb	x30,1(x1)
 1000168:	00000013          	addi	x0,x0,0
 100016c:	00000013          	addi	x0,x0,0
 1000170:	000f0313          	addi	x6,x30,0
 1000174:	00000e93          	addi	x29,x0,0
 1000178:	0dd31a63          	bne	x6,x29,100024c <fail>
 100017c:	00120213          	addi	x4,x4,1 # 1 <_start-0xffffff>
 1000180:	00200293          	addi	x5,x0,2
 1000184:	fc521ce3          	bne	x4,x5,100015c <test_14+0x8>

01000188 <test_15>:
 1000188:	00f00193          	addi	x3,x0,15
 100018c:	00000213          	addi	x4,x0,0
 1000190:	00000097          	auipc	x1,0x0
 1000194:	0f508093          	addi	x1,x1,245 # 1000285 <tdat2>
 1000198:	00108f03          	lb	x30,1(x1)
 100019c:	ff000e93          	addi	x29,x0,-16
 10001a0:	0bdf1663          	bne	x30,x29,100024c <fail>
 10001a4:	00120213          	addi	x4,x4,1 # 1 <_start-0xffffff>
 10001a8:	00200293          	addi	x5,x0,2
 10001ac:	fe5212e3          	bne	x4,x5,1000190 <test_15+0x8>

010001b0 <test_16>:
 10001b0:	01000193          	addi	x3,x0,16
 10001b4:	00000213          	addi	x4,x0,0
 10001b8:	00000097          	auipc	x1,0x0
 10001bc:	0ce08093          	addi	x1,x1,206 # 1000286 <tdat3>
 10001c0:	00000013          	addi	x0,x0,0
 10001c4:	00108f03          	lb	x30,1(x1)
 10001c8:	00f00e93          	addi	x29,x0,15
 10001cc:	09df1063          	bne	x30,x29,100024c <fail>
 10001d0:	00120213          	addi	x4,x4,1 # 1 <_start-0xffffff>
 10001d4:	00200293          	addi	x5,x0,2
 10001d8:	fe5210e3          	bne	x4,x5,10001b8 <test_16+0x8>

010001dc <test_17>:
 10001dc:	01100193          	addi	x3,x0,17
 10001e0:	00000213          	addi	x4,x0,0
 10001e4:	00000097          	auipc	x1,0x0
 10001e8:	0a008093          	addi	x1,x1,160 # 1000284 <tdat>
 10001ec:	00000013          	addi	x0,x0,0
 10001f0:	00000013          	addi	x0,x0,0
 10001f4:	00108f03          	lb	x30,1(x1)
 10001f8:	00000e93          	addi	x29,x0,0
 10001fc:	05df1863          	bne	x30,x29,100024c <fail>
 1000200:	00120213          	addi	x4,x4,1 # 1 <_start-0xffffff>
 1000204:	00200293          	addi	x5,x0,2
 1000208:	fc521ee3          	bne	x4,x5,10001e4 <test_17+0x8>

0100020c <test_18>:
 100020c:	00000297          	auipc	x5,0x0
 1000210:	07828293          	addi	x5,x5,120 # 1000284 <tdat>
 1000214:	00028103          	lb	x2,0(x5)
 1000218:	00200113          	addi	x2,x0,2
 100021c:	00200e93          	addi	x29,x0,2
 1000220:	01200193          	addi	x3,x0,18
 1000224:	03d11463          	bne	x2,x29,100024c <fail>

01000228 <test_19>:
 1000228:	00000297          	auipc	x5,0x0
 100022c:	05c28293          	addi	x5,x5,92 # 1000284 <tdat>
 1000230:	00028103          	lb	x2,0(x5)
 1000234:	00000013          	addi	x0,x0,0
 1000238:	00200113          	addi	x2,x0,2
 100023c:	00200e93          	addi	x29,x0,2
 1000240:	01300193          	addi	x3,x0,19
 1000244:	01d11463          	bne	x2,x29,100024c <fail>
 1000248:	00301c63          	bne	x0,x3,1000260 <pass>

0100024c <fail>:
 100024c:	0ff0000f          	fence	iorw,iorw
 1000250:	00018063          	beq	x3,x0,1000250 <fail+0x4>
 1000254:	00119193          	slli	x3,x3,0x1
 1000258:	0011e193          	ori	x3,x3,1
 100025c:	00000073          	ecall

01000260 <pass>:
 1000260:	0ff0000f          	fence	iorw,iorw
 1000264:	00100193          	addi	x3,x0,1
 1000268:	00000073          	ecall
 100026c:	c0001073          	unimp
 1000270:	0000                	c.unimp
 1000272:	0000                	c.unimp
 1000274:	0000                	c.unimp
 1000276:	0000                	c.unimp
 1000278:	0000                	c.unimp
 100027a:	0000                	c.unimp
 100027c:	0000                	c.unimp
 100027e:	0000                	c.unimp
 1000280:	0000                	c.unimp
 1000282:	0000                	c.unimp

Disassembly of section .data:

01000284 <tdat>:
 1000284:	                	0xff

01000285 <tdat2>:
 1000285:	                	c.fsw	f8,32(x8)

01000286 <tdat3>:
 1000286:	                	c.addi4spn	x12,x2,988

01000287 <tdat4>:
 1000287:	0f    	Address 0x0000000001000287 is out of bounds.

 100028b:	 