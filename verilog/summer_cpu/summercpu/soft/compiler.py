import string
reg=['zero','at','v0','v1','a0','a1','a2','a3',
't0','t1','t2','t3','t4','t5','t6','t7',
's0','s1','s2','s3','s4','s5','s6','s7',
't8','t9','xp','k1','gp','sp','fp','ra']
branch=[]
def findname(str_begin,str_end,html):
	begin = html.find(str_begin)
	if begin >= 0:
		begin += len(str_begin)
		str_end = html.find(str_end,begin)
		if str_end >= 0:
			return html[begin:str_end].strip()
def bin2(str,num):
	dec = string.atoi(str)
	if dec >= 0:
		return (bin(dec)[2:]).zfill(num)
	else:
		return bin(2**num+dec)[2:].zfill(num)
def bin1(str,num):
	return (bin(reg.index(str))[2:]).zfill(num)
fo = open('rom.v','w')
fo.write("`timescale 1ns/1ps\nmodule ROM (addr,data);\ninput [31:0] addr;\noutput [31:0] data;\nreg [31:0] data;\nlocalparam ROM_SIZE = 32;\nreg [31:0] ROM_DATA[ROM_SIZE-1:0];\nalways@(*)\n    case(addr)	//Address Must Be Word Aligned.\n")
fo.close()

fp = open("code.asm","r")
i = 0
j = 0
flag = 0
for line in fp:
	if line[0:4] == 'INT2':
		flag = 1
		j -= 1
	if line[0:4] == 'END2':
		flag = 0
		j -= 1
	place = line.find(':')
	if place >= 0:
		templabel = line[:place]
		branch += [templabel,j]
	j += 1
fp.close()
fp = open("code.asm","r")
add = 0
ILLOP = int('80000004',16)
XADR = int('80000008',16)
for line in fp:
	i += 1
	place = line.find(':')
	judge = 0
	if place >= 0:
		templabel = line[0:place]
		line = line[place+1:]
		judge = 1
	explain = line.find('#')
	if explain >= 0:
		line = line[0:explain] + '\n'
	if line[0:4] == 'INT2':
		flag = 1
		i -= 1
	if line[0:4] == 'END2':
		flag = 0
		i -= 1
	if line[0:2] == "lw":
		rt = findname(' $',',',line)
		offset = findname(',','($',line)
		rs = findname('($',')',line)
		code = '100011' + bin1(rs,5) + bin1(rt,5) + bin2(offset,16)
	if line[0:2] == "sw":
		rt = findname(' $',',',line)
		offset = findname(',','($',line)
		rs = findname('($',')',line)
		code = '101011' + bin1(rs,5) + bin1(rt,5) + bin2(offset,16)
	if line[0:3] == "lui":
		rt = findname(' $',',',line)
		imm = findname(',','\n',line)
		code = '001111' + '00000' + bin1(rt,5) + bin2(imm,16)
	if (line[0:3] == "add") & (line[3] == ' '):
		rd = findname(' $',',',line)
		rs = findname(',$',',',line)
		rt = findname(', $','\n',line)
		code = '000000' + bin1(rs,5) + bin1(rt,5) + bin1(rd,5) + '00000' + '100000'
	if line[0:4] == "addu":
		rd = findname(' $',',',line)
		rs = findname(',$',',',line)
		rt = findname(', $','\n',line)
		code = '000000' + bin1(rs,5) + bin1(rt,5) + bin1(rd,5) + '00000' + '100001'
	if (line[0:3] == "sub") & (line[3] == ' '):
		rd = findname(' $',',',line)
		rs = findname(',$',',',line)
		rt = findname(', $','\n',line)
		code = '000000' + bin1(rs,5) + bin1(rt,5) + bin1(rd,5) + '00000' + '100010'
	if line[0:4] == "subu":
		rd = findname(' $',',',line)
		rs = findname(',$',',',line)
		rt = findname(', $','\n',line)
		code = '000000' + bin1(rs,5) + bin1(rt,5) + bin1(rd,5) + '00000' + '100011'
	if (line[0:3] == "and") & (line[3] == ' '):
		rd = findname(' $',',',line)
		rs = findname(',$',',',line)
		rt = findname(', $','\n',line)
		code = '000000' + bin1(rs,5) + bin1(rt,5) + bin1(rd,5) + '00000' + '100100'
	if line[0:2] == "or":
		rd = findname(' $',',',line)
		rs = findname(',$',',',line)
		rt = findname(', $','\n',line)
		code = '000000' + bin1(rs,5) + bin1(rt,5) + bin1(rd,5) + '00000' + '100101'
	if line[0:3] == "xor":
		rd = findname(' $',',',line)
		rs = findname(',$',',',line)
		rt = findname(', $','\n',line)
		code = '000000' + bin1(rs,5) + bin1(rt,5) + bin1(rd,5) + '00000' + '100110'
	if line[0:3] == "nor":
		rd = findname(' $',',',line)
		rs = findname(',$',',',line)
		rt = findname(', $','\n',line)
		code = '000000' + bin1(rs,5) + bin1(rt,5) + bin1(rd,5) + '00000' + '100111'
	if (line[0:3] == "slt") & (line[3] == ' '):
		rd = findname(' $',',',line)
		rs = findname(',$',',',line)
		rt = findname(', $','\n',line)
		code = '000000' + bin1(rs,5) + bin1(rt,5) + bin1(rd,5) + '00000' + '101010'
	if line[0:4] == "sltu":
		rd = findname(' $',',',line)
		rs = findname(',$',',',line)
		rt = findname(', $','\n',line)
		code = '000000' + bin1(rs,5) + bin1(rt,5) + bin1(rd,5) + '00000' + '101011'
	if (line[0:4] == "addi") & (line[4] == ' '):
		rt = findname(' $',',',line)
		rs = findname(',$',',',line)
		imm = findname(', ','\n',line)
		code = '001000' + bin1(rs,5) + bin1(rt,5) + bin2(imm,16)
	if line[0:5] == "addiu":
		rt = findname(' $',',',line)
		rs = findname(',$',',',line)
		imm = findname(', ','\n',line)
		code = '001001' + bin1(rs,5) + bin1(rt,5) + bin2(imm,16)
	if line[0:4] == "andi":
		rt = findname(' $',',',line)
		rs = findname(',$',',',line)
		imm = findname(', ','\n',line)
		code = '001100' + bin1(rs,5) + bin1(rt,5) + bin2(imm,16)
	if (line[0:4] == "slti") & (line[4] == ' '):
		rt = findname(' $',',',line)
		rs = findname(',$',',',line)
		imm = findname(', ','\n',line)
		code = '001010' + bin1(rs,5) + bin1(rt,5) + bin2(imm,16)
	if line[0:5] == "sltiu":
		rt = findname(' $',',',line)
		rs = findname(',$',',',line)
		imm = findname(', ','\n',line)
		code = '001011' + bin1(rs,5) + bin1(rt,5) + bin2(imm,16)
	if line[0:3] == "sll":
		rd = findname(' $',',',line)
		rt = findname(',$',',',line)
		shamt = findname(', ','\n',line)
		code = '000000' + '00000' + bin1(rt,5) + bin1(rd,5) + bin2(shamt,5) + '000000'
	if line[0:3] == "srl":
		rd = findname(' $',',',line)
		rt = findname(',$',',',line)
		shamt = findname(', ','\n',line)
		code = '000000' + '00000' + bin1(rt,5) + bin1(rd,5) + bin2(shamt,5) + '000010'
	if line[0:3] == "sra":
		rd = findname(' $',',',line)
		rt = findname(',$',',',line)
		shamt = findname(', ','\n',line)
		code = '000000' + '00000' + bin1(rt,5) + bin1(rd,5) + bin2(shamt,5) + '000011'
	if line[0:3] == "beq":
		rs = findname(' $',',',line)
		rt = findname(',$',',',line)
		label = findname(', ','\n',line)
		offset = branch[branch.index(label)+1] - i
		offset = str(offset)
		code = '000100' + bin1(rs,5) + bin1(rt,5) + bin2(offset,16)
	if line[0:3] == "bne":
		rs = findname(' $',',',line)
		rt = findname(',$',',',line)
		label = findname(', ','\n',line)
		offset = branch[branch.index(label)+1] - i
		offset = str(offset)
		code = '000101' + bin1(rs,5) + bin1(rt,5) + bin2(offset,16)
	if line[0:4] == "bgez":
		rs = findname(' $',',',line)
		label = findname(',','\n',line)
		offset = branch[branch.index(label)+1] - i
		offset = str(offset)
		code = '000001' + bin1(rs,5) + '00001' + bin2(offset,16)
	if line[0:4] == "bgtz":
		rs = findname(' $',',',line)
		label = findname(',','\n',line)
		offset = branch[branch.index(label)+1] - i
		offset = str(offset)
		code = '000111' + bin1(rs,5) + '00000' + bin2(offset,16)
	if line[0:4] == "blez":
		rs = findname(' $',',',line)
		label = findname(',','\n',line)
		offset = branch[branch.index(label)+1] - i
		offset = str(offset)
		code = '000110' + bin1(rs,5) + '00000' + bin2(offset,16)
	if (line[0:1] == "j") & (line[1] == ' '):
		target = line[2:line.index('\n')]
		offset = branch[branch.index(target)+1]
		offset = str(offset)
		code = '000010' + bin2(offset,26)
	if (line[0:3] == "jal") & (line[3] == ' '):
		target = line[4:line.index('\n')]
		offset = branch[branch.index(target)+1]
		offset = str(offset)
		code = '000011' + bin2(offset,26)
	if line[0:2] == "jr":
		rs=line[4:line.index('\n')]
		code = '000000' + bin1(rs,5) + '000000000000000' + '001000'
	if line[0:4] == "jalr":
		rd = findname(' $',',',line)
		rs = findname(',$','\n',line)
		code = '000000' + bin1(rs,5) + '00000' + bin1(rd,5) + '00000' + '001001'
	if line[0:4] == 'INT1':
		tempadd = add
		add = ILLOP
	if line[0:3] == 'ERR':
		tempadd = add
		add = XADR
	if line[0:4] == 'END1':
		add = tempadd
	if (line[0:3] != 'INT') &  (line[0:3] != 'ERR') & (line[0:3] != 'END'):
		hat = bin(add)[2:].zfill(32)
		fo = open('rom.v','a')
		if flag == 1:
			hat = '1' + hat[1:]
		if judge == 1:
			fo.write('// ' + templabel + ':\n' )
		fo.write("32'b%s: data <= 32'b" % (hat))
		fo.write(code + ';' + '// '+ line)
		add += 4
		fo.close()
fp.close()

fo = open('rom.v','a')
fo.write("\n        default:	data <= 32'h0000_0008;\nendcase\nendmodule")

